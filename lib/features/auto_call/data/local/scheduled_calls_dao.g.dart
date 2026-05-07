// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_calls_dao.dart';

// ignore_for_file: type=lint
mixin _$ScheduledCallsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ScheduledCallsTable get scheduledCalls => attachedDatabase.scheduledCalls;
  ScheduledCallsDaoManager get managers => ScheduledCallsDaoManager(this);
}

class ScheduledCallsDaoManager {
  final _$ScheduledCallsDaoMixin _db;
  ScheduledCallsDaoManager(this._db);
  $$ScheduledCallsTableTableManager get scheduledCalls =>
      $$ScheduledCallsTableTableManager(
        _db.attachedDatabase,
        _db.scheduledCalls,
      );
}
