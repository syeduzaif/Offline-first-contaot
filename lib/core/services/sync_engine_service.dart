import 'dart:async';

import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';

import '../constants/app_constants.dart';
import '../utils/logger.dart';
import 'connectivity_service.dart';
import 'database.dart';
import 'jsonplaceholder_transport.dart';

class SyncEngineService {
  SyncEngineService({
    required this.db,
    required this.transport,
    required this.connectivity,
  }) : engine = SyncEngine<AppDatabase>(
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
            backoffMin: Duration(seconds: 1),
            backoffMax: Duration(minutes: 2),
            maxPushRetries: 5,
            pageSize: 50,
            pullOnStartup: true,
          ),
        );

  final AppDatabase db;
  final JsonPlaceholderTransport transport;
  final ConnectivityService connectivity;
  final SyncEngine<AppDatabase> engine;

  StreamSubscription<bool>? _connectivitySub;
  Timer? _foregroundTimer;
  final _statusController = StreamController<SyncStatus>.broadcast();

  SyncStatus _status = const SyncStatus.idle();
  SyncStatus get status => _status;
  Stream<SyncStatus> get statusStream => _statusController.stream;
  Stream<SyncEvent> get events => engine.events;

  /// Wires up event-driven status, kicks off an initial sync, and starts
  /// the foreground timer + connectivity-change listener.
  Future<void> start() async {
    engine.events.listen(_onEvent);

    _connectivitySub = connectivity.onStatusChanged.listen((online) {
      if (online) {
        appLogger.i('Connectivity restored — triggering sync.');
        unawaited(syncNow());
      }
    });

    _foregroundTimer = Timer.periodic(
      AppConstants.foregroundSyncInterval,
      (_) {
        if (connectivity.isOnline) unawaited(syncNow());
      },
    );

    if (connectivity.isOnline) {
      await syncNow();
    }
  }

  Future<SyncStats?> syncNow() async {
    try {
      final stats = await engine.sync();
      return stats;
    } catch (e, st) {
      appLogger.e('Sync failed', error: e, stackTrace: st);
      return null;
    }
  }

  Future<int> pendingCount() async {
    final ops = await db.takeOutbox(limit: 1000);
    return ops.length;
  }

  void _onEvent(SyncEvent event) {
    appLogger.d(event.toString());
    switch (event) {
      case SyncStarted():
        _emit(const SyncStatus.syncing());
      case SyncCompleted():
        _emit(SyncStatus.idle(lastSyncedAt: event.at, lastStats: event.stats));
      case SyncErrorEvent():
        _emit(SyncStatus.error(message: event.error.toString()));
      case ConflictDetectedEvent():
        _emit(const SyncStatus.conflict());
      default:
        break;
    }
  }

  void _emit(SyncStatus s) {
    _status = s;
    _statusController.add(s);
  }

  Future<void> dispose() async {
    _foregroundTimer?.cancel();
    await _connectivitySub?.cancel();
    await _statusController.close();
    engine.dispose();
  }
}

sealed class SyncStatus {
  const SyncStatus();

  const factory SyncStatus.idle({DateTime? lastSyncedAt, SyncStats? lastStats}) =
      SyncStatusIdle;
  const factory SyncStatus.syncing() = SyncStatusSyncing;
  const factory SyncStatus.error({required String message}) = SyncStatusError;
  const factory SyncStatus.conflict() = SyncStatusConflict;
}

class SyncStatusIdle extends SyncStatus {
  const SyncStatusIdle({this.lastSyncedAt, this.lastStats});
  final DateTime? lastSyncedAt;
  final SyncStats? lastStats;
}

class SyncStatusSyncing extends SyncStatus {
  const SyncStatusSyncing();
}

class SyncStatusError extends SyncStatus {
  const SyncStatusError({required this.message});
  final String message;
}

class SyncStatusConflict extends SyncStatus {
  const SyncStatusConflict();
}
