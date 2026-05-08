import 'package:flutter_test/flutter_test.dart';
import 'package:offline_dummy_app/core/constants/app_constants.dart';
import 'package:offline_dummy_app/core/services/database.dart';
import 'package:offline_dummy_app/features/contacts/data/local/contacts_dao.dart';
import 'package:offline_dummy_app/features/contacts/data/repositories/contacts_repository.dart';

void main() {
  late AppDatabase db;
  late ContactsRepository repo;

  setUp(() {
    db = AppDatabase.memory();
    repo = ContactsRepository(db: db, dao: ContactsDao(db));
  });

  tearDown(() async {
    await db.close();
  });

  test('upsert writes the row AND enqueues an outbox op atomically', () async {
    final c = await repo.upsert(name: 'Dani', email: 'd@x.io');
    expect(c.id, isNotEmpty);

    final saved = await repo.findById(c.id);
    expect(saved!.name, 'Dani');

    final queued = await db.takeOutbox();
    expect(queued, hasLength(1));
    expect(queued.first.kind, kContactsKind);
    expect(queued.first.id, c.id);
  });

  test('delete soft-deletes locally AND enqueues a delete op', () async {
    final c = await repo.upsert(name: 'Eve', email: 'e@x.io');
    // Drain the upsert op so the next take only sees the delete.
    final upserts = await db.takeOutbox();
    await db.ackOutbox(upserts.map((o) => o.opId));

    await repo.delete(c.id);

    final stillThere = await repo.findById(c.id);
    expect(stillThere!.deletedAtLocal, isNotNull);

    final queued = await db.takeOutbox();
    expect(queued, hasLength(1));
    expect(queued.first.kind, kContactsKind);
    expect(queued.first.id, c.id);
  });

  test('upsert on an existing contact records baseUpdatedAt', () async {
    final first = await repo.upsert(name: 'Frank', email: 'f@x.io');
    await db.ackOutbox(
      (await db.takeOutbox()).map((o) => o.opId),
    );

    await repo.upsert(id: first.id, name: 'Frankie', email: 'f@x.io');
    final ops = await db.takeOutbox();
    expect(ops, hasLength(1));
    final op = ops.first;
    expect(op.kind, kContactsKind);
    expect(op.id, first.id);
  });
}
