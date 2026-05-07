import '../../data/repositories/auto_call_repository.dart';

class CancelScheduledCall {
  const CancelScheduledCall(this._repo);
  final AutoCallRepository _repo;

  Future<void> call(String id) => _repo.cancel(id);
}
