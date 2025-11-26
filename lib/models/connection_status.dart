enum ConnectionStatus { idle, scanning, connecting, connected, error }

extension ConnectionStatusMessage on ConnectionStatus {
  String get message {
    switch (this) {
      case ConnectionStatus.idle:
        return '대기 중';
      case ConnectionStatus.scanning:
        return '스캔 중';
      case ConnectionStatus.connecting:
        return '연결 중';
      case ConnectionStatus.connected:
        return '연결됨';
      case ConnectionStatus.error:
        return '연결 오류';
    }
  }
}
