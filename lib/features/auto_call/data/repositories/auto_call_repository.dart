import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/database.dart';
import '../../../../core/utils/logger.dart';
import '../local/call_log_dao.dart';
import '../local/scheduled_calls_dao.dart';
import '../services/dialer_service.dart';

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
    final row = _newScheduledCall(
      contactId: contactId,
      contactName: contactName,
      phone: phone,
      runAt: runAt,
      reason: reason,
    );
    await scheduledCallsDao.upsert(row);
    return row;
  }

  Future<void> cancel(String id) async {
    final existing = await scheduledCallsDao.findById(id);
    if (existing == null || existing.firedAt != null) return;
    await scheduledCallsDao.markFired(
      id: id,
      firedAt: DateTime.now().toUtc(),
      outcome: 'cancelled',
    );
  }

  /// Open the dialer for a manual call. On success records a CallLog
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
    await db.transaction(() => _insertCallLogAndEnqueue(
          contactId: contactId,
          contactName: contactName,
          phone: phone,
          origin: origin,
        ));
    return true;
  }

  /// Fire any scheduled calls whose runAt has passed. Per row: try the
  /// dialer (when allowed), record a call_log entry on success, then
  /// mark the scheduled row as fired — all transactionally.
  Future<int> fireDueScheduledCalls({
    DateTime? now,
    bool openDialer = true,
  }) async {
    final due = await scheduledCallsDao.findDue(now: now);
    for (final row in due) {
      await _fireOne(row, openDialer: openDialer);
    }
    return due.length;
  }

  Future<void> _fireOne(ScheduledCall row, {required bool openDialer}) async {
    final outcome = await _resolveOutcome(row, openDialer: openDialer);
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
  }

  Future<String> _resolveOutcome(
    ScheduledCall row, {
    required bool openDialer,
  }) async {
    if (!openDialer) return 'missed';
    final placed = await _dialer.dial(row.phone);
    return placed ? 'placed' : 'missed';
  }

  ScheduledCall _newScheduledCall({
    required String contactId,
    required String contactName,
    String? phone,
    required DateTime runAt,
    String? reason,
  }) {
    return ScheduledCall(
      id: _uuid.v4(),
      contactId: contactId,
      contactName: contactName,
      phone: phone,
      runAt: runAt,
      reason: reason,
      createdAt: DateTime.now().toUtc(),
      firedAt: null,
      outcome: null,
    );
  }

  Future<void> _insertCallLogAndEnqueue({
    required String contactId,
    required String contactName,
    String? phone,
    required String origin,
  }) async {
    final entry = _newCallLog(
      contactId: contactId,
      contactName: contactName,
      phone: phone,
      origin: origin,
    );
    await callLogDao.upsert(entry);
    await db.enqueue(
      UpsertOp.create(
        kind: kCallLogsKind,
        id: entry.id,
        payloadJson: entry.toJson(),
      ),
    );
  }

  CallLog _newCallLog({
    required String contactId,
    required String contactName,
    String? phone,
    required String origin,
  }) {
    final now = DateTime.now().toUtc();
    return CallLog(
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
  }
}
