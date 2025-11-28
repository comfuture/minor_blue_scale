// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Bluetooth体重計';

  @override
  String get splashLoading => 'アプリを準備しています...';

  @override
  String get statusIdle => '待機中';

  @override
  String get statusScanning => 'スキャン中';

  @override
  String get statusConnecting => '接続中';

  @override
  String get statusConnected => '接続済み';

  @override
  String get statusError => '接続エラー';

  @override
  String get statusMeasuring => '測定中...';

  @override
  String get statusWaitingValue => '値を待っています';

  @override
  String get guestNoSave => 'ゲストモードでは記録を保存しません。';

  @override
  String get labelBodyFatPercent => '体脂肪%';

  @override
  String get labelBodyFatMass => '体脂肪量';

  @override
  String get labelMusclePercent => '筋肉%';

  @override
  String get labelMuscleMass => '筋肉量';

  @override
  String get labelGoal => '目標';

  @override
  String get measureStop => '測定を停止';

  @override
  String get measureStart => '測定する';

  @override
  String get measureRescan => '再スキャン';

  @override
  String get measureDisconnect => '切断';

  @override
  String goalOver(Object difference) {
    return '+$difference kg 超過';
  }

  @override
  String goalRemaining(Object difference) {
    return '残り $difference kg';
  }

  @override
  String get tooltipDeleteRecord => '記録を削除';

  @override
  String userTitle(Object name) {
    return '$name';
  }

  @override
  String get tooltipViewHistory => '履歴を見る';

  @override
  String get tooltipChangeUser => 'ユーザーを変更';

  @override
  String get historyTitle => '履歴';

  @override
  String get historyGuestMessage => 'ゲストモードでは履歴を保存しません。';

  @override
  String get historyListTitle => '記録一覧';

  @override
  String get historyEmpty => 'まだ記録がありません。';

  @override
  String get historyChartEmpty => 'グラフを描くデータがありません。';

  @override
  String get historyChartEmptyCta => 'まず体重を測定してください';

  @override
  String get statLatest => '最新';

  @override
  String get statAverage => '平均';

  @override
  String get statBodyFatPercent => '体脂肪%';

  @override
  String chartGoalLabel(Object weight) {
    return '目標 $weight kg';
  }

  @override
  String get deviceConnectionTitle => 'デバイス接続';

  @override
  String get scanButtonScanning => 'スキャン中...';

  @override
  String get scanButtonLabel => 'デバイスを検索';

  @override
  String get disconnect => '切断';

  @override
  String get foundScalesTitle => '検出された体重計';

  @override
  String get searchPrompt => 'スキャンを開始すると近くのBluetooth体重計が表示されます。';

  @override
  String get scanningNearby => '周囲の体重計を探しています...';

  @override
  String get statusSubtitleConnected => 'すぐに測定を開始できます。';

  @override
  String get statusSubtitleScanning => '周囲の体重計を検索しています。';

  @override
  String get statusSubtitleConnecting => '選択した機器に接続しています。';

  @override
  String get statusSubtitleIdle => '未接続です。検索を開始してください。';

  @override
  String get statusSubtitleError => '接続に問題があります。再試行してください。';

  @override
  String get unnamedDevice => '名前のないデバイス';

  @override
  String get currentlyConnected => '現在接続中';

  @override
  String get addNewUserTitle => 'ユーザーを追加';

  @override
  String get nicknameLabel => 'ニックネーム';

  @override
  String get ageLabel => '年齢';

  @override
  String get heightLabel => '身長 (cm)';

  @override
  String get targetWeightLabel => '目標体重 (任意)';

  @override
  String get register => '保存';

  @override
  String get fillAllFields => 'ニックネーム・年齢・身長を入力してください。';

  @override
  String get userSelectionTitle => 'ユーザー選択';

  @override
  String get whoToManage => '誰の体重を管理しますか?';

  @override
  String get autoLoadHint => '最後に選んだユーザーが自動で読み込まれます。';

  @override
  String get measureAsGuest => 'ゲストで測定';

  @override
  String get newUser => '新しいユーザー';

  @override
  String get noUsersYet => 'まだユーザーがいません。';

  @override
  String get addFirstUser => '最初のユーザーを追加';

  @override
  String get measureAsGuestNow => '今すぐゲストで測定';

  @override
  String get guestLabel => 'ゲスト';

  @override
  String ageHeightFormat(Object age, Object height) {
    return '$age歳 · ${height}cm';
  }

  @override
  String goalWeightLabel(Object weight) {
    return '目標 $weight kg';
  }

  @override
  String get genderMale => '男性';

  @override
  String get genderFemale => '女性';

  @override
  String get genderOther => 'その他';

  @override
  String get genericBleScaleName => 'BLE体重計';

  @override
  String get errorScanPermission => 'Bluetoothスキャンの権限が必要です。';

  @override
  String get errorNoScalesFound => '近くで体重計が見つかりません。電源を入れて近づいて再試行してください。';

  @override
  String errorScanFailed(Object message) {
    return 'スキャン失敗: $message';
  }

  @override
  String get errorNoWeightCharacteristic => '体重のキャラクタリスティックが見つかりません。';

  @override
  String errorConnectFailed(Object message) {
    return '接続に失敗しました: $message';
  }

  @override
  String get errorNoBroadcast => '体重計のブロードキャストを受信できませんでした。体重計に乗って再試行してください。';

  @override
  String get errorConnectSaved => '保存した体重計に接続できませんでした。';

  @override
  String errorConnectSavedFailed(Object message) {
    return '保存した体重計への接続に失敗しました: $message';
  }
}
