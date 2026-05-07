import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/database.dart';
import '../../../contacts/presentation/controllers/providers.dart';
import '../../data/local/call_log_dao.dart';
import '../../data/local/scheduled_calls_dao.dart';
import '../../data/repositories/auto_call_repository.dart';
import '../../data/services/dialer_service.dart';
import '../../domain/usecases/cancel_scheduled_call.dart';
import '../../domain/usecases/place_call_now.dart';
import '../../domain/usecases/schedule_call.dart';

final dialerServiceProvider =
    Provider<DialerService>((ref) => const DialerService());

final scheduledCallsDaoProvider = Provider<ScheduledCallsDao>((ref) {
  return ScheduledCallsDao(ref.watch(appDatabaseProvider));
});

final callLogDaoProvider = Provider<CallLogDao>((ref) {
  return CallLogDao(ref.watch(appDatabaseProvider));
});

final autoCallRepositoryProvider = Provider<AutoCallRepository>((ref) {
  return AutoCallRepository(
    db: ref.watch(appDatabaseProvider),
    scheduledCallsDao: ref.watch(scheduledCallsDaoProvider),
    callLogDao: ref.watch(callLogDaoProvider),
    dialer: ref.watch(dialerServiceProvider),
  );
});

final scheduleCallProvider = Provider<ScheduleCall>((ref) {
  return ScheduleCall(ref.watch(autoCallRepositoryProvider));
});

final cancelScheduledCallProvider = Provider<CancelScheduledCall>((ref) {
  return CancelScheduledCall(ref.watch(autoCallRepositoryProvider));
});

final placeCallNowProvider = Provider<PlaceCallNow>((ref) {
  return PlaceCallNow(ref.watch(autoCallRepositoryProvider));
});

final upcomingCallsProvider = StreamProvider<List<ScheduledCall>>((ref) {
  return ref.watch(autoCallRepositoryProvider).watchUpcoming();
});

final scheduledHistoryProvider = StreamProvider<List<ScheduledCall>>((ref) {
  return ref.watch(autoCallRepositoryProvider).watchHistory();
});

final callLogProvider = StreamProvider<List<CallLog>>((ref) {
  return ref.watch(autoCallRepositoryProvider).watchCallLog();
});
