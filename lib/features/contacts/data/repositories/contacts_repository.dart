import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/database.dart';
import '../local/contacts_dao.dart';

/// Gatekeeper between the UI/domain layers and the data sources.
///
/// All writes happen as a single Drift transaction:
///   1. Upsert (or soft-delete) in the contacts table.
///   2. Enqueue an outbox entry referring to the same entity.
/// This is the outbox pattern guarantee — a crash between write and
/// network call can never lose the user's intent.
class ContactsRepository {
  ContactsRepository({required this.db, required this.dao, Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase db;
  final ContactsDao dao;
  final Uuid _uuid;

  Stream<List<Contact>> watchAll() => dao.watchAll();

  Future<Contact?> findById(String id) => dao.findById(id);

  /// Create or update a contact, transactionally writing the row and
  /// enqueueing the corresponding sync operation.
  Future<Contact> upsert({
    String? id,
    required String name,
    String? username,
    required String email,
    String? phone,
    String? website,
    String? street,
    String? suite,
    String? city,
    String? zipcode,
    String? companyName,
  }) async {
    final now = DateTime.now().toUtc();
    final isNew = id == null;
    final entityId = id ?? _uuid.v4();

    final existing = isNew ? null : await dao.findById(entityId);
    final contact = Contact(
      id: entityId,
      name: name,
      username: username,
      email: email,
      phone: phone,
      website: website,
      street: street,
      suite: suite,
      city: city,
      zipcode: zipcode,
      companyName: companyName,
      updatedAt: now,
      deletedAt: existing?.deletedAt,
      deletedAtLocal: null,
    );

    await db.transaction(() async {
      await dao.upsert(contact);
      await db.enqueue(
        UpsertOp.create(
          kind: AppConstants.contactsKind,
          id: entityId,
          payloadJson: contact.toJson(),
          baseUpdatedAt: existing?.updatedAt,
        ),
      );
    });

    return contact;
  }

  Future<void> delete(String id) async {
    final now = DateTime.now().toUtc();
    final existing = await dao.findById(id);
    if (existing == null) return;

    await db.transaction(() async {
      await dao.markDeletedLocal(id, now);
      await db.enqueue(
        DeleteOp.create(
          kind: AppConstants.contactsKind,
          id: id,
          baseUpdatedAt: existing.updatedAt,
        ),
      );
    });
  }
}
