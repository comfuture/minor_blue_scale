// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bluetooth Scale';

  @override
  String get splashLoading => 'Preparing the app...';

  @override
  String get statusIdle => 'Idle';

  @override
  String get statusScanning => 'Scanning';

  @override
  String get statusConnecting => 'Connecting';

  @override
  String get statusConnected => 'Connected';

  @override
  String get statusError => 'Connection error';

  @override
  String get statusMeasuring => 'Measuring...';

  @override
  String get statusWaitingValue => 'Waiting for values';

  @override
  String get guestNoSave => 'Guest mode does not save records.';

  @override
  String get labelBodyFatPercent => 'Body fat %';

  @override
  String get labelBodyFatMass => 'Body fat mass';

  @override
  String get labelMusclePercent => 'Muscle %';

  @override
  String get labelMuscleMass => 'Muscle mass';

  @override
  String get labelGoal => 'Goal';

  @override
  String get measureStop => 'Stop measuring';

  @override
  String get measureStart => 'Start measuring';

  @override
  String get measureRescan => 'Scan again';

  @override
  String get measureDisconnect => 'Disconnect';

  @override
  String goalOver(Object difference) {
    return '+$difference kg over';
  }

  @override
  String goalRemaining(Object difference) {
    return '$difference kg to go';
  }

  @override
  String get tooltipDeleteRecord => 'Delete entry';

  @override
  String userTitle(Object name) {
    return '$name';
  }

  @override
  String get tooltipViewHistory => 'View history';

  @override
  String get tooltipChangeUser => 'Switch user';

  @override
  String get historyTitle => 'History';

  @override
  String get historyGuestMessage => 'Guest mode does not store history.';

  @override
  String get historyListTitle => 'Records';

  @override
  String get historyEmpty => 'No records yet.';

  @override
  String get historyChartEmpty => 'No data to draw the chart yet.';

  @override
  String get historyChartEmptyCta => 'Measure your weight first';

  @override
  String get statLatest => 'Latest';

  @override
  String get statAverage => 'Average';

  @override
  String get statBodyFatPercent => 'Body fat %';

  @override
  String chartGoalLabel(Object weight) {
    return 'Goal $weight kg';
  }

  @override
  String get deviceConnectionTitle => 'Connect Device';

  @override
  String get scanButtonScanning => 'Scanning...';

  @override
  String get scanButtonLabel => 'Search devices';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get foundScalesTitle => 'Discovered scales';

  @override
  String get searchPrompt => 'Start scanning to see nearby Bluetooth scales.';

  @override
  String get scanningNearby => 'Searching for nearby scales...';

  @override
  String get statusSubtitleConnected => 'You can start measuring now.';

  @override
  String get statusSubtitleScanning => 'Searching for nearby scales.';

  @override
  String get statusSubtitleConnecting => 'Connecting to the selected device.';

  @override
  String get statusSubtitleIdle => 'Not connected. Start scanning for a scale.';

  @override
  String get statusSubtitleError => 'There was a connection issue. Please try again.';

  @override
  String get unnamedDevice => 'Unnamed device';

  @override
  String get currentlyConnected => 'Currently connected';

  @override
  String get addNewUserTitle => 'Add user';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get ageLabel => 'Age';

  @override
  String get heightLabel => 'Height (cm)';

  @override
  String get targetWeightLabel => 'Target weight (optional)';

  @override
  String get register => 'Save';

  @override
  String get fillAllFields => 'Please enter nickname, age, and height.';

  @override
  String get userSelectionTitle => 'Choose user';

  @override
  String get whoToManage => 'Whose weight are we tracking?';

  @override
  String get autoLoadHint => 'The last selected user loads automatically.';

  @override
  String get measureAsGuest => 'Measure in guest mode';

  @override
  String get newUser => 'New user';

  @override
  String get noUsersYet => 'No users yet.';

  @override
  String get addFirstUser => 'Add first user';

  @override
  String get measureAsGuestNow => 'Measure as guest now';

  @override
  String get guestLabel => 'Guest';

  @override
  String ageHeightFormat(Object age, Object height) {
    return '$age yrs · $height cm';
  }

  @override
  String goalWeightLabel(Object weight) {
    return 'Goal $weight kg';
  }

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get genericBleScaleName => 'BLE scale';

  @override
  String get errorScanPermission => 'Bluetooth scan permission is required.';

  @override
  String get errorNoScalesFound => 'No scales found nearby. Turn it on and try again closer.';

  @override
  String errorScanFailed(Object message) {
    return 'Scan failed: $message';
  }

  @override
  String get errorNoWeightCharacteristic => 'Could not find a weight characteristic.';

  @override
  String errorConnectFailed(Object message) {
    return 'Connection failed: $message';
  }

  @override
  String get errorNoBroadcast => 'Did not receive a scale broadcast. Step on the scale and try again.';

  @override
  String get errorConnectSaved => 'Could not connect to the saved scale.';

  @override
  String errorConnectSavedFailed(Object message) {
    return 'Failed to connect to the saved scale: $message';
  }
}
