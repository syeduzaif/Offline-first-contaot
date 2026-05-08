// App-wide constants. Per the agent guidelines, prefer top-level
// `k`-prefixed constants here over class-statics scattered across the
// codebase.

const String kAppName = 'Offline Dummy';
const String kDbFileName = 'app.db';
const String kSecureStorageKeyName = 'sqlcipher_key_v1';

const String kApiBaseUrl = 'https://jsonplaceholder.typicode.com';
const String kContactsKind = 'users';
const String kCallLogsKind = 'call_logs';

const Duration kForegroundSyncInterval = Duration(seconds: 30);
const Duration kBackgroundSyncFrequency = Duration(minutes: 15);
const String kBackgroundSyncTaskName = 'syncContacts';
const String kBackgroundSyncUniqueName = 'sync-contacts';
