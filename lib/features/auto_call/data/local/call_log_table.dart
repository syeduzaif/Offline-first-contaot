import 'package:drift/drift.dart';
import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';

/// Historical record of an actual call. Synced to the server via the
/// existing sync engine — registered as `SyncableTable<CallLog>` with
/// kind 'call_logs'.
class CallLogs extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get contactId => text()();
  TextColumn get contactName => text()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get placedAt => dateTime()();
  IntColumn get durationSec => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();

  /// 'manual' (Quick Dial) | 'scheduled' (fired by the auto_call timer)
  TextColumn get origin => text().withDefault(const Constant('manual'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
