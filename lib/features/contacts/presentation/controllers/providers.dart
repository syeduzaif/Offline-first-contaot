import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/database.dart';
import '../../../../core/services/jsonplaceholder_transport.dart';
import '../../../../core/services/sync_engine_service.dart';
import '../../data/local/contacts_dao.dart';
import '../../data/repositories/contacts_repository.dart';
import '../../domain/usecases/delete_contact.dart';
import '../../domain/usecases/upsert_contact.dart';
import '../../domain/usecases/watch_contacts.dart';

// Late-bound externally; overridden in main() with the live AppDatabase.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden in ProviderScope.',
  );
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  throw UnimplementedError(
    'connectivityServiceProvider must be overridden in ProviderScope.',
  );
});

final syncEngineServiceProvider = Provider<SyncEngineService>((ref) {
  throw UnimplementedError(
    'syncEngineServiceProvider must be overridden in ProviderScope.',
  );
});

final contactsDaoProvider = Provider<ContactsDao>((ref) {
  return ContactsDao(ref.watch(appDatabaseProvider));
});

final contactsRepositoryProvider = Provider<ContactsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dao = ref.watch(contactsDaoProvider);
  return ContactsRepository(db: db, dao: dao);
});

final watchContactsProvider = Provider<WatchContacts>((ref) {
  return WatchContacts(ref.watch(contactsRepositoryProvider));
});

final upsertContactProvider = Provider<UpsertContact>((ref) {
  return UpsertContact(ref.watch(contactsRepositoryProvider));
});

final deleteContactProvider = Provider<DeleteContact>((ref) {
  return DeleteContact(ref.watch(contactsRepositoryProvider));
});

final contactsListProvider = StreamProvider<List<Contact>>((ref) {
  return ref.watch(watchContactsProvider).call();
});

final contactByIdProvider =
    FutureProvider.family<Contact?, String>((ref, id) async {
  final repo = ref.watch(contactsRepositoryProvider);
  return repo.findById(id);
});

final isOnlineProvider = StreamProvider<bool>((ref) {
  final svc = ref.watch(connectivityServiceProvider);
  return svc.onStatusChanged.distinct();
});

final pendingCountProvider = StreamProvider<int>((ref) async* {
  final svc = ref.watch(syncEngineServiceProvider);
  yield await svc.pendingCount();
  await for (final _ in svc.statusStream) {
    yield await svc.pendingCount();
  }
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final svc = ref.watch(syncEngineServiceProvider);
  return svc.statusStream;
});

/// Used only by the manual API client (not by the sync engine).
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

final jsonPlaceholderTransportProvider =
    Provider<JsonPlaceholderTransport>((ref) {
  return JsonPlaceholderTransport(dio: ref.watch(dioProvider));
});

/// Live snapshot of the outbox, refreshed whenever the sync engine emits.
final outboxOpsProvider = StreamProvider<List<Op>>((ref) async* {
  final svc = ref.watch(syncEngineServiceProvider);
  Future<List<Op>> snapshot() => svc.db.takeOutbox(limit: 100);
  yield await snapshot();
  await for (final _ in svc.statusStream) {
    yield await snapshot();
  }
});

/// Buffered ring of the last 50 sync events (newest first).
final syncEventLogProvider = StreamProvider<List<SyncEvent>>((ref) async* {
  final svc = ref.watch(syncEngineServiceProvider);
  final buffer = <SyncEvent>[];
  yield List.of(buffer);
  await for (final event in svc.events) {
    buffer.insert(0, event);
    if (buffer.length > 50) buffer.removeLast();
    yield List.of(buffer);
  }
});

class DbStats {
  const DbStats({
    required this.activeCount,
    required this.deletedCount,
    required this.queuedCount,
    required this.mostRecentUpdate,
  });
  final int activeCount;
  final int deletedCount;
  final int queuedCount;
  final DateTime? mostRecentUpdate;
}

final dbStatsProvider = StreamProvider<DbStats>((ref) async* {
  final dao = ref.watch(contactsDaoProvider);
  final svc = ref.watch(syncEngineServiceProvider);

  Future<DbStats> snapshot() async {
    return DbStats(
      activeCount: await dao.countActive(),
      deletedCount: await dao.countDeletedLocally(),
      queuedCount: await svc.pendingCount(),
      mostRecentUpdate: await dao.mostRecentUpdate(),
    );
  }

  yield await snapshot();
  await for (final _ in svc.statusStream) {
    yield await snapshot();
  }
});
