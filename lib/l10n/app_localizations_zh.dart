// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '蓝牙体重秤';

  @override
  String get splashLoading => '正在准备应用...';

  @override
  String get statusIdle => '待机';

  @override
  String get statusScanning => '正在扫描';

  @override
  String get statusConnecting => '正在连接';

  @override
  String get statusConnected => '已连接';

  @override
  String get statusError => '连接错误';

  @override
  String get statusMeasuring => '测量中...';

  @override
  String get statusWaitingValue => '等待数据';

  @override
  String get guestNoSave => '访客模式不会保存记录。';

  @override
  String get labelBodyFatPercent => '体脂%';

  @override
  String get labelBodyFatMass => '体脂量';

  @override
  String get labelMusclePercent => '肌肉%';

  @override
  String get labelMuscleMass => '肌肉量';

  @override
  String get labelGoal => '目标';

  @override
  String get measureStop => '停止测量';

  @override
  String get measureStart => '开始测量';

  @override
  String get measureRescan => '重新扫描';

  @override
  String get measureDisconnect => '断开连接';

  @override
  String goalOver(Object difference) {
    return '+$difference kg 超出';
  }

  @override
  String goalRemaining(Object difference) {
    return '剩余 $difference kg';
  }

  @override
  String get tooltipDeleteRecord => '删除记录';

  @override
  String userTitle(Object name) {
    return '$name';
  }

  @override
  String get tooltipViewHistory => '查看历史';

  @override
  String get tooltipChangeUser => '切换用户';

  @override
  String get historyTitle => '历史';

  @override
  String get historyGuestMessage => '访客模式不会保存历史。';

  @override
  String get historyListTitle => '记录列表';

  @override
  String get historyEmpty => '还没有记录。';

  @override
  String get historyChartEmpty => '还没有可绘制图表的数据。';

  @override
  String get historyChartEmptyCta => '请先测量体重';

  @override
  String get statLatest => '最新';

  @override
  String get statAverage => '平均';

  @override
  String get statBodyFatPercent => '体脂%';

  @override
  String chartGoalLabel(Object weight) {
    return '目标 $weight kg';
  }

  @override
  String get deviceConnectionTitle => '连接设备';

  @override
  String get scanButtonScanning => '正在扫描...';

  @override
  String get scanButtonLabel => '搜索设备';

  @override
  String get disconnect => '断开';

  @override
  String get foundScalesTitle => '发现的体重秤';

  @override
  String get searchPrompt => '开始扫描即可看到附近的蓝牙体重秤。';

  @override
  String get scanningNearby => '正在寻找附近的体重秤...';

  @override
  String get statusSubtitleConnected => '可以开始测量。';

  @override
  String get statusSubtitleScanning => '正在搜索附近的体重秤。';

  @override
  String get statusSubtitleConnecting => '正在连接所选设备。';

  @override
  String get statusSubtitleIdle => '尚未连接，请开始搜索。';

  @override
  String get statusSubtitleError => '连接出现问题，请重试。';

  @override
  String get unnamedDevice => '未命名设备';

  @override
  String get currentlyConnected => '当前已连接';

  @override
  String get addNewUserTitle => '添加用户';

  @override
  String get nicknameLabel => '昵称';

  @override
  String get ageLabel => '年龄';

  @override
  String get heightLabel => '身高 (cm)';

  @override
  String get targetWeightLabel => '目标体重 (可选)';

  @override
  String get register => '保存';

  @override
  String get fillAllFields => '请输入昵称、年龄和身高。';

  @override
  String get userSelectionTitle => '选择用户';

  @override
  String get whoToManage => '要管理谁的体重？';

  @override
  String get autoLoadHint => '最后选择的用户会自动加载。';

  @override
  String get measureAsGuest => '以访客测量';

  @override
  String get newUser => '新用户';

  @override
  String get noUsersYet => '还没有用户。';

  @override
  String get addFirstUser => '添加第一个用户';

  @override
  String get measureAsGuestNow => '立即以访客测量';

  @override
  String get guestLabel => '访客';

  @override
  String ageHeightFormat(Object age, Object height) {
    return '$age岁 · ${height}cm';
  }

  @override
  String goalWeightLabel(Object weight) {
    return '目标 $weight kg';
  }

  @override
  String get genderMale => '男';

  @override
  String get genderFemale => '女';

  @override
  String get genderOther => '其他';

  @override
  String get genericBleScaleName => 'BLE体重秤';

  @override
  String get errorScanPermission => '需要蓝牙扫描权限。';

  @override
  String get errorNoScalesFound => '附近未找到体重秤。请打开电源并靠近后重试。';

  @override
  String errorScanFailed(Object message) {
    return '扫描失败: $message';
  }

  @override
  String get errorNoWeightCharacteristic => '未找到体重特征值。';

  @override
  String errorConnectFailed(Object message) {
    return '连接失败: $message';
  }

  @override
  String get errorNoBroadcast => '未收到体重秤广播。请站上体重秤后重试。';

  @override
  String get errorConnectSaved => '无法连接到已保存的体重秤。';

  @override
  String errorConnectSavedFailed(Object message) {
    return '连接已保存的体重秤失败: $message';
  }
}
