import 'package:dio/dio.dart';
import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';
import 'package:workmanager/workmanager.dart';

import '../constants/app_constants.dart';
import '../utils/logger.dart';
import 'database.dart';
import 'jsonplaceholder_transport.dart';
import 'secure_storage.dart';

@pragma('vm:entry-point')
void backgroundCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    appLogger.i('[bg] task=$task fired');
    if (task != AppConstants.backgroundSyncTaskName) return true;

    AppDatabase? db;
    try {
      final key = await SecureStorageService().getOrCreateSqlCipherKey();
      db = await AppDatabase.openEncrypted(key);
      final dio = Dio(BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
      final transport = JsonPlaceholderTransport(dio: dio);
      final engine = SyncEngine<AppDatabase>(
        db: db,
        transport: transport,
        tables: [
          SyncableTable<Contact>(
            kind: AppConstants.contactsKind,
            table: db.contacts,
            fromJson: Contact.fromJson,
            toJson: (c) => c.toJson(),
            getId: (c) => c.id,
            getUpdatedAt: (c) => c.updatedAt,
          ),
        ],
        config: const SyncConfig(
          conflictStrategy: ConflictStrategy.lastWriteWins,
        ),
      );
      final stats = await engine.sync();
      appLogger.i('[bg] sync done: $stats');
      engine.dispose();
      return true;
    } catch (e, st) {
      appLogger.e('[bg] sync failed', error: e, stackTrace: st);
      return false;
    } finally {
      await db?.close();
    }
  });
}

Future<void> registerBackgroundSync() async {
  await Workmanager().initialize(backgroundCallbackDispatcher);
  await Workmanager().registerPeriodicTask(
    AppConstants.backgroundSyncUniqueName,
    AppConstants.backgroundSyncTaskName,
    frequency: AppConstants.backgroundSyncFrequency,
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}
