import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Scale'**
  String get appTitle;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing the app...'**
  String get splashLoading;

  /// No description provided for @statusIdle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get statusIdle;

  /// No description provided for @statusScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get statusScanning;

  /// No description provided for @statusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get statusConnecting;

  /// No description provided for @statusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get statusConnected;

  /// No description provided for @statusError.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get statusError;

  /// No description provided for @statusMeasuring.
  ///
  /// In en, this message translates to:
  /// **'Measuring...'**
  String get statusMeasuring;

  /// No description provided for @statusWaitingValue.
  ///
  /// In en, this message translates to:
  /// **'Waiting for values'**
  String get statusWaitingValue;

  /// No description provided for @guestNoSave.
  ///
  /// In en, this message translates to:
  /// **'Guest mode does not save records.'**
  String get guestNoSave;

  /// No description provided for @labelBodyFatPercent.
  ///
  /// In en, this message translates to:
  /// **'Body fat %'**
  String get labelBodyFatPercent;

  /// No description provided for @labelBodyFatMass.
  ///
  /// In en, this message translates to:
  /// **'Body fat mass'**
  String get labelBodyFatMass;

  /// No description provided for @labelMusclePercent.
  ///
  /// In en, this message translates to:
  /// **'Muscle %'**
  String get labelMusclePercent;

  /// No description provided for @labelMuscleMass.
  ///
  /// In en, this message translates to:
  /// **'Muscle mass'**
  String get labelMuscleMass;

  /// No description provided for @labelGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get labelGoal;

  /// No description provided for @measureStop.
  ///
  /// In en, this message translates to:
  /// **'Stop measuring'**
  String get measureStop;

  /// No description provided for @measureStart.
  ///
  /// In en, this message translates to:
  /// **'Start measuring'**
  String get measureStart;

  /// No description provided for @measureRescan.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get measureRescan;

  /// No description provided for @measureDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get measureDisconnect;

  /// No description provided for @goalOver.
  ///
  /// In en, this message translates to:
  /// **'+{difference} kg over'**
  String goalOver(Object difference);

  /// No description provided for @goalRemaining.
  ///
  /// In en, this message translates to:
  /// **'{difference} kg to go'**
  String goalRemaining(Object difference);

  /// No description provided for @tooltipDeleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get tooltipDeleteRecord;

  /// No description provided for @userTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String userTitle(Object name);

  /// No description provided for @tooltipViewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get tooltipViewHistory;

  /// No description provided for @tooltipChangeUser.
  ///
  /// In en, this message translates to:
  /// **'Switch user'**
  String get tooltipChangeUser;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyGuestMessage.
  ///
  /// In en, this message translates to:
  /// **'Guest mode does not store history.'**
  String get historyGuestMessage;

  /// No description provided for @historyListTitle.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get historyListTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No records yet.'**
  String get historyEmpty;

  /// No description provided for @historyChartEmpty.
  ///
  /// In en, this message translates to:
  /// **'No data to draw the chart yet.'**
  String get historyChartEmpty;

  /// No description provided for @historyChartEmptyCta.
  ///
  /// In en, this message translates to:
  /// **'Measure your weight first'**
  String get historyChartEmptyCta;

  /// No description provided for @statLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get statLatest;

  /// No description provided for @statAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get statAverage;

  /// No description provided for @statBodyFatPercent.
  ///
  /// In en, this message translates to:
  /// **'Body fat %'**
  String get statBodyFatPercent;

  /// No description provided for @chartGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal {weight} kg'**
  String chartGoalLabel(Object weight);

  /// No description provided for @deviceConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect Device'**
  String get deviceConnectionTitle;

  /// No description provided for @scanButtonScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanButtonScanning;

  /// No description provided for @scanButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Search devices'**
  String get scanButtonLabel;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @foundScalesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discovered scales'**
  String get foundScalesTitle;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start scanning to see nearby Bluetooth scales.'**
  String get searchPrompt;

  /// No description provided for @scanningNearby.
  ///
  /// In en, this message translates to:
  /// **'Searching for nearby scales...'**
  String get scanningNearby;

  /// No description provided for @statusSubtitleConnected.
  ///
  /// In en, this message translates to:
  /// **'You can start measuring now.'**
  String get statusSubtitleConnected;

  /// No description provided for @statusSubtitleScanning.
  ///
  /// In en, this message translates to:
  /// **'Searching for nearby scales.'**
  String get statusSubtitleScanning;

  /// No description provided for @statusSubtitleConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to the selected device.'**
  String get statusSubtitleConnecting;

  /// No description provided for @statusSubtitleIdle.
  ///
  /// In en, this message translates to:
  /// **'Not connected. Start scanning for a scale.'**
  String get statusSubtitleIdle;

  /// No description provided for @statusSubtitleError.
  ///
  /// In en, this message translates to:
  /// **'There was a connection issue. Please try again.'**
  String get statusSubtitleError;

  /// No description provided for @unnamedDevice.
  ///
  /// In en, this message translates to:
  /// **'Unnamed device'**
  String get unnamedDevice;

  /// No description provided for @currentlyConnected.
  ///
  /// In en, this message translates to:
  /// **'Currently connected'**
  String get currentlyConnected;

  /// No description provided for @addNewUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get addNewUserTitle;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightLabel;

  /// No description provided for @targetWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Target weight (optional)'**
  String get targetWeightLabel;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get register;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please enter nickname, age, and height.'**
  String get fillAllFields;

  /// No description provided for @userSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose user'**
  String get userSelectionTitle;

  /// No description provided for @whoToManage.
  ///
  /// In en, this message translates to:
  /// **'Whose weight are we tracking?'**
  String get whoToManage;

  /// No description provided for @autoLoadHint.
  ///
  /// In en, this message translates to:
  /// **'The last selected user loads automatically.'**
  String get autoLoadHint;

  /// No description provided for @measureAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Measure in guest mode'**
  String get measureAsGuest;

  /// No description provided for @newUser.
  ///
  /// In en, this message translates to:
  /// **'New user'**
  String get newUser;

  /// No description provided for @noUsersYet.
  ///
  /// In en, this message translates to:
  /// **'No users yet.'**
  String get noUsersYet;

  /// No description provided for @addFirstUser.
  ///
  /// In en, this message translates to:
  /// **'Add first user'**
  String get addFirstUser;

  /// No description provided for @measureAsGuestNow.
  ///
  /// In en, this message translates to:
  /// **'Measure as guest now'**
  String get measureAsGuestNow;

  /// No description provided for @guestLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestLabel;

  /// No description provided for @ageHeightFormat.
  ///
  /// In en, this message translates to:
  /// **'{age} yrs · {height} cm'**
  String ageHeightFormat(Object age, Object height);

  /// No description provided for @goalWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal {weight} kg'**
  String goalWeightLabel(Object weight);

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @genericBleScaleName.
  ///
  /// In en, this message translates to:
  /// **'BLE scale'**
  String get genericBleScaleName;

  /// No description provided for @errorScanPermission.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth scan permission is required.'**
  String get errorScanPermission;

  /// No description provided for @errorNoScalesFound.
  ///
  /// In en, this message translates to:
  /// **'No scales found nearby. Turn it on and try again closer.'**
  String get errorNoScalesFound;

  /// No description provided for @errorScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed: {message}'**
  String errorScanFailed(Object message);

  /// No description provided for @errorNoWeightCharacteristic.
  ///
  /// In en, this message translates to:
  /// **'Could not find a weight characteristic.'**
  String get errorNoWeightCharacteristic;

  /// No description provided for @errorConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {message}'**
  String errorConnectFailed(Object message);

  /// No description provided for @errorNoBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Did not receive a scale broadcast. Step on the scale and try again.'**
  String get errorNoBroadcast;

  /// No description provided for @errorConnectSaved.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the saved scale.'**
  String get errorConnectSaved;

  /// No description provided for @errorConnectSavedFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to the saved scale: {message}'**
  String errorConnectSavedFailed(Object message);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
