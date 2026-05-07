import 'package:drift/drift.dart';

import '../../../../core/services/database.dart';
import 'scheduled_calls_table.dart';

part 'scheduled_calls_dao.g.dart';

@DriftAccessor(tables: [ScheduledCalls])
class ScheduledCallsDao extends DatabaseAccessor<AppDatabase>
    with _$ScheduledCallsDaoMixin {
  ScheduledCallsDao(super.db);

  Stream<List<ScheduledCall>> watchUpcoming() {
    final query = select(scheduledCalls)
      ..where((t) => t.firedAt.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.runAt)]);
    return query.watch();
  }

  Stream<List<ScheduledCall>> watchHistory() {
    final query = select(scheduledCalls)
      ..where((t) => t.firedAt.isNotNull())
      ..orderBy([
        (t) => OrderingTerm(expression: t.firedAt, mode: OrderingMode.desc),
      ]);
    return query.watch();
  }

  Future<List<ScheduledCall>> findDue({DateTime? now}) {
    final query = select(scheduledCalls)
      ..where((t) =>
          t.firedAt.isNull() &
          t.runAt.isSmallerOrEqualValue(now ?? DateTime.now()));
    return query.get();
  }

  Future<ScheduledCall?> findById(String id) {
    return (select(scheduledCalls)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> upsert(ScheduledCall row) {
    return into(scheduledCalls).insertOnConflictUpdate(row);
  }

  Future<int> markFired({
    required String id,
    required DateTime firedAt,
    required String outcome,
  }) {
    return (update(scheduledCalls)..where((t) => t.id.equals(id))).write(
      ScheduledCallsCompanion(
        firedAt: Value(firedAt),
        outcome: Value(outcome),
      ),
    );
  }

  Future<int> removeById(String id) {
    return (delete(scheduledCalls)..where((t) => t.id.equals(id))).go();
  }

  Future<int> upcomingCount() async {
    final row = await (selectOnly(scheduledCalls)
          ..addColumns([scheduledCalls.id.count()])
          ..where(scheduledCalls.firedAt.isNull()))
        .getSingle();
    return row.read(scheduledCalls.id.count()) ?? 0;
  }

  Future<int> dueNowCount({DateTime? now}) async {
    final row = await (selectOnly(scheduledCalls)
          ..addColumns([scheduledCalls.id.count()])
          ..where(scheduledCalls.firedAt.isNull() &
              scheduledCalls.runAt.isSmallerOrEqualValue(now ?? DateTime.now())))
        .getSingle();
    return row.read(scheduledCalls.id.count()) ?? 0;
  }
}
