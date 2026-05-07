import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/services/background_worker.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/database.dart';
import 'core/services/jsonplaceholder_transport.dart';
import 'core/services/secure_storage.dart';
import 'core/services/sync_engine_service.dart';
import 'core/utils/logger.dart';
import 'features/auto_call/data/local/call_log_dao.dart';
import 'features/auto_call/data/local/scheduled_calls_dao.dart';
import 'features/auto_call/data/repositories/auto_call_repository.dart';
import 'features/contacts/presentation/controllers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final passphrase = await SecureStorageService().getOrCreateSqlCipherKey();
  final db = await AppDatabase.openEncrypted(passphrase);

  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  final connectivity = ConnectivityService();
  final transport = JsonPlaceholderTransport(dio: dio);
  final autoCallRepository = AutoCallRepository(
    db: db,
    scheduledCallsDao: ScheduledCallsDao(db),
    callLogDao: CallLogDao(db),
  );
  final syncEngine = SyncEngineService(
    db: db,
    transport: transport,
    connectivity: connectivity,
    autoCallRepository: autoCallRepository,
  );
  await syncEngine.start();

  try {
    await registerBackgroundSync();
  } catch (e, st) {
    appLogger.w(
      'Background worker registration failed',
      error: e,
      stackTrace: st,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        connectivityServiceProvider.overrideWithValue(connectivity),
        syncEngineServiceProvider.overrideWithValue(syncEngine),
        dioProvider.overrideWithValue(dio),
        jsonPlaceholderTransportProvider.overrideWithValue(transport),
      ],
      child: const App(),
    ),
  );
}
