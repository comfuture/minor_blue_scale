import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/connection_status.dart';
import '../models/measurement.dart';
import '../models/stored_broadcast_scale.dart';
import '../services/ble_scale_service.dart';
import '../services/scale_connection.dart';
import '../services/scale_handlers/scale_handler.dart';
import '../services/local_storage_service.dart';

class ScaleProvider extends ChangeNotifier {
  final BleScaleService ble;
  final LocalStorageService storage;

  StoredBroadcastScale? _storedBroadcast;

  ScaleProvider(this.ble, this.storage) {
    _loadStoredBroadcast();
  }

  List<ScaleMatch> scanResults = [];
  ConnectionStatus status = ConnectionStatus.idle;
  ScaleMatch? connectedMatch;
  BluetoothDevice? connectedDevice;
  Measurement? liveMeasurement;
  bool capturing = false;
  String? errorMessage;

  ScaleConnection? _session;
  StreamSubscription<Measurement?>? _weightSub;
  StreamSubscription<BluetoothConnectionState>? _connSub;
  final List<_TimedMeasurement> _recent = [];
  final List<Measurement> _captureBuffer = [];
  bool get hasStoredBroadcast => _storedBroadcast != null;

  Future<void> scan() async {
    final ok = await _ensurePermissions();
    if (!ok) {
      errorMessage = '블루투스 스캔 권한이 필요합니다.';
      status = ConnectionStatus.error;
      notifyListeners();
      return;
    }
    status = ConnectionStatus.scanning;
    errorMessage = null;
    liveMeasurement = null;
    notifyListeners();
    try {
      scanResults = await ble.scanForScales();
      if (scanResults.isEmpty) {
        // fallback: 재검색 시 사용자에게 힌트 제공
        errorMessage = '주변에서 저울을 찾지 못했습니다. 전원을 켜고 더 가까이에서 다시 시도하세요.';
      } else {
        errorMessage = null;
      }
    } catch (e) {
      errorMessage = '스캔 실패: $e';
      status = ConnectionStatus.error;
      notifyListeners();
      return;
    }
    status = ConnectionStatus.idle;
    notifyListeners();
  }

  String? get connectedName => connectedMatch?.displayName ?? connectedDevice?.platformName;
  String? get storedBroadcastName => _storedBroadcast?.displayName;

  Future<void> connect(ScaleMatch match) async {
    status = ConnectionStatus.connecting;
    errorMessage = null;
    notifyListeners();
    try {
      final session = await ble.connect(match);
      if (session == null) {
        status = ConnectionStatus.error;
        errorMessage = '체중 characteristic을 찾지 못했습니다.';
        notifyListeners();
        return;
      }

      _session = session;
      connectedMatch = session.match;
      connectedDevice = session.device;
      if (session.match.linkMode == ScaleLinkMode.broadcastOnly) {
        final remoteId = session.match.device.remoteId.str;
        await storage.setLastBroadcastScale(
          remoteId: remoteId,
          displayName: session.match.displayName,
          handlerId: session.match.handler.id,
        );
        _storedBroadcast = StoredBroadcastScale(
          remoteId: remoteId,
          displayName: session.match.displayName,
          handlerId: session.match.handler.id,
        );
      }

      _connSub?.cancel();
      if (connectedDevice != null) {
        _connSub = connectedDevice!.connectionState.listen((state) async {
          if (state == BluetoothConnectionState.disconnected) {
            await disconnect();
          }
        });
      }

      _weightSub?.cancel();
      status = ConnectionStatus.connected;
      _weightSub = session.weightStream.listen((value) {
        if (value != null) {
          final now = DateTime.now();
          _recent.add(_TimedMeasurement(now, value));
          _recent.removeWhere((e) => now.difference(e.time) > const Duration(seconds: 5));
          if (capturing) {
            _captureBuffer.add(value);
          }
          liveMeasurement = value;
        }
        status = ConnectionStatus.connected;
        notifyListeners();
      });
    } catch (e) {
      status = ConnectionStatus.error;
      errorMessage = '연결 실패: $e';
    }
    notifyListeners();
  }

  Future<void> disconnect() async {
    _weightSub?.cancel();
    _connSub?.cancel();
    if (_session != null) {
      await _session!.close();
      _session = null;
    }
    capturing = false;
    _captureBuffer.clear();
    connectedDevice = null;
    connectedMatch = null;
    status = ConnectionStatus.idle;
    liveMeasurement = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _weightSub?.cancel();
    _connSub?.cancel();
    _session?.close();
    super.dispose();
  }

  Future<void> takeStableMeasurement({
    Duration window = const Duration(seconds: 3),
    Duration waitForBroadcast = const Duration(seconds: 12),
  }) async {
    if (_session == null && _storedBroadcast != null) {
      await _connectStoredBroadcast();
    }
    if (_session == null) return;
    capturing = true;
    _captureBuffer.clear();
    notifyListeners();

    // Wait for first packet (scale may power on when user steps up)
    final gotFirst = await _waitForFirstMeasurement(timeout: waitForBroadcast);
    if (!gotFirst) {
      capturing = false;
      errorMessage = '저울 브로드캐스트를 받지 못했습니다. 체중계에 올라선 뒤 다시 시도하세요.';
      notifyListeners();
      return;
    }

    // Collect for stability window
    await Future.delayed(window);
    capturing = false;
    final stable = _stableFrom(_captureBuffer);
    if (stable != null) {
      liveMeasurement = stable;
    }
    _captureBuffer.clear();
    notifyListeners();
  }

  void cancelCapture() {
    capturing = false;
    _captureBuffer.clear();
    notifyListeners();
  }

  Future<bool> _waitForFirstMeasurement({required Duration timeout}) async {
    final deadline = DateTime.now().add(timeout);
    while (_captureBuffer.isEmpty && DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return _captureBuffer.isNotEmpty;
  }

  Future<void> _connectStoredBroadcast() async {
    final saved = _storedBroadcast;
    if (saved == null) return;
    status = ConnectionStatus.connecting;
    notifyListeners();
    try {
      final session = await ble.connectSavedBroadcast(saved);
      if (session == null) {
        status = ConnectionStatus.error;
        errorMessage = '저장된 저울에 연결하지 못했습니다.';
        notifyListeners();
        return;
      }
      _session = session;
      connectedMatch = session.match;
      connectedDevice = session.device;
      _weightSub?.cancel();
      status = ConnectionStatus.connected;
      _weightSub = session.weightStream.listen((value) {
        if (value != null) {
          final now = DateTime.now();
          _recent.add(_TimedMeasurement(now, value));
          _recent.removeWhere((e) => now.difference(e.time) > const Duration(seconds: 5));
          if (capturing) {
            _captureBuffer.add(value);
          }
          liveMeasurement = value;
        }
        status = ConnectionStatus.connected;
        notifyListeners();
      });
    } catch (e) {
      status = ConnectionStatus.error;
      errorMessage = '저장된 저울 연결 실패: $e';
    }
    notifyListeners();
  }

  Measurement? _stableFrom(List<Measurement> list) {
    if (list.isEmpty) return null;
    list.sort((a, b) => a.weightKg.compareTo(b.weightKg));
    final minW = list.first.weightKg;
    final maxW = list.last.weightKg;
    if ((maxW - minW) > 0.3) return null; // unstable measurements
    final mid = list[list.length ~/ 2];
    final impList =
        list.where((e) => e.impedanceOhm != null).map((e) => e.impedanceOhm!).toList()..sort();
    int? imp;
    if (impList.isNotEmpty) {
      imp = impList[impList.length ~/ 2];
    }
    return Measurement(weightKg: mid.weightKg, impedanceOhm: imp ?? mid.impedanceOhm);
  }

  Future<bool> _ensurePermissions() async {
    if (!Platform.isAndroid) return true;

    // 안드로이드 12+: BLUETOOTH_SCAN/CONNECT, 이하 버전에서는 location 필요
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    if (statuses[Permission.bluetoothScan]?.isGranted != true) return false;
    if (statuses[Permission.bluetoothConnect]?.isGranted != true) return false;

    return true;
  }

  void _loadStoredBroadcast() {
    final raw = storage.getLastBroadcastScale();
    if (raw == null) return;
    _storedBroadcast = StoredBroadcastScale(
      remoteId: raw['remoteId'] as String,
      displayName: raw['displayName'] as String,
      handlerId: raw['handlerId'] as String,
    );
  }
}

class _TimedMeasurement {
  final DateTime time;
  final Measurement value;
  _TimedMeasurement(this.time, this.value);
}
