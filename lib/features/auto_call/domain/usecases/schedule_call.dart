import '../../../../core/services/database.dart';
import '../../data/repositories/auto_call_repository.dart';

class ScheduleCall {
  const ScheduleCall(this._repo);
  final AutoCallRepository _repo;

  Future<ScheduledCall> call({
    required String contactId,
    required String contactName,
    String? phone,
    required DateTime runAt,
    String? reason,
  }) {
    return _repo.schedule(
      contactId: contactId,
      contactName: contactName,
      phone: phone,
      runAt: runAt,
      reason: reason,
    );
  }
}
