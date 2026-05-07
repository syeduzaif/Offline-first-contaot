import 'package:drift/drift.dart';
import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';

class Contacts extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get username => text().nullable()();
  TextColumn get email => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get street => text().nullable()();
  TextColumn get suite => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get zipcode => text().nullable()();
  TextColumn get companyName => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
