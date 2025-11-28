// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '블루투스 체중계';

  @override
  String get splashLoading => '앱을 준비하는 중...';

  @override
  String get statusIdle => '대기 중';

  @override
  String get statusScanning => '스캔 중';

  @override
  String get statusConnecting => '연결 중';

  @override
  String get statusConnected => '연결됨';

  @override
  String get statusError => '연결 오류';

  @override
  String get statusMeasuring => '측정 중...';

  @override
  String get statusWaitingValue => '값을 기다리는 중';

  @override
  String get guestNoSave => '게스트 모드에서는 기록이 저장되지 않습니다.';

  @override
  String get labelBodyFatPercent => '체지방%';

  @override
  String get labelBodyFatMass => '체지방량';

  @override
  String get labelMusclePercent => '골격근%';

  @override
  String get labelMuscleMass => '근육량';

  @override
  String get labelGoal => '목표';

  @override
  String get measureStop => '측정 중지';

  @override
  String get measureStart => '측정하기';

  @override
  String get measureRescan => '다시 검색';

  @override
  String get measureDisconnect => '연결 해제';

  @override
  String goalOver(Object difference) {
    return '+$difference kg 초과';
  }

  @override
  String goalRemaining(Object difference) {
    return '$difference kg 남음';
  }

  @override
  String get tooltipDeleteRecord => '기록 삭제';

  @override
  String userTitle(Object name) {
    return '$name님';
  }

  @override
  String get tooltipViewHistory => '이력 보기';

  @override
  String get tooltipChangeUser => '사용자 변경';

  @override
  String get historyTitle => '이력';

  @override
  String get historyGuestMessage => '게스트 모드에서는 이력을 저장하지 않습니다.';

  @override
  String get historyListTitle => '기록 목록';

  @override
  String get historyEmpty => '아직 기록이 없습니다.';

  @override
  String get historyChartEmpty => '차트를 그릴 기록이 아직 없습니다.';

  @override
  String get historyChartEmptyCta => '체중을 먼저 측정해 보세요';

  @override
  String get statLatest => '최근';

  @override
  String get statAverage => '평균';

  @override
  String get statBodyFatPercent => '체지방%';

  @override
  String chartGoalLabel(Object weight) {
    return '목표 $weight kg';
  }

  @override
  String get deviceConnectionTitle => '장치 연결';

  @override
  String get scanButtonScanning => '스캔 중...';

  @override
  String get scanButtonLabel => '장치 검색';

  @override
  String get disconnect => '연결 해제';

  @override
  String get foundScalesTitle => '발견된 체중계';

  @override
  String get searchPrompt => '검색을 시작하면 주변의 블루투스 체중계를 표시합니다.';

  @override
  String get scanningNearby => '주변 체중계를 찾고 있습니다...';

  @override
  String get statusSubtitleConnected => '측정을 바로 시작할 수 있습니다.';

  @override
  String get statusSubtitleScanning => '주변 체중계를 검색하고 있습니다.';

  @override
  String get statusSubtitleConnecting => '선택한 기기에 연결 중입니다.';

  @override
  String get statusSubtitleIdle => '연결되지 않았습니다. 장치 검색을 시작하세요.';

  @override
  String get statusSubtitleError => '연결에 문제가 있습니다. 다시 시도해 주세요.';

  @override
  String get unnamedDevice => '이름 없는 기기';

  @override
  String get currentlyConnected => '현재 연결됨';

  @override
  String get addNewUserTitle => '새 사용자 추가';

  @override
  String get nicknameLabel => '닉네임';

  @override
  String get ageLabel => '나이';

  @override
  String get heightLabel => '키 (cm)';

  @override
  String get targetWeightLabel => '목표 체중 (선택)';

  @override
  String get register => '등록';

  @override
  String get fillAllFields => '닉네임, 나이, 키를 모두 입력해주세요.';

  @override
  String get userSelectionTitle => '사용자 선택';

  @override
  String get whoToManage => '누구의 체중을 관리할까요?';

  @override
  String get autoLoadHint => '마지막 선택 사용자는 자동으로 불러와져요.';

  @override
  String get measureAsGuest => '게스트 모드로 측정';

  @override
  String get newUser => '새 사용자';

  @override
  String get noUsersYet => '아직 등록된 사용자가 없어요.';

  @override
  String get addFirstUser => '첫 사용자 등록';

  @override
  String get measureAsGuestNow => '게스트로 바로 측정';

  @override
  String get guestLabel => '게스트';

  @override
  String ageHeightFormat(Object age, Object height) {
    return '$age세 · ${height}cm';
  }

  @override
  String goalWeightLabel(Object weight) {
    return '목표 $weight kg';
  }

  @override
  String get genderMale => '남성';

  @override
  String get genderFemale => '여성';

  @override
  String get genderOther => '기타';

  @override
  String get genericBleScaleName => 'BLE 체중계';

  @override
  String get errorScanPermission => '블루투스 스캔 권한이 필요합니다.';

  @override
  String get errorNoScalesFound => '주변에서 체중계를 찾지 못했습니다. 전원을 켜고 더 가까이에서 다시 시도하세요.';

  @override
  String errorScanFailed(Object message) {
    return '스캔 실패: $message';
  }

  @override
  String get errorNoWeightCharacteristic => '체중 characteristic을 찾지 못했습니다.';

  @override
  String errorConnectFailed(Object message) {
    return '연결 실패: $message';
  }

  @override
  String get errorNoBroadcast => '체중계 브로드캐스트를 받지 못했습니다. 체중계에 올라선 뒤 다시 시도하세요.';

  @override
  String get errorConnectSaved => '저장된 체중계에 연결하지 못했습니다.';

  @override
  String errorConnectSavedFailed(Object message) {
    return '저장된 체중계 연결 실패: $message';
  }
}
