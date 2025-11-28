import 'package:minor_blue_scale/l10n/app_localizations.dart';

enum ConnectionStatus { idle, scanning, connecting, connected, error }

extension ConnectionStatusLabel on ConnectionStatus {
  String label(AppLocalizations l10n) {
    switch (this) {
      case ConnectionStatus.idle:
        return l10n.statusIdle;
      case ConnectionStatus.scanning:
        return l10n.statusScanning;
      case ConnectionStatus.connecting:
        return l10n.statusConnecting;
      case ConnectionStatus.connected:
        return l10n.statusConnected;
      case ConnectionStatus.error:
        return l10n.statusError;
    }
  }
}
