import 'package:drift/drift.dart';

/// A user-created intent to call someone at a future time. Purely local —
/// not synced to the server. When `runAt` arrives, the row is "fired":
/// `firedAt` gets stamped, an outcome is recorded, and (if outcome=='placed')
/// a CallLog row is inserted in the same transaction.
class ScheduledCalls extends Table {
  TextColumn get id => text()();
  TextColumn get contactId => text()();
  TextColumn get contactName => text()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get runAt => dateTime()();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get firedAt => dateTime().nullable()();

  /// 'placed' | 'cancelled' | 'missed' | null (still upcoming)
  TextColumn get outcome => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
