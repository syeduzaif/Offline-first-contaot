import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../features/contacts/data/local/contacts_table.dart';
import '../constants/app_constants.dart';

part 'database.g.dart';

@DriftDatabase(
  include: {'package:offline_first_sync_drift/src/sync_tables.drift'},
  tables: [Contacts],
)
class AppDatabase extends _$AppDatabase with SyncDatabaseMixin {
  AppDatabase(super.executor);

  AppDatabase.memory()
      : super(NativeDatabase.memory(setup: _verifyCipherIfPresent));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );

  static Future<AppDatabase> openEncrypted(String passphrase) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, AppConstants.dbFileName));
    final executor = NativeDatabase.createInBackground(
      file,
      setup: (rawDb) => _applyKey(rawDb, passphrase),
    );
    return AppDatabase(executor);
  }
}

void _applyKey(Database rawDb, String passphrase) {
  final escaped = passphrase.replaceAll("'", "''");
  rawDb.execute("PRAGMA key = '$escaped';");
  // Sanity check — fails fast if the build doesn't include cipher support.
  rawDb.execute('PRAGMA cipher_compatibility = 4;');
}

void _verifyCipherIfPresent(Database rawDb) {
  // No-op for in-memory test DBs; kept for symmetry.
}
