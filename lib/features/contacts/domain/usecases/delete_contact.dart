import '../../data/repositories/contacts_repository.dart';

class DeleteContact {
  const DeleteContact(this._repo);
  final ContactsRepository _repo;

  Future<void> call(String id) => _repo.delete(id);
}
