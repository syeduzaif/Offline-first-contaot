import 'package:flutter_test/flutter_test.dart';
import 'package:offline_dummy_app/core/services/database.dart';
import 'package:offline_dummy_app/features/contacts/data/local/contacts_dao.dart';

void main() {
  late AppDatabase db;
  late ContactsDao dao;

  setUp(() {
    db = AppDatabase.memory();
    dao = ContactsDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('upsert + findById round-trips a contact', () async {
    final c = Contact(
      id: 'abc',
      name: 'Alice',
      email: 'a@x.io',
      updatedAt: DateTime.utc(2026, 5, 1),
    );

    await dao.upsert(c);

    final found = await dao.findById('abc');
    expect(found, isNotNull);
    expect(found!.name, 'Alice');
    expect(found.email, 'a@x.io');
  });

  test('watchAll filters out soft-deleted rows and orders by name', () async {
    await dao.upsert(Contact(
      id: '1',
      name: 'Charlie',
      email: 'c@x.io',
      updatedAt: DateTime.utc(2026, 5, 1),
    ));
    await dao.upsert(Contact(
      id: '2',
      name: 'Alice',
      email: 'a@x.io',
      updatedAt: DateTime.utc(2026, 5, 1),
    ));
    await dao.upsert(Contact(
      id: '3',
      name: 'Bob',
      email: 'b@x.io',
      updatedAt: DateTime.utc(2026, 5, 1),
      deletedAtLocal: DateTime.utc(2026, 5, 2),
    ));

    final list = await dao.watchAll().first;
    expect(list.map((c) => c.name).toList(), ['Alice', 'Charlie']);
  });

  test('markDeletedLocal sets the timestamp', () async {
    await dao.upsert(Contact(
      id: '1',
      name: 'A',
      email: 'a@x.io',
      updatedAt: DateTime.utc(2026, 5, 1),
    ));
    final stamp = DateTime.utc(2026, 5, 5);
    await dao.markDeletedLocal('1', stamp);

    final c = await dao.findById('1');
    expect(c!.deletedAtLocal, stamp);
  });
}
