import 'package:minor_blue_scale/l10n/app_localizations.dart';

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
  String label(AppLocalizations l10n) {
    switch (this) {
      case Gender.male:
        return l10n.genderMale;
      case Gender.female:
        return l10n.genderFemale;
      case Gender.none:
        return l10n.genderOther;
    }
  }

  String get key => toString().split('.').last;
}
