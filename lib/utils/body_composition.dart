import '../models/gender.dart';
import '../models/measurement.dart';

class BodyComposition {
  final double? bmi;
  final double? bodyFatPercent;
  final double? bodyFatKg;
  final double? musclePercent;
  final double? muscleKg;

  const BodyComposition({
    this.bmi,
    this.bodyFatPercent,
    this.bodyFatKg,
    this.musclePercent,
    this.muscleKg,
  });
}

class BodyCompositionCalculator {
  /// Derive composition values from a measurement + user info.
  static BodyComposition derive({
    required Measurement measurement,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    final heightM = heightCm > 0 ? heightCm / 100.0 : null;
    final bmi = (heightM != null && heightM > 0)
        ? measurement.weightKg / (heightM * heightM)
        : null;

    double? bodyFatPercent;
    double? bodyFatKg;
    double? muscleKg;
    double? musclePercent;

    final sexConst = gender == Gender.male ? 1 : 0;

    // Prefer impedance-based estimate when available.
    if (measurement.impedanceOhm != null &&
        measurement.impedanceOhm! > 0 &&
        heightM != null &&
        heightM > 0) {
      final h2 = heightM * heightM;
      final imp = measurement.impedanceOhm!.toDouble();
      double ffm; // fat-free mass
      if (gender == Gender.male) {
        ffm = 0.88 * (h2 * 1000 / imp) + 0.17 * measurement.weightKg + 0.08 * age + 4.1;
      } else if (gender == Gender.female) {
        ffm = 0.65 * (h2 * 1000 / imp) + 0.17 * measurement.weightKg + 0.06 * age + 2.6;
      } else {
        ffm = 0.76 * (h2 * 1000 / imp) + 0.17 * measurement.weightKg + 0.07 * age + 3.3;
      }
      ffm = ffm.clamp(0, measurement.weightKg).toDouble();
      bodyFatKg = (measurement.weightKg - ffm).clamp(0, measurement.weightKg).toDouble();
      bodyFatPercent = (bodyFatKg / measurement.weightKg) * 100;
      muscleKg = ffm * 0.53; // rough skeletal muscle fraction of FFM
      musclePercent = (muscleKg / measurement.weightKg) * 100;
    } else if (bmi != null && age > 0) {
      // Deurenberg formula as fallback (no impedance).
      bodyFatPercent =
          (1.2 * bmi + 0.23 * age - 10.8 * sexConst - 5.4).clamp(2.0, 75.0).toDouble();
      bodyFatKg = measurement.weightKg * bodyFatPercent / 100.0;
      muscleKg = measurement.weightKg - bodyFatKg;
      musclePercent = 100.0 - bodyFatPercent;
    }

    return BodyComposition(
      bmi: bmi,
      bodyFatPercent: bodyFatPercent,
      bodyFatKg: bodyFatKg,
      musclePercent: musclePercent,
      muscleKg: muscleKg,
    );
  }
}
