import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor_blue_scale/l10n/app_localizations.dart';

import '../models/connection_status.dart';
import '../providers/scale_provider.dart';
import '../services/scale_handlers/generic_gatt_handler.dart';
import '../services/scale_handlers/scale_handler.dart';
import '../theme/design_tokens.dart';

class DeviceConnectionScreen extends StatelessWidget {
  const DeviceConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = context.watch<ScaleProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.deviceConnectionTitle)),
      body: SafeArea(
        top: false,
        bottom: true,
        child: RefreshIndicator(
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
              errorMessage: scale.errorText(l10n),
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
                    label: Text(scale.status == ConnectionStatus.scanning
                        ? l10n.scanButtonScanning
                        : l10n.scanButtonLabel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: scale.status == ConnectionStatus.connected
                        ? () => scale.disconnect()
                        : null,
                    icon: const Icon(Icons.link_off),
                    label: Text(l10n.disconnect),
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
              Text(l10n.foundScalesTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...scale.scanResults.map((match) => _DeviceTile(match: match)),
            ] else if (scale.status != ConnectionStatus.scanning) ...[
              const SizedBox(height: 16),
              Text(
                l10n.searchPrompt,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
            if (scale.errorText(l10n) != null) ...[
              const SizedBox(height: 14),
              Text(
                scale.errorText(l10n)!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
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
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    Color bg = colors.surface;
    Color fg = Colors.black87;
    String text = status.label(l10n);
    String? localizedName = deviceName;
    if (localizedName == GenericGattHandler.fallbackDisplayName) {
      localizedName = l10n.genericBleScaleName;
    }

    switch (status) {
      case ConnectionStatus.connected:
        bg = colors.primary.withValues(alpha: 0.12);
        fg = colors.primary;
        if (localizedName != null && localizedName.isNotEmpty) {
          text = '$text · $localizedName';
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
                    _subtitle(status, l10n),
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

  String _subtitle(ConnectionStatus status, AppLocalizations l10n) {
    switch (status) {
      case ConnectionStatus.connected:
        return l10n.statusSubtitleConnected;
      case ConnectionStatus.scanning:
        return l10n.statusSubtitleScanning;
      case ConnectionStatus.connecting:
        return l10n.statusSubtitleConnecting;
      case ConnectionStatus.idle:
        return l10n.statusSubtitleIdle;
      case ConnectionStatus.error:
        return l10n.statusSubtitleError;
    }
  }
}

class _DeviceTile extends StatelessWidget {
  final ScaleMatch match;
  const _DeviceTile({required this.match});

  @override
  Widget build(BuildContext context) {
    final scale = context.read<ScaleProvider>();
    final l10n = AppLocalizations.of(context)!;
    String name = match.displayName.isNotEmpty ? match.displayName : l10n.unnamedDevice;
    if (name == GenericGattHandler.fallbackDisplayName) {
      name = l10n.genericBleScaleName;
    }
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
          _ScanningText(),
        ],
      ),
    );
  }
}

class _ScanningText extends StatelessWidget {
  const _ScanningText();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(l10n.scanningNearby);
  }
}

class _ConnectedDeviceCard extends StatelessWidget {
  final String name;
  final String? remoteId;
  const _ConnectedDeviceCard({required this.name, this.remoteId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayName =
        name == GenericGattHandler.fallbackDisplayName ? l10n.genericBleScaleName : name;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.currentlyConnected, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(displayName, style: const TextStyle(fontSize: 16)),
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
