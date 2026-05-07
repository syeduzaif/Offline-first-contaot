import '../../../../core/services/database.dart';
import '../../data/repositories/contacts_repository.dart';

class UpsertContact {
  const UpsertContact(this._repo);
  final ContactsRepository _repo;

  Future<Contact> call({
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
  }) {
    return _repo.upsert(
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
    );
  }
}
