enum Gender {
  male,
  female,
  none;

  static Gender fromKey(String? key) {
    switch (key) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.none;
    }
  }
}

extension GenderLabel on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return '남성';
      case Gender.female:
        return '여성';
      case Gender.none:
        return '기타';
    }
  }

  String get key => toString().split('.').last;
}
