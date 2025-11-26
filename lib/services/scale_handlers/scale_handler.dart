import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../models/measurement.dart';

/// How a scale delivers its data.
enum ScaleLinkMode { gatt, broadcastOnly }

/// Minimal information about a handler's support for a device.
class ScaleDeviceSupport {
  final String displayName;
  final ScaleLinkMode linkMode;

  const ScaleDeviceSupport({required this.displayName, required this.linkMode});
}

/// Pairing of scan result with a specific handler implementation.
class ScaleMatch {
  final ScanResult result;
  final ScaleHandler handler;
  final ScaleDeviceSupport support;

  const ScaleMatch({required this.result, required this.handler, required this.support});

  BluetoothDevice get device => result.device;
  String get displayName => support.displayName;
  ScaleLinkMode get linkMode => support.linkMode;
}

abstract class ScaleHandler {
  String get id;

  /// Returns null when the handler does not support the given device.
  ScaleDeviceSupport? supportFor(ScanResult result);

  /// Called whenever an advertisement for the matched device is received.
  /// Should return the parsed measurement when available.
  Measurement? onAdvertisement(ScanResult result) => null;

  /// For GATT based devices, discover characteristics and return a weight stream.
  /// The device is already connected when this method is invoked.
  Future<Stream<Measurement?>?> connectAndListen(
    BluetoothDevice device,
    ScanResult originalResult,
  );
}
