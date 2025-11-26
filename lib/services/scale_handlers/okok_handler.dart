import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../models/measurement.dart';
import 'scale_handler.dart';

/// OKOK broadcast-only scale handler
class OkOkHandler implements ScaleHandler {
  OkOkHandler();

  // Known manufacturer ids
  static const _manufV20 = 0x20ca;
  static const _manufV11 = 0x11ca;
  static const _manufVF0 = 0xf0ff;

  // V20 indices
  static const _idxV20Final = 6;
  static const _idxV20WeightMsb = 8;
  static const _idxV20WeightLsb = 9;
  static const _idxV20ImpedanceMsb = 10;
  static const _idxV20ImpedanceLsb = 11;
  static const _idxV20Checksum = 12;

  // V11 indices
  static const _idxV11WeightMsb = 3;
  static const _idxV11WeightLsb = 4;
  static const _idxV11BodyProps = 9;
  static const _idxV11Checksum = 16;

  // VF0 indices
  static const _idxVf0WeightMsb = 3;
  static const _idxVf0WeightLsb = 2;

  // Nameless/0xC0 indices
  static const _idxWeightMsb = 0;
  static const _idxWeightLsb = 1;
  static const _idxAttrib = 6;
  static const _unitKg = 0;
  static const _unitLb = 2;
  static const _unitStLb = 3;

  @override
  String get id => 'okok';

  @override
  ScaleDeviceSupport? supportFor(ScanResult result) {
    final m = result.advertisementData.manufacturerData;
    if (m.isEmpty) return null;

    final name = _deviceName(result);
    final supports =
        name == 'NoName OkOk' || name == 'ADV' || name == 'Chipsea-BLE';
    if (!supports) return null;

    final variantName = () {
      if (_hasKey(m, _manufV20)) return 'OKOK V20';
      if (_hasKey(m, _manufV11)) return 'OKOK V11';
      if (_hasKey(m, _manufVF0)) return 'OKOK VF0';
      if (_containsLowByteC0(m)) return 'OKOK Nameless';
      return null;
    }();

    if (variantName == null) return null;

    return ScaleDeviceSupport(
      displayName: variantName,
      linkMode: ScaleLinkMode.broadcastOnly,
    );
  }

  @override
  Measurement? onAdvertisement(ScanResult result) {
    final m = result.advertisementData.manufacturerData;
    if (m.isEmpty) return null;

    return _parseV20(m) ?? _parseV11(m) ?? _parseVF0(m) ?? _parseNameless(m);
  }

  @override
  Future<Stream<Measurement?>?> connectAndListen(
    BluetoothDevice device,
    ScanResult originalResult,
  ) async {
    // Broadcast only: no GATT session.
    return null;
  }

  // --- Parsers -------------------------------------------------------------

  Measurement? _parseV20(Map<int, List<int>> m) {
    final data = m[_manufV20];
    if (data == null || data.length != 19) return null;

    final finalFlag = (data[_idxV20Final] & 0x01) != 0;
    if (!finalFlag) return null;

    // XOR checksum including implicit version 0x20
    var checksum = 0x20;
    for (var i = 0; i < _idxV20Checksum; i++) {
      checksum ^= data[i] & 0xFF;
    }
    final got = data[_idxV20Checksum] & 0xFF;
    if (got != (checksum & 0xFF)) return null;

    final divider = (data[_idxV20Final] & 0x04) != 0 ? 100.0 : 10.0;
    final weightRaw = _u16be(data[_idxV20WeightMsb], data[_idxV20WeightLsb]);
    final impedance = _u16be(
      data[_idxV20ImpedanceMsb],
      data[_idxV20ImpedanceLsb],
    );
    return Measurement(
      weightKg: weightRaw / divider,
      impedanceOhm: impedance > 0 ? impedance : null,
    );
  }

  Measurement? _parseV11(Map<int, List<int>> m) {
    final data = m[_manufV11];
    if (data == null || data.length != _idxV11Checksum + 6 + 1) return null;

    var checksum = 0xCA ^ 0x11;
    for (var i = 0; i < _idxV11Checksum; i++) {
      checksum ^= data[i] & 0xFF;
    }
    final got = data[_idxV11Checksum] & 0xFF;
    if (got != (checksum & 0xFF)) return null;

    final props = data[_idxV11BodyProps] & 0xFF;

    double divider;
    switch ((props >> 1) & 0x3) {
      case 0:
        divider = 10.0;
        break;
      case 1:
        divider = 1.0;
        break;
      case 2:
        divider = 100.0;
        break;
      default:
        divider = 10.0;
    }

    final weight = _u16be(data[_idxV11WeightMsb], data[_idxV11WeightLsb]);
    switch ((props >> 3) & 0x3) {
      case 0:
        return Measurement(weightKg: weight / divider); // kg
      case 1:
        return Measurement(
          weightKg: weight / (divider * 2.0),
        ); // jin -> kg approx
      case 2:
        return Measurement(weightKg: (weight / divider) / 2.204623); // lb -> kg
      case 3:
        final stones = weight >> 8;
        final pounds = (weight & 0xFF) / divider;
        return Measurement(weightKg: stones * 6.350293 + pounds * 0.453592);
      default:
        return null;
    }
  }

  Measurement? _parseVF0(Map<int, List<int>> m) {
    final data = m[_manufVF0];
    if (data == null || data.length < 4) return null;
    final raw = _u16be(data[_idxVf0WeightMsb], data[_idxVf0WeightLsb]);
    return Measurement(weightKg: raw / 10.0);
  }

  Measurement? _parseNameless(Map<int, List<int>> m) {
    final key = _firstKeyWithLowByteC0(m);
    if (key == null) return null;
    final data = m[key];
    if (data == null || data.length < 13) return null;

    final attrib = data[_idxAttrib] & 0xFF;
    final isStable = (attrib & 0x01) != 0;
    if (!isStable) return null;

    double divider;
    switch ((attrib >> 1) & 0x3) {
      case 0:
        divider = 10.0;
        break;
      case 1:
        divider = 1.0;
        break;
      case 2:
        divider = 100.0;
        break;
      default:
        divider = 10.0;
    }

    switch ((attrib >> 3) & 0x3) {
      case _unitKg:
        return Measurement(
          weightKg: _u16be(data[_idxWeightMsb], data[_idxWeightLsb]) / divider,
        );
      case _unitLb:
        final raw = _u16be(data[_idxWeightMsb], data[_idxWeightLsb]);
        return Measurement(weightKg: (raw / divider) / 2.204623);
      case _unitStLb:
        final stones = data[_idxWeightMsb] & 0xFF;
        final pounds = (data[_idxWeightLsb] & 0xFF) / divider;
        return Measurement(weightKg: stones * 6.350293 + pounds * 0.453592);
      default:
        return null;
    }
  }

  // --- utils ---------------------------------------------------------------

  String _deviceName(ScanResult r) {
    final platformName = r.device.platformName;
    return platformName.isNotEmpty ? platformName : r.advertisementData.advName;
  }

  bool _hasKey(Map<int, List<int>> m, int key) => m.containsKey(key);

  bool _containsLowByteC0(Map<int, List<int>> m) =>
      m.keys.any((k) => (k & 0xFF) == 0xC0);

  int? _firstKeyWithLowByteC0(Map<int, List<int>> m) {
    for (final k in m.keys) {
      if ((k & 0xFF) == 0xC0) return k;
    }
    return null;
  }

  int _u16be(int msb, int lsb) => ((msb & 0xFF) << 8) | (lsb & 0xFF);
}
