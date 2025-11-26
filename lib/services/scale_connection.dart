import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../models/measurement.dart';
import 'scale_handlers/scale_handler.dart';

class ScaleConnection {
  final ScaleMatch match;
  final Stream<Measurement?> weightStream;
  final Future<void> Function() close;
  final BluetoothDevice? device;

  ScaleConnection({
    required this.match,
    required this.weightStream,
    required this.close,
    this.device,
  });
}
