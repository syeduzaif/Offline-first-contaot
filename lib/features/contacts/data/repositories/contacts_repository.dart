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
    final entityId = id ?? _uuid.v4();
    final existing = id == null ? null : await dao.findById(entityId);
    final contact = _buildContact(
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
      existing: existing,
    );
    await _writeAndEnqueueUpsert(contact, baseUpdatedAt: existing?.updatedAt);
    return contact;
  }

  Future<void> delete(String id) async {
    final existing = await dao.findById(id);
    if (existing == null) return;
    await _writeAndEnqueueDelete(id, baseUpdatedAt: existing.updatedAt);
  }

  Contact _buildContact({
    required String id,
    required String name,
    required String email,
    String? username,
    String? phone,
    String? website,
    String? street,
    String? suite,
    String? city,
    String? zipcode,
    String? companyName,
    Contact? existing,
  }) {
    return Contact(
      id: id,
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
      updatedAt: DateTime.now().toUtc(),
      deletedAt: existing?.deletedAt,
      deletedAtLocal: null,
    );
  }

  Future<void> _writeAndEnqueueUpsert(
    Contact contact, {
    DateTime? baseUpdatedAt,
  }) {
    return db.transaction(() async {
      await dao.upsert(contact);
      await db.enqueue(
        UpsertOp.create(
          kind: kContactsKind,
          id: contact.id,
          payloadJson: contact.toJson(),
          baseUpdatedAt: baseUpdatedAt,
        ),
      );
    });
  }

  Future<void> _writeAndEnqueueDelete(
    String id, {
    required DateTime baseUpdatedAt,
  }) {
    return db.transaction(() async {
      await dao.markDeletedLocal(id, DateTime.now().toUtc());
      await db.enqueue(
        DeleteOp.create(
          kind: kContactsKind,
          id: id,
          baseUpdatedAt: baseUpdatedAt,
        ),
      );
    });
  }
}
