import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'app.dart';
import 'app_state.dart';
import 'data/database/app_database.dart';
import 'data/repositories/app_repository.dart';
import 'data/services/mock_auth_service.dart';
import 'data/services/health_data_service.dart';
import 'data/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await LiquidGlassWidgets.initialize();
  final database = AppDatabase();
  final repository = AppRepository(
    database,
    healthDataSource: AppleHealthDataSource(),
  );
  final authService = MockAuthService(
    const FlutterSecureStorage(
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  );
  final notificationService = NotificationService(
    FlutterLocalNotificationsPlugin(),
  );
  await notificationService.initialize();
  await repository.setPreference(
    'timezone',
    notificationService.localTimezoneName,
  );
  final controller = AppController(
    repository: repository,
    authService: authService,
    notificationService: notificationService,
  );
  await controller.initialize();

  runApp(
    LiquidGlassWidgets.wrap(
      theme: GlassThemeData.simple(
        blur: 8,
        thickness: 24,
        saturation: 1.15,
        chromaticAberration: .004,
      ),
      child: ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          repositoryProvider.overrideWithValue(repository),
          authServiceProvider.overrideWithValue(authService),
          notificationServiceProvider.overrideWithValue(notificationService),
          appControllerProvider.overrideWith((ref) => controller),
        ],
        child: const LighterApp(),
      ),
    ),
  );
}
