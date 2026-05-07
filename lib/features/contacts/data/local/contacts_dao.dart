import 'package:drift/drift.dart';

import '../../../../core/services/database.dart';
import 'contacts_table.dart';

part 'contacts_dao.g.dart';

@DriftAccessor(tables: [Contacts])
class ContactsDao extends DatabaseAccessor<AppDatabase> with _$ContactsDaoMixin {
  ContactsDao(super.db);

  Stream<List<Contact>> watchAll() {
    final query = select(contacts)
      ..where((tbl) => tbl.deletedAtLocal.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.name)]);
    return query.watch();
  }

  Future<Contact?> findById(String id) {
    return (select(contacts)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> upsert(Contact contact) {
    return into(contacts).insertOnConflictUpdate(contact);
  }

  Future<int> markDeletedLocal(String id, DateTime at) {
    return (update(contacts)..where((t) => t.id.equals(id))).write(
      ContactsCompanion(
        deletedAtLocal: Value(at),
        updatedAt: Value(at),
      ),
    );
  }

  Future<int> hardDelete(String id) {
    return (delete(contacts)..where((t) => t.id.equals(id))).go();
  }

  Future<int> countActive() async {
    final row = await (selectOnly(contacts)
          ..addColumns([contacts.id.count()])
          ..where(contacts.deletedAtLocal.isNull()))
        .getSingle();
    return row.read(contacts.id.count()) ?? 0;
  }

  Future<int> countDeletedLocally() async {
    final row = await (selectOnly(contacts)
          ..addColumns([contacts.id.count()])
          ..where(contacts.deletedAtLocal.isNotNull()))
        .getSingle();
    return row.read(contacts.id.count()) ?? 0;
  }

  Future<DateTime?> mostRecentUpdate() async {
    final row = await (selectOnly(contacts)
          ..addColumns([contacts.updatedAt.max()]))
        .getSingle();
    return row.read(contacts.updatedAt.max());
  }
}
