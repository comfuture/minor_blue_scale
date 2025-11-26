import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../models/measurement.dart';
import 'scale_handler.dart';

/// Fallback handler for standard Weight Scale Service devices.
class GenericGattHandler implements ScaleHandler {
  static final Guid weightServiceUuid = Guid('0000181d-0000-1000-8000-00805f9b34fb');
  static final Guid weightCharUuid = Guid('00002a9d-0000-1000-8000-00805f9b34fb');

  static const _hints = [
    'scale',
    'body',
    'weight',
    'health',
    'smart',
    'mi',
    'xiaomi',
    'yunmai',
    'picooc',
    'yolanda',
    'renpho',
  ];

  @override
  String get id => 'generic_gatt';

  @override
  ScaleDeviceSupport? supportFor(ScanResult result) {
    final looksLikeScale = _looksLikeScale(result);
    if (!looksLikeScale) return null;

    final name = _deviceName(result);
    final display = name.isNotEmpty ? name : 'BLE 저울';
    return ScaleDeviceSupport(
      displayName: display,
      linkMode: ScaleLinkMode.gatt,
    );
  }

  @override
  Measurement? onAdvertisement(ScanResult result) => null;

  @override
  Future<Stream<Measurement?>?> connectAndListen(
    BluetoothDevice device,
    ScanResult originalResult,
  ) async {
    final services = await device.discoverServices();
    BluetoothCharacteristic? targetChar;

    for (final s in services) {
      if (s.uuid == weightServiceUuid) {
        for (final c in s.characteristics) {
          if (c.uuid == weightCharUuid) {
            targetChar = c;
            break;
          }
        }
      }
      if (targetChar != null) break;
    }

    targetChar ??= _fallbackCharacteristic(services);
    if (targetChar == null) return null;

    await targetChar.setNotifyValue(true);
    try {
      await targetChar.read();
    } catch (_) {}

    return targetChar.onValueReceived.map(_parseMeasurement);
  }

  BluetoothCharacteristic? _fallbackCharacteristic(List<BluetoothService> services) {
    for (final s in services) {
      for (final c in s.characteristics) {
        final props = c.properties;
        if ((props.notify || props.indicate) && c.properties.read) {
          return c;
        }
      }
    }
    return null;
  }

  Measurement? _parseMeasurement(List<int> data) {
    if (data.length < 3) return null;
    final raw = data[1] | (data[2] << 8);
    return Measurement(weightKg: raw / 200.0); // spec: 0.005kg
  }

  bool _looksLikeScale(ScanResult r) {
    final name = _deviceName(r).toLowerCase();
    return _hints.any(name.contains) || r.advertisementData.serviceUuids.contains(weightServiceUuid);
  }

  String _deviceName(ScanResult r) {
    final platformName = r.device.platformName;
    return platformName.isNotEmpty ? platformName : r.advertisementData.advName;
  }
}
