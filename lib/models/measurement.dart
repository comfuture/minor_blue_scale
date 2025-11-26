class Measurement {
  final double weightKg;
  final int? impedanceOhm;

  const Measurement({
    required this.weightKg,
    this.impedanceOhm,
  });

  Measurement copyWith({
    double? weightKg,
    int? impedanceOhm,
  }) {
    return Measurement(
      weightKg: weightKg ?? this.weightKg,
      impedanceOhm: impedanceOhm ?? this.impedanceOhm,
    );
  }
}
