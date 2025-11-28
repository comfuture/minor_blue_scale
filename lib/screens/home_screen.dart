import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minor_blue_scale/l10n/app_localizations.dart';

import '../models/connection_status.dart';
import '../models/user_profile.dart';
import '../providers/history_provider.dart';
import '../providers/scale_provider.dart';
import '../providers/user_provider.dart';
import 'device_connection_screen.dart';
import 'user_selection_screen.dart';
import 'history_screen.dart';
import 'measure_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _loadedUserId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<UserProvider>().selectedUser;
    if (user == null) {
      return const UserSelectionScreen(isFirstLaunch: true);
    }

    _maybeLoadHistory(user);

    final scale = context.watch<ScaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userTitle(user.isGuest ? l10n.guestLabel : user.nickname)),
        actions: [
          IconButton(
            tooltip: l10n.tooltipViewHistory,
            icon: const Icon(Icons.timeline_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryScreen(user: user),
                ),
              );
            },
          ),
          IconButton(
            tooltip: l10n.tooltipChangeUser,
            icon: const Icon(Icons.switch_account),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserSelectionScreen(),
                ),
              );
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: MeasureView(user: user),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _ConnectionFab(
        status: scale.status,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DeviceConnectionScreen()),
        ),
      ),
    );
  }

  void _maybeLoadHistory(UserProfile user) {
    if (_loadedUserId == user.id) return;
    _loadedUserId = user.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HistoryProvider>().load(user.id);
    });
  }
}

class _ConnectionFab extends StatelessWidget {
  final ConnectionStatus status;
  final VoidCallback onTap;
  const _ConnectionFab({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    Color bg = colors.primary;
    Color fg = Colors.white;
    IconData icon;

    switch (status) {
      case ConnectionStatus.connected:
        bg = colors.primary;
        fg = Colors.white;
        icon = Icons.bluetooth_connected;
        break;
      case ConnectionStatus.scanning:
      case ConnectionStatus.connecting:
        bg = Colors.amber.shade700;
        fg = Colors.white;
        icon = Icons.bluetooth_searching;
        break;
      case ConnectionStatus.error:
        bg = Colors.red.shade700;
        fg = Colors.white;
        icon = Icons.error_outline;
        break;
      case ConnectionStatus.idle:
        bg = colors.surfaceContainerHighest;
        fg = Colors.black87;
        icon = Icons.bluetooth_searching;
        break;
    }

    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 6,
      icon: Icon(icon),
      label: Text(status.label(l10n)),
    );
  }
}
