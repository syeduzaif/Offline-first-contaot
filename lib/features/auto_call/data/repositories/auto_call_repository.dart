import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/database.dart';
import '../../../../core/utils/logger.dart';
import '../local/call_log_dao.dart';
import '../local/scheduled_calls_dao.dart';
import '../services/dialer_service.dart';

const String _kindCallLogs = 'call_logs';

/// Gatekeeper for the auto_call feature. Mirrors `ContactsRepository`'s
/// pattern: writes happen inside a single Drift transaction that groups
/// the row mutation and the outbox enqueue together so a crash can never
/// lose the user's intent.
class AutoCallRepository {
  AutoCallRepository({
    required this.db,
    required this.scheduledCallsDao,
    required this.callLogDao,
    DialerService? dialer,
    Uuid? uuid,
  })  : _dialer = dialer ?? const DialerService(),
        _uuid = uuid ?? const Uuid();

  final AppDatabase db;
  final ScheduledCallsDao scheduledCallsDao;
  final CallLogDao callLogDao;
  final DialerService _dialer;
  final Uuid _uuid;

  Stream<List<ScheduledCall>> watchUpcoming() =>
      scheduledCallsDao.watchUpcoming();

  Stream<List<ScheduledCall>> watchHistory() =>
      scheduledCallsDao.watchHistory();

  Stream<List<CallLog>> watchCallLog() => callLogDao.watchAll();

  Future<ScheduledCall> schedule({
    required String contactId,
    required String contactName,
    String? phone,
    required DateTime runAt,
    String? reason,
  }) async {
    final now = DateTime.now().toUtc();
    final row = ScheduledCall(
      id: _uuid.v4(),
      contactId: contactId,
      contactName: contactName,
      phone: phone,
      runAt: runAt,
      reason: reason,
      createdAt: now,
      firedAt: null,
      outcome: null,
    );
    await scheduledCallsDao.upsert(row);
    return row;
  }

  Future<void> cancel(String id) async {
    final existing = await scheduledCallsDao.findById(id);
    if (existing == null) return;
    if (existing.firedAt != null) return; // already fired, nothing to cancel
    await scheduledCallsDao.markFired(
      id: id,
      firedAt: DateTime.now().toUtc(),
      outcome: 'cancelled',
    );
  }

  /// Open the dialer for a manual call. On success, records a CallLog
  /// row and enqueues it for sync.
  Future<bool> placeCallNow({
    required String contactId,
    required String contactName,
    String? phone,
    String origin = 'manual',
  }) async {
    final ok = await _dialer.dial(phone);
    if (!ok) {
      appLogger.w('Dialer refused/failed for $phone');
      return false;
    }
    await _recordCallLog(
      contactId: contactId,
      contactName: contactName,
      phone: phone,
      origin: origin,
    );
    return true;
  }

  /// Fire any scheduled calls whose runAt has passed. For each due row:
  /// open the dialer (best-effort), record a call_log entry, mark the
  /// scheduled call as fired with outcome 'placed' (or 'missed' if the
  /// dialer refused). All of this is transactional per row.
  Future<int> fireDueScheduledCalls({DateTime? now, bool openDialer = true}) async {
    final due = await scheduledCallsDao.findDue(now: now);
    var firedCount = 0;
    for (final row in due) {
      var outcome = 'missed';
      if (openDialer) {
        final placed = await _dialer.dial(row.phone);
        outcome = placed ? 'placed' : 'missed';
      }

      await db.transaction(() async {
        if (outcome == 'placed') {
          await _insertCallLogAndEnqueue(
            contactId: row.contactId,
            contactName: row.contactName,
            phone: row.phone,
            origin: 'scheduled',
          );
        }
        await scheduledCallsDao.markFired(
          id: row.id,
          firedAt: DateTime.now().toUtc(),
          outcome: outcome,
        );
      });
      firedCount++;
    }
    return firedCount;
  }

  Future<void> _recordCallLog({
    required String contactId,
    required String contactName,
    String? phone,
    required String origin,
  }) async {
    await db.transaction(() async {
      await _insertCallLogAndEnqueue(
        contactId: contactId,
        contactName: contactName,
        phone: phone,
        origin: origin,
      );
    });
  }

  Future<void> _insertCallLogAndEnqueue({
    required String contactId,
    required String contactName,
    String? phone,
    required String origin,
  }) async {
    final now = DateTime.now().toUtc();
    final entry = CallLog(
      id: _uuid.v4(),
      contactId: contactId,
      contactName: contactName,
      phone: phone,
      placedAt: now,
      durationSec: 0,
      notes: null,
      origin: origin,
      updatedAt: now,
      deletedAt: null,
      deletedAtLocal: null,
    );
    await callLogDao.upsert(entry);
    await db.enqueue(
      UpsertOp.create(
        kind: _kindCallLogs,
        id: entry.id,
        payloadJson: entry.toJson(),
      ),
    );
  }
}
