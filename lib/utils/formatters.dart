import 'package:intl/intl.dart';

class Formatters {
  static String day(DateTime date, {required String locale}) {
    return DateFormat.MMMd(locale).format(date);
  }

  static String dayWithTime(DateTime date, {required String locale}) {
    return DateFormat.MMMd(locale).add_Hm().format(date);
  }

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
