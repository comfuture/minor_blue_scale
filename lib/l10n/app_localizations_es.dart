// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Báscula Bluetooth';

  @override
  String get splashLoading => 'Preparando la app...';

  @override
  String get statusIdle => 'En espera';

  @override
  String get statusScanning => 'Buscando';

  @override
  String get statusConnecting => 'Conectando';

  @override
  String get statusConnected => 'Conectado';

  @override
  String get statusError => 'Error de conexión';

  @override
  String get statusMeasuring => 'Midiendo...';

  @override
  String get statusWaitingValue => 'Esperando valores';

  @override
  String get guestNoSave => 'El modo invitado no guarda registros.';

  @override
  String get labelBodyFatPercent => '% de grasa';

  @override
  String get labelBodyFatMass => 'Masa grasa';

  @override
  String get labelMusclePercent => '% de músculo';

  @override
  String get labelMuscleMass => 'Masa muscular';

  @override
  String get labelGoal => 'Meta';

  @override
  String get measureStop => 'Detener medición';

  @override
  String get measureStart => 'Medir';

  @override
  String get measureRescan => 'Buscar de nuevo';

  @override
  String get measureDisconnect => 'Desconectar';

  @override
  String goalOver(Object difference) {
    return '+$difference kg por encima';
  }

  @override
  String goalRemaining(Object difference) {
    return '$difference kg restantes';
  }

  @override
  String get tooltipDeleteRecord => 'Eliminar entrada';

  @override
  String userTitle(Object name) {
    return '$name';
  }

  @override
  String get tooltipViewHistory => 'Ver historial';

  @override
  String get tooltipChangeUser => 'Cambiar usuario';

  @override
  String get historyTitle => 'Historial';

  @override
  String get historyGuestMessage => 'El modo invitado no guarda el historial.';

  @override
  String get historyListTitle => 'Registros';

  @override
  String get historyEmpty => 'Aún no hay registros.';

  @override
  String get historyChartEmpty => 'No hay datos para dibujar la gráfica.';

  @override
  String get historyChartEmptyCta => 'Mide tu peso primero';

  @override
  String get statLatest => 'Último';

  @override
  String get statAverage => 'Promedio';

  @override
  String get statBodyFatPercent => '% de grasa';

  @override
  String chartGoalLabel(Object weight) {
    return 'Meta $weight kg';
  }

  @override
  String get deviceConnectionTitle => 'Conectar dispositivo';

  @override
  String get scanButtonScanning => 'Buscando...';

  @override
  String get scanButtonLabel => 'Buscar dispositivos';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get foundScalesTitle => 'Básculas encontradas';

  @override
  String get searchPrompt => 'Comienza a buscar para ver básculas Bluetooth cercanas.';

  @override
  String get scanningNearby => 'Buscando básculas cercanas...';

  @override
  String get statusSubtitleConnected => 'Puedes empezar a medir ahora.';

  @override
  String get statusSubtitleScanning => 'Buscando básculas cercanas.';

  @override
  String get statusSubtitleConnecting => 'Conectando al dispositivo seleccionado.';

  @override
  String get statusSubtitleIdle => 'Sin conexión. Inicia la búsqueda.';

  @override
  String get statusSubtitleError => 'Hubo un problema de conexión. Inténtalo de nuevo.';

  @override
  String get unnamedDevice => 'Dispositivo sin nombre';

  @override
  String get currentlyConnected => 'Conectado ahora';

  @override
  String get addNewUserTitle => 'Agregar usuario';

  @override
  String get nicknameLabel => 'Apodo';

  @override
  String get ageLabel => 'Edad';

  @override
  String get heightLabel => 'Altura (cm)';

  @override
  String get targetWeightLabel => 'Peso objetivo (opcional)';

  @override
  String get register => 'Guardar';

  @override
  String get fillAllFields => 'Introduce apodo, edad y altura.';

  @override
  String get userSelectionTitle => 'Elegir usuario';

  @override
  String get whoToManage => '¿De quién registramos el peso?';

  @override
  String get autoLoadHint => 'El último usuario seleccionado se carga automáticamente.';

  @override
  String get measureAsGuest => 'Medir como invitado';

  @override
  String get newUser => 'Usuario nuevo';

  @override
  String get noUsersYet => 'Aún no hay usuarios.';

  @override
  String get addFirstUser => 'Agregar primer usuario';

  @override
  String get measureAsGuestNow => 'Medir como invitado ahora';

  @override
  String get guestLabel => 'Invitado';

  @override
  String ageHeightFormat(Object age, Object height) {
    return '$age años · $height cm';
  }

  @override
  String goalWeightLabel(Object weight) {
    return 'Meta $weight kg';
  }

  @override
  String get genderMale => 'Hombre';

  @override
  String get genderFemale => 'Mujer';

  @override
  String get genderOther => 'Otro';

  @override
  String get genericBleScaleName => 'Báscula BLE';

  @override
  String get errorScanPermission => 'Se requiere permiso de búsqueda Bluetooth.';

  @override
  String get errorNoScalesFound => 'No se encontraron básculas cercanas. Enciéndela y acércate para intentar de nuevo.';

  @override
  String errorScanFailed(Object message) {
    return 'Búsqueda fallida: $message';
  }

  @override
  String get errorNoWeightCharacteristic => 'No se encontró la característica de peso.';

  @override
  String errorConnectFailed(Object message) {
    return 'Falló la conexión: $message';
  }

  @override
  String get errorNoBroadcast => 'No se recibió la transmisión de la báscula. Sube a la báscula e inténtalo otra vez.';

  @override
  String get errorConnectSaved => 'No se pudo conectar a la báscula guardada.';

  @override
  String errorConnectSavedFailed(Object message) {
    return 'Falló la conexión a la báscula guardada: $message';
  }
}
