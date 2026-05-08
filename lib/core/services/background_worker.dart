import 'package:dio/dio.dart';
import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';
import 'package:workmanager/workmanager.dart';

import '../../features/auto_call/data/local/call_log_dao.dart';
import '../../features/auto_call/data/local/scheduled_calls_dao.dart';
import '../../features/auto_call/data/repositories/auto_call_repository.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';
import 'database.dart';
import 'jsonplaceholder_transport.dart';
import 'secure_storage.dart';

@pragma('vm:entry-point')
void backgroundCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    appLogger.i('[bg] task=$task fired');
    if (task != kBackgroundSyncTaskName) return true;

    AppDatabase? db;
    try {
      final key = await SecureStorageService().getOrCreateSqlCipherKey();
      db = await AppDatabase.openEncrypted(key);
      final dio = Dio(BaseOptions(
        baseUrl: kApiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
      final transport = JsonPlaceholderTransport(dio: dio);
      final engine = SyncEngine<AppDatabase>(
        db: db,
        transport: transport,
        tables: [
          SyncableTable<Contact>(
            kind: kContactsKind,
            table: db.contacts,
            fromJson: Contact.fromJson,
            toJson: (c) => c.toJson(),
            getId: (c) => c.id,
            getUpdatedAt: (c) => c.updatedAt,
          ),
          SyncableTable<CallLog>(
            kind: kCallLogsKind,
            table: db.callLogs,
            fromJson: CallLog.fromJson,
            toJson: (c) => c.toJson(),
            getId: (c) => c.id,
            getUpdatedAt: (c) => c.updatedAt,
          ),
        ],
        config: const SyncConfig(
          conflictStrategy: ConflictStrategy.lastWriteWins,
        ),
      );
      final autoCall = AutoCallRepository(
        db: db,
        scheduledCallsDao: ScheduledCallsDao(db),
        callLogDao: CallLogDao(db),
      );
      // Background isolate: don't try to open the dialer (no UI). Just
      // mark due calls as missed; user sees them on next launch.
      final fired =
          await autoCall.fireDueScheduledCalls(openDialer: false);
      if (fired > 0) {
        appLogger.i('[bg] marked $fired scheduled call(s) as missed');
      }
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
    kBackgroundSyncUniqueName,
    kBackgroundSyncTaskName,
    frequency: kBackgroundSyncFrequency,
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}
