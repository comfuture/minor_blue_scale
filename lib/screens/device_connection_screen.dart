import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/connection_status.dart';
import '../providers/scale_provider.dart';
import '../services/scale_handlers/scale_handler.dart';
import '../theme/design_tokens.dart';

class DeviceConnectionScreen extends StatelessWidget {
  const DeviceConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = context.watch<ScaleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('장치 연결')),
      body: RefreshIndicator(
        onRefresh: () async {
          if (scale.status == ConnectionStatus.scanning) return;
          await scale.scan();
        },
        child: ListView(
          padding: DesignTokens.screenPadding,
          children: [
            _StatusCard(
              status: scale.status,
              deviceName: scale.connectedName,
              errorMessage: scale.errorMessage,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: scale.status == ConnectionStatus.scanning
                        ? null
                        : () => scale.scan(),
                    icon: scale.status == ConnectionStatus.scanning
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.bluetooth_searching),
                    label: Text(
                      scale.status == ConnectionStatus.scanning ? '스캔 중...' : '장치 검색',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: scale.status == ConnectionStatus.connected
                        ? () => scale.disconnect()
                        : null,
                    icon: const Icon(Icons.link_off),
                    label: const Text('연결 해제'),
                  ),
                ),
              ],
            ),
            if (scale.status == ConnectionStatus.scanning) ...[
              const SizedBox(height: 16),
              const _ScanningBanner(),
            ],
            if (scale.connectedName != null &&
                scale.status == ConnectionStatus.connected) ...[
              const SizedBox(height: 16),
              _ConnectedDeviceCard(
                name: scale.connectedName!,
                remoteId: scale.connectedDevice?.remoteId.str,
              ),
            ],
            if (scale.scanResults.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('발견된 저울', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...scale.scanResults.map((match) => _DeviceTile(match: match)),
            ] else if (scale.status != ConnectionStatus.scanning) ...[
              const SizedBox(height: 16),
              Text(
                '검색을 시작하면 주변의 블루투스 체중계를 표시합니다.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
            if (scale.errorMessage != null) ...[
              const SizedBox(height: 14),
              Text(
                scale.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final ConnectionStatus status;
  final String? deviceName;
  final String? errorMessage;

  const _StatusCard({
    required this.status,
    this.deviceName,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Color bg = colors.surface;
    Color fg = Colors.black87;
    String text = status.message;

    switch (status) {
      case ConnectionStatus.connected:
        bg = colors.primary.withValues(alpha: 0.12);
        fg = colors.primary;
        if (deviceName != null && deviceName!.isNotEmpty) {
          text = '$text · $deviceName';
        }
        break;
      case ConnectionStatus.scanning:
      case ConnectionStatus.connecting:
        bg = Colors.amber.shade100;
        fg = Colors.amber.shade900;
        break;
      case ConnectionStatus.error:
        bg = Colors.red.shade100;
        fg = Colors.red.shade800;
        break;
      case ConnectionStatus.idle:
        bg = colors.surfaceContainerHighest;
        fg = Colors.black87;
    }

    return Card(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              status == ConnectionStatus.connected
                  ? Icons.bluetooth_connected
                  : status == ConnectionStatus.error
                      ? Icons.error_outline
                      : Icons.bluetooth_searching,
              color: fg,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontSize: 16, color: fg, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _subtitle(status),
                    style: TextStyle(color: fg.withValues(alpha: 0.8)),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 4),
                    Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return '측정을 바로 시작할 수 있습니다.';
      case ConnectionStatus.scanning:
        return '주변 저울을 검색하고 있습니다.';
      case ConnectionStatus.connecting:
        return '선택한 기기에 연결 중입니다.';
      case ConnectionStatus.idle:
        return '연결되지 않았습니다. 장치 검색을 시작하세요.';
      case ConnectionStatus.error:
        return '연결에 문제가 있습니다. 다시 시도해 주세요.';
    }
  }
}

class _DeviceTile extends StatelessWidget {
  final ScaleMatch match;
  const _DeviceTile({required this.match});

  @override
  Widget build(BuildContext context) {
    final scale = context.read<ScaleProvider>();
    final name = match.displayName.isNotEmpty ? match.displayName : '이름 없는 기기';
    final remoteId = match.result.device.remoteId.str;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.scale_outlined),
        title: Text(name),
        subtitle: Text(remoteId),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => scale.connect(match),
      ),
    );
  }
}

class _ScanningBanner extends StatelessWidget {
  const _ScanningBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
      ),
      child: Row(
        children: const [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
          SizedBox(width: 12),
          Text('주변 저울을 찾고 있습니다...'),
        ],
      ),
    );
  }
}

class _ConnectedDeviceCard extends StatelessWidget {
  final String name;
  final String? remoteId;
  const _ConnectedDeviceCard({required this.name, this.remoteId});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('현재 연결됨', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(name, style: const TextStyle(fontSize: 16)),
            if (remoteId != null) ...[
              const SizedBox(height: 4),
              Text(remoteId!, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ],
        ),
      ),
    );
  }
}
