import 'package:drift/drift.dart';

import '../../../../core/services/database.dart';
import 'call_log_table.dart';

part 'call_log_dao.g.dart';

@DriftAccessor(tables: [CallLogs])
class CallLogDao extends DatabaseAccessor<AppDatabase>
    with _$CallLogDaoMixin {
  CallLogDao(super.db);

  Stream<List<CallLog>> watchAll() {
    final query = select(callLogs)
      ..where((t) => t.deletedAtLocal.isNull())
      ..orderBy([
        (t) => OrderingTerm(expression: t.placedAt, mode: OrderingMode.desc),
      ]);
    return query.watch();
  }

  Future<int> upsert(CallLog row) {
    return into(callLogs).insertOnConflictUpdate(row);
  }

  Future<int> count() async {
    final row = await (selectOnly(callLogs)
          ..addColumns([callLogs.id.count()])
          ..where(callLogs.deletedAtLocal.isNull()))
        .getSingle();
    return row.read(callLogs.id.count()) ?? 0;
  }
}
