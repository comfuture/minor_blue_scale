import 'gender.dart';

class UserProfile {
  final String id;
  final String nickname;
  final Gender gender;
  final int age;
  final double heightCm;
  final double? targetWeight;
  final bool isGuest;

  const UserProfile({
    required this.id,
    required this.nickname,
    required this.gender,
    required this.age,
    required this.heightCm,
    this.targetWeight,
    this.isGuest = false,
  });

  factory UserProfile.guest() => const UserProfile(
        id: 'guest',
        nickname: 'Guest',
        gender: Gender.none,
        age: 0,
        heightCm: 0,
        isGuest: true,
      );

  UserProfile copyWith({
    String? nickname,
    Gender? gender,
    int? age,
    double? heightCm,
    double? targetWeight,
    bool? isGuest,
  }) {
    return UserProfile(
      id: id,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      targetWeight: targetWeight ?? this.targetWeight,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'gender': gender.key,
        'age': age,
        'heightCm': heightCm,
        'targetWeight': targetWeight,
        'isGuest': isGuest,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      gender: Gender.fromKey(json['gender'] as String?),
      age: (json['age'] ?? 0) as int,
      heightCm: (json['heightCm'] ?? 0).toDouble(),
      targetWeight: (json['targetWeight'] != null)
          ? (json['targetWeight'] as num).toDouble()
          : null,
      isGuest: json['isGuest'] == true,
    );
  }
}
