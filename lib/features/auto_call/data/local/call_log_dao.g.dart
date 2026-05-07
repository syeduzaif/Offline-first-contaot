// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_log_dao.dart';

// ignore_for_file: type=lint
mixin _$CallLogDaoMixin on DatabaseAccessor<AppDatabase> {
  $CallLogsTable get callLogs => attachedDatabase.callLogs;
  CallLogDaoManager get managers => CallLogDaoManager(this);
}

class CallLogDaoManager {
  final _$CallLogDaoMixin _db;
  CallLogDaoManager(this._db);
  $$CallLogsTableTableManager get callLogs =>
      $$CallLogsTableTableManager(_db.attachedDatabase, _db.callLogs);
}
