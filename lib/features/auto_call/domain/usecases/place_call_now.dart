import '../../data/repositories/auto_call_repository.dart';

class PlaceCallNow {
  const PlaceCallNow(this._repo);
  final AutoCallRepository _repo;

  Future<bool> call({
    required String contactId,
    required String contactName,
    String? phone,
  }) {
    return _repo.placeCallNow(
      contactId: contactId,
      contactName: contactName,
      phone: phone,
    );
  }
}
