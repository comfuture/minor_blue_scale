import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat day = DateFormat('M월 d일');
  static final DateFormat dayWithTime = DateFormat('M월 d일 HH:mm');

  static String weight(double? kg) {
    if (kg == null) return '--.-- kg';
    return '${kg.toStringAsFixed(2)} kg';
  }

  static String percent(double? v) {
    if (v == null) return '--.- %';
    return '${v.toStringAsFixed(1)} %';
  }

  static String mass(double? kg) {
    if (kg == null) return '--.-- kg';
    return '${kg.toStringAsFixed(2)} kg';
  }
}
