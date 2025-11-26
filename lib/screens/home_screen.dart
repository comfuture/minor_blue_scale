import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/connection_status.dart';
import '../models/user_profile.dart';
import '../providers/history_provider.dart';
import '../providers/scale_provider.dart';
import '../providers/user_provider.dart';
import '../theme/design_tokens.dart';
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
    final connectedName = scale.connectedName;

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.nickname}님'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _ConnectionChip(
              status: scale.status,
              deviceName: connectedName,
            ),
          ),
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
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                if (scale.status == ConnectionStatus.connected) {
                  await scale.disconnect();
                  return;
                }
                await scale.scan();
              },
              icon: Icon(scale.status == ConnectionStatus.connected
                  ? Icons.link_off
                  : Icons.bluetooth_searching),
              label: Text(scale.status == ConnectionStatus.connected ? '연결 해제' : '저울 검색'),
            )
          : null,
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
  final String? deviceName;

  const _ConnectionChip({required this.status, this.deviceName});

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(DesignTokens.smallRadius),
      ),
      child: Row(
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
          Text(text, style: TextStyle(fontSize: 12, color: fg)),
        ],
      ),
    );
  }
}
