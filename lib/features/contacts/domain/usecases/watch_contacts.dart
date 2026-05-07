import '../../../../core/services/database.dart';
import '../../data/repositories/contacts_repository.dart';

class WatchContacts {
  const WatchContacts(this._repo);
  final ContactsRepository _repo;

  Stream<List<Contact>> call() => _repo.watchAll();
}
