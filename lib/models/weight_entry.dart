class WeightEntry {
  final String id;
  final String userId;
  final double weightKg;
  final DateTime recordedAt;
  final String? deviceName;
  final int? impedanceOhm;
  final double? bmi;
  final double? bodyFatPercent;
  final double? bodyFatKg;
  final double? musclePercent;
  final double? muscleKg;

  WeightEntry({
    required this.id,
    required this.userId,
    required this.weightKg,
    required this.recordedAt,
    this.deviceName,
    this.impedanceOhm,
    this.bmi,
    this.bodyFatPercent,
    this.bodyFatKg,
    this.musclePercent,
    this.muscleKg,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'weightKg': weightKg,
        'recordedAt': recordedAt.toIso8601String(),
        'deviceName': deviceName,
        'impedanceOhm': impedanceOhm,
        'bmi': bmi,
        'bodyFatPercent': bodyFatPercent,
        'bodyFatKg': bodyFatKg,
        'musclePercent': musclePercent,
        'muscleKg': muscleKg,
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        id: json['id'] as String,
        userId: json['userId'] as String,
        weightKg: (json['weightKg'] as num).toDouble(),
        recordedAt: DateTime.parse(json['recordedAt'] as String),
        deviceName: json['deviceName'] as String?,
        impedanceOhm: json['impedanceOhm'] as int?,
        bmi: (json['bmi'] as num?)?.toDouble(),
        bodyFatPercent: (json['bodyFatPercent'] as num?)?.toDouble(),
        bodyFatKg: (json['bodyFatKg'] as num?)?.toDouble(),
        musclePercent: (json['musclePercent'] as num?)?.toDouble(),
        muscleKg: (json['muscleKg'] as num?)?.toDouble(),
      );
}
