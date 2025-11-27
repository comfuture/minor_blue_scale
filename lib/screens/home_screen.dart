import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/connection_status.dart';
import '../models/user_profile.dart';
import '../providers/history_provider.dart';
import '../providers/scale_provider.dart';
import '../providers/user_provider.dart';
import '../theme/design_tokens.dart';
import 'device_connection_screen.dart';
import 'user_selection_screen.dart';
import 'tabs/history_tab.dart';
import 'tabs/measure_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  String? _loadedUserId;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().selectedUser;
    if (user == null) {
      return const UserSelectionScreen(isFirstLaunch: true);
    }

    _maybeLoadHistory(user);

    final scale = context.watch<ScaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.nickname}님'),
        actions: [
          IconButton(
            tooltip: '사용자 변경',
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
      body: IndexedStack(
        index: _index,
        children: [
          MeasureTab(user: user),
          HistoryTab(user: user),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.monitor_weight_outlined), label: '측정'),
          NavigationDestination(icon: Icon(Icons.timeline_outlined), label: '이력'),
        ],
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

class _ConnectionChip extends StatelessWidget {
  final ConnectionStatus status;

  const _ConnectionChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Color bg = colors.surface;
    Color fg = Colors.black87;
    String text = status.message;

    switch (status) {
      case ConnectionStatus.connected:
        bg = colors.primary.withValues(alpha: 0.15);
        fg = colors.primary;
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

    return Tooltip(
      message: status.message,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 180),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(DesignTokens.smallRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                status == ConnectionStatus.connected
                    ? Icons.bluetooth_connected
                    : status == ConnectionStatus.error
                        ? Icons.error_outline
                        : Icons.bluetooth_searching,
                size: 16,
                color: fg,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 12, color: fg),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConnectionFab extends StatelessWidget {
  final ConnectionStatus status;
  final VoidCallback onTap;
  const _ConnectionFab({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      elevation: 0,
      backgroundColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightElevation: 0,
      hoverElevation: 0,
      shape: const StadiumBorder(),
      label: _ConnectionChip(status: status),
    );
  }
}
