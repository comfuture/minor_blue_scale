import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../models/measurement.dart';
import 'scale_handler.dart';

enum _MiVariant { v1, v2 }

/// Xiaomi Mi Scale (v1/v2) handler (live weight only).
class MiScaleHandler implements ScaleHandler {
  MiScaleHandler();

  // Services / characteristics
  static final Guid _serviceBodyComp = Guid('0000181b-0000-1000-8000-00805f9b34fb');
  static final Guid _serviceWeight = Guid('0000181d-0000-1000-8000-00805f9b34fb');
  static final Guid _serviceMiCfg = Guid('00001530-0000-3512-2118-0009af100700');

  static final Guid _charCurrentTime = Guid('00002a2b-0000-1000-8000-00805f9b34fb');
  static final Guid _charWeightMeas = Guid('00002a9d-0000-1000-8000-00805f9b34fb');
  static final Guid _charMiHistory = Guid('00002a2f-0000-3512-2118-0009af100700');

  static const _enableHistoryMagic = [0x01, 0x96, 0x8A, 0xBD, 0x62];

  @override
  String get id => 'xiaomi_mi_scale';

  @override
  ScaleDeviceSupport? supportFor(ScanResult result) {
    final name = _deviceName(result).toUpperCase();
    final services = result.advertisementData.serviceUuids;

    final isKnownName = name.startsWith('MIBCS') ||
        name.startsWith('MIBFS') ||
        name == 'MI SCALE2' ||
        name.startsWith('MI_SCALE');
    if (!isKnownName) return null;

    final looksV2 = services.contains(_serviceMiCfg) ||
        name.startsWith('MIBCS') ||
        name.startsWith('MIBFS') ||
        name == 'MI SCALE2';
    final variant = looksV2 ? _MiVariant.v2 : _MiVariant.v1;

    return ScaleDeviceSupport(
      displayName: variant == _MiVariant.v2 ? 'Xiaomi Mi Scale v2' : 'Xiaomi Mi Scale v1',
      linkMode: ScaleLinkMode.gatt,
    );
  }

  @override
  Measurement? onAdvertisement(ScanResult result) => null; // broadcast not used

  @override
  Future<Stream<Measurement?>?> connectAndListen(
    BluetoothDevice device,
    ScanResult originalResult,
  ) async {
    final variant = _variantFor(originalResult);
    final services = await device.discoverServices();

    // Find primary history characteristic (v2 prefers body-comp, v1 weight service)
    final preferredService = variant == _MiVariant.v2 ? _serviceBodyComp : _serviceWeight;
    BluetoothCharacteristic? historyChar = _findChar(services, _charMiHistory, preferredService) ??
        _findChar(services, _charMiHistory, null);
    historyChar ??= _findChar(services, _charWeightMeas, null); // rare but try
    if (historyChar == null) return null;

    await historyChar.setNotifyValue(true);

    // Optional: current time write if present
    final timeChar = _findChar(services, _charCurrentTime, null);
    if (timeChar != null) {
      await _writeIfSupported(timeChar, _currentTimePayload());
    }

    // Enable history/live stream best effort
    await _writeIfSupported(historyChar, _enableHistoryMagic);
    final uniq = DateTime.now().millisecondsSinceEpoch & 0xFFFF;
    await _writeIfSupported(historyChar, [0x01, 0xFF, 0xFF, uniq >> 8, uniq & 0xFF]);
    await _writeIfSupported(historyChar, [0x02]);

    final controller = StreamController<Measurement?>();
    final sub = historyChar.onValueReceived.listen((data) {
      for (final m in _parsePayload(data)) {
        if (m != null) controller.add(m);
      }
    });

    controller.onCancel = () async {
      await sub.cancel();
    };

    return controller.stream;
  }

  // ---- parsing -----------------------------------------------------------

  Iterable<Measurement?> _parsePayload(List<int> data) sync* {
    if (data.length == 13) {
      final m = _parseLive13(data);
      if (m != null) yield m;
      return;
    }
    if (data.length == 26) {
      final mA = _parseLive13(data.sublist(0, 13));
      final mB = _parseLive13(data.sublist(13, 26));
      if (mA != null) yield mA;
      if (mB != null) yield mB;
      return;
    }
    if (data.length % 10 == 0) {
      for (var off = 0; off < data.length; off += 10) {
        final m = _parseHistory10(data.sublist(off, off + 10));
        if (m != null) yield m;
      }
    }
  }

  Measurement? _parseLive13(List<int> d) {
    if (d.length != 13) return null;
    final c0 = d[0];
    final c1 = d[1];
    final isLbs = (c0 & 0x01) != 0;
    final isCatty = (c1 & 0x40) != 0;
    final stable = (c1 & 0x20) != 0;
    final removed = (c1 & 0x80) != 0;
    if (!stable || removed) return null;

    final weightRaw = (d[12] << 8) | d[11];
    final native = (isLbs || isCatty) ? weightRaw / 100.0 : weightRaw / 200.0;
    final kg = _toKg(native, isLbs: isLbs, isCatty: isCatty);
    final imp = (d[10] << 8) | d[9];
    return Measurement(weightKg: kg, impedanceOhm: imp > 0 ? imp : null);
  }

  Measurement? _parseHistory10(List<int> d) {
    if (d.length != 10) return null;
    final status = d[0];
    final isLbs = (status & 0x01) != 0;
    final isCatty = (status & 0x10) != 0;
    final stable = (status & 0x20) != 0;
    final removed = (status & 0x80) != 0;
    if (!stable || removed) return null;

    final weightRaw = (d[2] << 8) | d[1];
    final native = (isLbs || isCatty) ? weightRaw / 100.0 : weightRaw / 200.0;
    final kg = _toKg(native, isLbs: isLbs, isCatty: isCatty);
    return Measurement(weightKg: kg);
  }

  double _toKg(double native, {required bool isLbs, required bool isCatty}) {
    if (isLbs) return native / 2.204623;
    if (isCatty) return native * 0.5; // 1 jin ≈ 0.5 kg
    return native; // already kg
  }

  // ---- helpers -----------------------------------------------------------

  _MiVariant _variantFor(ScanResult r) {
    final name = _deviceName(r).toUpperCase();
    final services = r.advertisementData.serviceUuids;
    final looksV2 = services.contains(_serviceMiCfg) ||
        name.startsWith('MIBCS') ||
        name.startsWith('MIBFS') ||
        name == 'MI SCALE2';
    return looksV2 ? _MiVariant.v2 : _MiVariant.v1;
  }

  String _deviceName(ScanResult r) {
    final platformName = r.device.platformName;
    return platformName.isNotEmpty ? platformName : r.advertisementData.advName;
  }

  BluetoothCharacteristic? _findChar(
    List<BluetoothService> services,
    Guid charUuid,
    Guid? preferredService,
  ) {
    BluetoothCharacteristic? fallback;
    for (final s in services) {
      for (final c in s.characteristics) {
        if (c.uuid == charUuid) {
          if (preferredService == null || s.uuid == preferredService) {
            return c;
          }
          fallback ??= c;
        }
      }
    }
    return fallback;
  }

  Future<void> _writeIfSupported(BluetoothCharacteristic c, List<int> data) async {
    try {
      if (c.properties.write) {
        await c.write(data, withoutResponse: false);
      } else if (c.properties.writeWithoutResponse) {
        await c.write(data, withoutResponse: true);
      }
    } catch (_) {
      // ignore
    }
  }

  List<int> _currentTimePayload() {
    final now = DateTime.now().toUtc();
    final year = now.year;
    return [
      year & 0xFF,
      (year >> 8) & 0xFF,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
      0x00,
      0x00,
      0x01,
    ];
  }
}
