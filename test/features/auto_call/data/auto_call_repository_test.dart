import 'package:flutter_test/flutter_test.dart';
import 'package:offline_dummy_app/core/services/database.dart';
import 'package:offline_dummy_app/features/auto_call/data/local/call_log_dao.dart';
import 'package:offline_dummy_app/features/auto_call/data/local/scheduled_calls_dao.dart';
import 'package:offline_dummy_app/features/auto_call/data/repositories/auto_call_repository.dart';
import 'package:offline_dummy_app/features/auto_call/data/services/dialer_service.dart';

void main() {
  late AppDatabase db;
  late ScheduledCallsDao schedDao;
  late CallLogDao logDao;
  late AutoCallRepository repo;

  setUp(() {
    db = AppDatabase.memory();
    schedDao = ScheduledCallsDao(db);
    logDao = CallLogDao(db);
    repo = AutoCallRepository(
      db: db,
      scheduledCallsDao: schedDao,
      callLogDao: logDao,
      dialer: _StubDialer(succeeds: true),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('schedule persists a row visible via watchUpcoming', () async {
    final runAt = DateTime.now().add(const Duration(minutes: 10));
    final c = await repo.schedule(
      contactId: '1',
      contactName: 'Alice',
      phone: '555-0100',
      runAt: runAt,
      reason: 'Project sync',
    );
    final list = await repo.watchUpcoming().first;
    expect(list, hasLength(1));
    expect(list.first.id, c.id);
    expect(list.first.contactName, 'Alice');
  });

  test('cancel marks the row fired with outcome=cancelled', () async {
    final c = await repo.schedule(
      contactId: '1',
      contactName: 'Alice',
      runAt: DateTime.now().add(const Duration(hours: 1)),
    );
    await repo.cancel(c.id);
    final upcoming = await repo.watchUpcoming().first;
    expect(upcoming, isEmpty);
    final history = await repo.watchHistory().first;
    expect(history, hasLength(1));
    expect(history.first.outcome, 'cancelled');
  });

  test('placeCallNow records a call_log AND enqueues a sync op', () async {
    final ok = await repo.placeCallNow(
      contactId: '1',
      contactName: 'Alice',
      phone: '555-0100',
    );
    expect(ok, isTrue);

    final logs = await repo.watchCallLog().first;
    expect(logs, hasLength(1));
    expect(logs.first.contactName, 'Alice');
    expect(logs.first.origin, 'manual');

    final queued = await db.takeOutbox();
    expect(queued, hasLength(1));
    expect(queued.first.kind, 'call_logs');
  });

  test(
    'fireDueScheduledCalls fires due rows, records logs, marks placed',
    () async {
      // Bypass the dialer for this test — we want to focus on the
      // transactional bookkeeping, not the URL launcher.
      final fakeRepo = AutoCallRepository(
        db: db,
        scheduledCallsDao: schedDao,
        callLogDao: logDao,
        dialer: _StubDialer(succeeds: true),
      );
      // Schedule one in the past, one in the future.
      await fakeRepo.schedule(
        contactId: '1',
        contactName: 'Past',
        runAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );
      await fakeRepo.schedule(
        contactId: '2',
        contactName: 'Future',
        runAt: DateTime.now().add(const Duration(hours: 1)),
      );

      final fired = await fakeRepo.fireDueScheduledCalls();
      expect(fired, 1);

      final history = await fakeRepo.watchHistory().first;
      expect(history, hasLength(1));
      expect(history.first.contactName, 'Past');
      expect(history.first.outcome, 'placed');

      final logs = await fakeRepo.watchCallLog().first;
      expect(logs, hasLength(1));
      expect(logs.first.origin, 'scheduled');

      final queued = await db.takeOutbox();
      expect(queued, hasLength(1));
      expect(queued.first.kind, 'call_logs');
    },
  );
}

class _StubDialer implements DialerService {
  _StubDialer({required this.succeeds});
  final bool succeeds;

  @override
  Future<bool> dial(String? phone) async => succeeds;
}
