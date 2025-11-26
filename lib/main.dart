import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/history_provider.dart';
import 'providers/scale_provider.dart';
import 'providers/user_provider.dart';
import 'services/ble_scale_service.dart';
import 'services/local_storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/user_selection_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final storage = LocalStorageService();
  await storage.init();
  final bleService = BleScaleService();

  runApp(BleScaleApp(storage: storage, bleService: bleService));
}

class BleScaleApp extends StatelessWidget {
  final LocalStorageService storage;
  final BleScaleService bleService;

  const BleScaleApp({super.key, required this.storage, required this.bleService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(storage)),
        ChangeNotifierProvider(create: (_) => HistoryProvider(storage)),
        ChangeNotifierProvider(create: (_) => ScaleProvider(bleService, storage)),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final hasUser = userProvider.selectedUser != null;
          return MaterialApp(
            title: '블루투스 저울',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            home: !userProvider.loaded
                ? const _SplashScreen()
                : hasUser
                    ? const HomeScreen()
                    : const UserSelectionScreen(isFirstLaunch: true),
          );
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text('앱을 준비하는 중...', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
