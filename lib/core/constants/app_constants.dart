class AppConstants {
  const AppConstants._();

  static const String appName = 'Offline Dummy';
  static const String dbFileName = 'app.db';
  static const String secureStorageKeyName = 'sqlcipher_key_v1';

  static const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';
  static const String contactsKind = 'users';
  static const String callLogsKind = 'call_logs';

  static const Duration foregroundSyncInterval = Duration(seconds: 30);
  static const Duration backgroundSyncFrequency = Duration(minutes: 15);
  static const String backgroundSyncTaskName = 'syncContacts';
  static const String backgroundSyncUniqueName = 'sync-contacts';
}
