import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../models/measurement.dart';
import '../models/stored_broadcast_scale.dart';
import 'scale_connection.dart';
import 'scale_handlers/generic_gatt_handler.dart';
import 'scale_handlers/mi_scale_handler.dart';
import 'scale_handlers/okok_handler.dart';
import 'scale_handlers/scale_handler.dart';

class BleScaleService {
  BleScaleService({List<ScaleHandler>? handlers})
      : handlers = handlers ?? [OkOkHandler(), MiScaleHandler(), GenericGattHandler()];

  final List<ScaleHandler> handlers;

  Future<List<ScaleMatch>> scanForScales({
    Duration timeout = const Duration(seconds: 8),
    bool onlyLikelyScales = true,
  }) async {
    final results = <ScaleMatch>[];
    final seen = <DeviceIdentifier>{};

    final sub = FlutterBluePlus.scanResults.listen((batch) {
      for (final r in batch) {
        if (!seen.add(r.device.remoteId)) continue;
        final match = _match(r);
        if (match != null) results.add(match);
      }
    });

    await FlutterBluePlus.startScan(timeout: timeout, continuousUpdates: true);
    await Future.delayed(timeout);
    await FlutterBluePlus.stopScan();
    await sub.cancel();
    return results;
  }

  ScaleMatch? _match(ScanResult r) {
    for (final h in handlers) {
      final support = h.supportFor(r);
      if (support != null) {
        return ScaleMatch(result: r, handler: h, support: support);
      }
    }
    return null;
  }

  Future<ScaleConnection?> connect(ScaleMatch match) async {
    if (match.linkMode == ScaleLinkMode.broadcastOnly) {
      return _connectBroadcast(match);
    }

    final device = match.device;
    await FlutterBluePlus.stopScan();
    await device.connect(timeout: const Duration(seconds: 10));

    final stream = await match.handler.connectAndListen(device, match.result);
    if (stream == null) {
      await device.disconnect();
      return null;
    }

    return ScaleConnection(
      match: match,
      device: device,
      weightStream: stream,
      close: () async {
        try {
          await device.disconnect();
        } catch (_) {}
      },
    );
  }

  Future<ScaleConnection> _connectBroadcast(ScaleMatch match) async {
    // Restart scan filtered for the selected device to receive continuous frames.
    await FlutterBluePlus.startScan(
      withRemoteIds: [match.device.remoteId.str],
      continuousUpdates: true,
      removeIfGone: const Duration(seconds: 3),
    );

    final controller = StreamController<Measurement?>();
    final sub = FlutterBluePlus.scanResults.listen((batch) {
      for (final r in batch) {
        if (r.device.remoteId == match.device.remoteId) {
          final m = match.handler.onAdvertisement(r);
          if (m != null) controller.add(m);
        }
      }
    });

    return ScaleConnection(
      match: match,
      device: null,
      weightStream: controller.stream,
      close: () async {
        await sub.cancel();
        await FlutterBluePlus.stopScan();
        await controller.close();
      },
    );
  }

  Future<ScaleConnection?> connectSavedBroadcast(StoredBroadcastScale saved) async {
    final handler = handlers.firstWhere(
      (h) => h.id == saved.handlerId,
      orElse: () => handlers.first,
    );

    final adv = AdvertisementData(
      advName: saved.displayName,
      txPowerLevel: null,
      appearance: null,
      connectable: false,
      manufacturerData: const {},
      serviceData: const {},
      serviceUuids: const [],
    );
    final device = BluetoothDevice.fromId(saved.remoteId);
    final match = ScaleMatch(
      result: ScanResult(
        device: device,
        advertisementData: adv,
        rssi: 0,
        timeStamp: DateTime.now(),
      ),
      handler: handler,
      support: ScaleDeviceSupport(
        displayName: saved.displayName,
        linkMode: ScaleLinkMode.broadcastOnly,
      ),
    );
    return _connectBroadcast(match);
  }
}
