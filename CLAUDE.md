# CLAUDE.md — Flutter Offline-First App Agent Guidelines

> This file tells the AI agent how to think, write, and structure code for this project.
> Keep code **simple**, **readable**, and **consistent**. If something can be done in fewer lines without sacrificing clarity — do it that way.

---

## 🧠 Core Philosophy

- **Local database = source of truth.** The app must work fully offline. Network is a bonus, not a requirement.
- **Keep it stupid simple (KISS).** Write the simplest code that works. No over-engineering.
- **No duplicate logic.** If it's written once, reuse it. Extract shared code to `core/`.
- **Reactive by default.** Use `Stream<T>` from the database. The UI reacts — it never polls.
- **One job per file.** Each file does one thing. If a file is getting long, it probably needs to be split.

---

## 🔒 Outbox / Sync Invariant

**The single most important rule in this codebase. Read it twice.**

> Every write to a synced table must — within the same Drift transaction — also enqueue a corresponding entry in `sync_outbox`. No exceptions.

This is the entire offline-first guarantee. Break this rule and the local DB and the server can drift apart silently.

### The shape every repository write must take

```dart
// ✅ Correct — atomic write + enqueue inside one transaction
await db.transaction(() async {
  await dao.upsert(contact);
  await db.enqueue(UpsertOp.create(
    kind: kContactsKind,
    id: contact.id,
    payloadJson: contact.toJson(),
  ));
});

// ❌ Wrong — two separate commits, can desync on crash between them
await dao.upsert(contact);
await db.enqueue(...);

// ❌ Wrong — bypasses the repository entirely, no outbox at all
await ref.read(contactsDaoProvider).upsert(contact);
```

### What counts as a "synced table"

A table registered in `sync_engine.dart`'s `tables: [...]` list as a `SyncableTable<T>`. That list IS the registry.

| Table | Synced? | Outbox enqueue? |
|---|---|---|
| `contacts` | ✅ kind `users` | required |
| `call_logs` | ✅ kind `call_logs` | required |
| `scheduled_calls` | ❌ local-only | NOT required |
| `sync_outbox`, `sync_cursors` | sync infrastructure | N/A |

If you're adding a new table, decide first: is it synced or local-only? That decision determines whether every write needs an outbox enqueue. When in doubt, look at `sync_engine.dart`.

### How to enforce it

There are no automated checks. Discipline lives in two places:

1. **All writes to synced tables go through the feature's repository.** DAOs are an implementation detail of the repository — never call them from widgets, notifiers, or use-cases.
2. **Every repository write method wraps the row mutation + `db.enqueue(...)` in a single `db.transaction { ... }`.** No exceptions, no "I'll add the enqueue later," no "this is a small change."

If you find yourself writing to a synced table outside a `db.transaction` that also enqueues — stop. You're breaking the invariant.

### The four common ways this rule gets broken

1. **Bypassing the repository** — calling a DAO directly from a widget or notifier because the DAO happens to be exposed via a provider. The DAO doesn't know about sync; only the repo does.
2. **Splitting the transaction** — running `dao.upsert` and `db.enqueue` as two separate `await`s. A crash between them desyncs.
3. **Forgetting to enqueue when adding a new method** — a new `archiveContact()` method that writes the row but skips the outbox. The change is invisible to the server forever.
4. **Writing to a synced table from a non-repository service** — only the repository (and the sync engine itself, on pull) has permission to write to synced tables.

### The exception: pull-side writes inside `SyncEngine`

When the sync engine pulls data from the server and writes it to the local DB, it does NOT enqueue an outbox entry. Pull is *receiving from the server* — there's nothing to send back. This exception lives entirely inside the `offline_first_sync_drift` package and the `JsonPlaceholderTransport`. **Code outside the engine never has this exception.**

### Checklist when reviewing any change touching a synced table

1. Is this write going through a repository?
2. Is the repository wrapping the write + enqueue in `db.transaction`?
3. Does the enqueue's `kind` match the table's registration in `sync_engine.dart`?
4. If this is a new mutation method, does the same shape carry over?

If any answer is "no" — the invariant is at risk. Fix it before merging.

---

## 🗄️ Drift Migrations

Schema changes affect users who already installed the app. Their data isn't disposable. Treat schema migrations with the same care as a production database migration.

### The four-step rule for every schema change

1. **Edit the table definition** in its `*_table.dart` file.
2. **Bump `schemaVersion`** by exactly +1 in `core/services/database.dart`.
3. **Add an `if (from < N)` block** to `onUpgrade` with the migration steps.
4. **Run `dart run build_runner build`** to regenerate `database.g.dart`.

If you do steps 1 + 4 without 2 + 3, existing users crash on first query against the new column/table.
If you bump `schemaVersion` without writing the `onUpgrade` step, the version is a lie — nothing actually migrates.

### The migration we already shipped (v1 → v2)

```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) => m.createAll(),                     // first install
  onUpgrade: (m, from, to) async {                    // existing install
    if (from < 2) {
      await m.createTable(scheduledCalls);
      await m.createTable(callLogs);
    }
  },
);
```

Three things to notice:

- `onCreate` calls `m.createAll()` — new installs always get the current full schema, no manual list to maintain.
- The `if (from < N)` guard is required. A user on v1 jumping straight to v3 must run both v1→v2 AND v2→v3 in one launch.
- `schemaVersion: 2` matches the highest `if (from < N)` step. Drop one and the other is wrong.

## ⚙️ Background Isolate Rules

`workmanager` fires the bg callback in a **separate isolate** with no access to your main-isolate state. Treat it as a fresh process.

**Hard rules for any bg callback:**

1. Top-level/static function annotated `@pragma('vm:entry-point')`. Without the pragma, release-build tree-shaking deletes the function.
2. Re-bootstrap every service from scratch — keychain → DB → dio → engine. You cannot reach into Riverpod, the main DB, or any singleton from the main isolate.
3. Wrap the body in `try { ... } catch { return false; } finally { await db?.close(); }`. Always close the DB. Always log errors with the `[bg]` prefix.
4. Return `true` for success, `false` to ask the OS to retry. Never let an exception escape `executeTask`.
5. No UI calls — no `BuildContext`, no `Navigator`, no `runApp`, no `ScaffoldMessenger`.
6. Trust the registered constraints (e.g. `NetworkType.connected`). Don't double-check.
7. Operations must be idempotent — bg tasks can run more than once.
8. Always set timeouts on network calls. Bg tasks have OS-imposed time limits (Android ~10min, iOS ~30s).

**Common breakages:**

- Capturing a foreground variable inside the callback closure — it's null in the bg isolate
- Forgetting `await db?.close()` in `finally` — DB locks accumulate across runs
- Removing `@pragma('vm:entry-point')` — release builds drop the function entirely
- Adding plugins without checking bg-isolate compatibility (most need manual registration)

The reference implementation lives in `core/services/background_worker.dart` — copy that shape for any future bg task.

### Migration step cheatsheet

| Change | Method |
|---|---|
| New table | `await m.createTable(myTable);` |
| New nullable column | `await m.addColumn(table, table.col);` |
| New `NOT NULL` column | declare `.withDefault(...)` in the table OR use `m.alterTable(TableMigration(...))` |
| Rename column / change type | `m.alterTable(TableMigration(...))` |
| Drop column (older SQLite) | `m.alterTable(TableMigration(...))` |
| Drop table | `await m.deleteTable('table_name');` |

`TableMigration` does the SQLite "create new table → copy data → drop old → rename" dance for you when `ALTER TABLE` isn't enough.

### Never

- **Lower `schemaVersion`** — Drift refuses to open a DB whose recorded version is higher than the code. Once shipped, version numbers only go up.
- **Edit a previously-shipped `if (from < N)` block** — users who installed at that version already ran the old step and won't re-run it. Always add a *new* step for the next version.
- **Change a column name or type without an `alterTable` migration** — codegen will silently regenerate the schema, but existing users' DBs still have the old shape.
- **Skip running `build_runner` after a schema change** — `database.g.dart` is the source the migration system compares against. A stale `.g.dart` ships a migration that targets the old schema.

### Sync interaction

Local schema is independent of the server schema. When the two get out of step:

- **Local has a column the server doesn't send** → Drift reads it as `null` (must be nullable, or have a default).
- **Server still sends a column the local schema dropped** → silently ignored by `fromJson`. No crash, but data is lost.
- **Renamed column** → coordinate cross-side renames in two steps: add the new column, dual-write for one release, then drop the old.

For JSONPlaceholder this is moot (no real schema). For any future real backend, this is the whole reason to run schema migrations server-side and client-side as a coordinated pair.

### Optional tooling — schema tracking

Drift can dump a snapshot of the schema at each version so codegen can verify nothing drifted:

```bash
dart run drift_dev schema dump lib/core/services/database.dart drift_schemas/
```

Not set up in this project. If you ship migration #3 and beyond, this turns "did I forget to bump the version?" from a runtime crash into a build error.

---

## 📝 Logging

_TBD — to discuss before drafting._

---

## 🌐 Server Contract

_TBD — to discuss before drafting._

---

## 📁 Project Structure

Always follow this structure. Do not deviate without a good reason.

```
lib/
  main.dart                        # App entry point, provider scope
  app.dart                         # Root widget, theme, router
  core/
    services/
      api_client.dart              # Dio setup + cache interceptor
      database.dart                # Drift + SQLCipher initialization
      sync_engine.dart             # Sync agent wrapper
      connectivity_service.dart    # Network status watcher
      secure_storage.dart          # Encryption key + token storage
    constants/
      app_constants.dart           # Strings, durations, limits
    utils/
      extensions.dart              # Dart extension methods
      logger.dart                  # App-wide logging utility
    themes/
      app_theme.dart               # Light/dark theme definitions
    widgets/
      offline_banner.dart          # Shown when offline
      loading_widget.dart          # Shared loading indicator
  features/
    <feature_name>/
      presentation/
        pages/                     # Full screens
        widgets/                   # Feature-specific UI pieces
        controllers/               # Riverpod notifiers or Cubits
      domain/
        entities/                  # Plain Dart objects (freezed)
        usecases/                  # One class, one action
      data/
        models/                    # JSON-serializable DTOs
        local/                     # Drift tables + DAOs
        remote/                    # API service classes
        repositories/              # Combines local + remote
test/                              # Mirrors lib/ structure — add later
```

**Rules:**

- New feature = new folder under `features/`
- Shared UI = `core/widgets/`
- Shared logic = `core/utils/` or `core/services/`
- Never put business logic in widgets or pages

---

## 📦 Approved Packages

Only use packages from this list unless there is a strong reason to add a new one (and you must explain why).

| Purpose | Package |
|---|---|
| Local DB | `drift` + `sqlite3_flutter_libs` |
| DB Encryption | `sqflite_sqlcipher` |
| Sync Agent | `offline_first_sync_drift` + REST adapter |
| State Management | `flutter_riverpod` |
| HTTP | `dio` + `dio_cache_interceptor` |
| Connectivity | `connectivity_plus` + `flutter_offline` |
| Secure Storage | `flutter_secure_storage` |
| Code Generation | `freezed` + `json_serializable` + `build_runner` |
| Background Tasks | `workmanager` |

> **Do not add** packages that duplicate existing ones. Check `pubspec.yaml` before suggesting a new dependency.

---

## 🏗️ Layer Rules

### Presentation (Pages & Widgets)

- Widgets only read state and dispatch events
- Zero business logic here
- Use `ConsumerWidget` or `ConsumerStatefulWidget` with Riverpod
- Use `ref.watch()` for reactive data, `ref.read()` for one-time actions

```dart
// ✅ Good
class StudentListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentListProvider);
    return students.when(
      data: (list) => StudentList(students: list),
      loading: () => const LoadingWidget(),
      error: (e, _) => ErrorText(message: e.toString()),
    );
  }
}

// ❌ Bad — logic in widget
class StudentListPage extends StatefulWidget {
  @override
  State<StudentListPage> createState() => _State();
}
class _State extends State<StudentListPage> {
  List students = [];
  @override
  void initState() {
    super.initState();
    fetchStudents().then((s) => setState(() => students = s)); // ❌
  }
}
```

### State Management (Riverpod 3.x)

Riverpod is the **only** state-management primitive in this app. Don't introduce Bloc, GetX, MobX, or `package:provider`.

#### Pick the right provider type

| Type | Use for | Default? |
|---|---|---|
| `Provider<T>` | Synchronous derived/computed value, immutable | For pure DI of services |
| `StreamProvider<T>` | Reactive read from DB or any stream | **Yes — for any "watch a list"** |
| `FutureProvider<T>` | One-shot async read | When source isn't reactive |
| `NotifierProvider<N, T>` | Mutable synchronous state with imperative methods | When the UI needs to call `notifier.doSomething()` |
| `AsyncNotifierProvider<N, T>` | Mutable async state with `build()` + mutating methods | The one place mutable async state lives |

**Deprecated in Riverpod 3 — do not introduce:**
- `StateProvider` (use `NotifierProvider`)
- `StateNotifierProvider` (moved to `package:riverpod/legacy.dart`; use `NotifierProvider`/`AsyncNotifierProvider`)
- `ChangeNotifierProvider`

#### Notifier vs plain provider — when do I write a Notifier?

If the provider just **reads** something from the repository → plain provider, no Notifier:

```dart
// ✅ Just exposing a stream — no Notifier needed
final contactsListProvider = StreamProvider<List<Contact>>((ref) {
  return ref.watch(contactsRepositoryProvider).watchAll();
});
```

If the screen needs to **trigger mutations** that affect this state → write a Notifier:

```dart
// ✅ Mutations live on a Notifier
class ContactList extends AsyncNotifier<List<Contact>> {
  @override
  Future<List<Contact>> build() => ref.watch(contactsRepositoryProvider).watchAll().first;

  Future<void> add(Contact c) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(contactsRepositoryProvider).upsert(c));
  }
}
```

In *this* app, mutations usually go through use-cases (`ref.read(upsertContactProvider).call(...)`), so most pages don't need a Notifier — they `ref.watch` a `StreamProvider` for display and `ref.read` a use-case on button taps. Only reach for a Notifier when the screen has its own state machine to manage.

#### `ref.watch` / `ref.read` / `ref.listen`

| Method | When to use | Where to use |
|---|---|---|
| `ref.watch(p)` | Get the value AND rebuild on change | `build()` and other provider bodies |
| `ref.read(p)` | Get the value once, no rebuild | `onPressed`, action callbacks, one-shot ops |
| `ref.listen(p, cb)` | React to changes with a side effect (snackbar, navigate) | Inside `build()`, alongside `ref.watch` |

**Cardinal rules:**

- ❌ Never use `ref.read` in `build()` to "optimize." It bypasses reactivity and creates ghost state.
- ❌ Never use `ref.watch` inside an `onPressed` or other callback — Riverpod throws at runtime.
- `ref.listen` is for side effects only, never for displaying data.

```dart
// ✅ Good
class ContactsListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsListProvider);  // reactive read

    ref.listen(syncStatusProvider, (prev, next) {       // side effect on change
      if (next.value is SyncStatusError) {
        ScaffoldMessenger.of(context).showSnackBar(...);
      }
    });

    return FloatingActionButton(
      onPressed: () =>
          ref.read(upsertContactProvider).call(...),    // one-shot action
    );
  }
}

// ❌ Bad — ref.read in build()
final contacts = ref.read(contactsListProvider);  // won't rebuild on change
```

#### Reduce rebuilds with `ref.select`

When a widget only cares about **one field** of a larger value:

```dart
// ❌ Rebuilds when any field of DbStats changes
final stats = ref.watch(dbStatsProvider);
return Text('${stats.value?.activeCount ?? 0}');

// ✅ Rebuilds only when activeCount changes
final count = ref.watch(dbStatsProvider.select((s) => s.value?.activeCount ?? 0));
return Text('$count');
```

#### Platform services: throw by default, override in `main()`

For app-lifetime services (DB, connectivity, sync engine), declare a default that throws and override in `ProviderScope`:

```dart
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Override in ProviderScope.');
});

// main.dart
runApp(ProviderScope(overrides: [
  appDatabaseProvider.overrideWithValue(db),
  ...
], child: const App()));
```

Why throw rather than construct lazily?
- **Forces tests** to set up their own `ProviderScope` with mocks.
- **Construction has side effects** (file I/O, native plugin calls) that must run once in `main()`, not lazily on first read.

#### Compose small providers — don't bundle

```dart
// ✅ Each provider has one job; widgets compose them
final contactByIdProvider = FutureProvider.family<Contact?, String>((ref, id) {
  return ref.watch(contactsRepositoryProvider).findById(id);
});

// ❌ Bad — one provider returning a tuple
final contactScreenStateProvider = Provider((ref) {
  return (
    ref.watch(contactByIdProvider(id)),
    ref.watch(isOnlineProvider),
    ref.watch(pendingCountProvider),
  );
});
```

The widget composes the screen state by watching the small providers it actually needs.

#### `ref.invalidate` and `ref.refresh`

- `ref.invalidate(p)` — mark a provider stale, rebuilds on next read.
- `ref.refresh(p)` — invalidate AND immediately re-read; returns the new value/`Future`.

**Never call from inside `build()`** — infinite rebuild. Only from event handlers.

#### Auto-dispose

- App-lifetime services (DB, sync engine, connectivity) → **no** auto-dispose.
- Per-screen / per-route state (form drafts, search filters, pagination) → use `.autoDispose` so memory frees when the screen is gone.

#### Naming

- Providers: `featureNameProvider` (`contactsListProvider`, `syncStatusProvider`).
- For platform services exposing a class instance, type-suffix is fine: `appDatabaseProvider`, `connectivityServiceProvider`.
- Avoid generic names: `dataProvider`, `stateProvider`.

#### Hard NO list

| Don't | Why |
|---|---|
| `ref.read` inside `build()` | Bypasses reactivity → ghost state |
| `ref.watch` inside `onPressed` / callbacks | Throws at runtime |
| Pass `BuildContext` into a provider | Couples state to widget tree, untestable |
| Return tuples / `Map<String, dynamic>` from a provider | Compose smaller providers instead |
| Mutate state outside a Notifier (global vars, `StateProvider`) | Single source of truth lives in providers |
| `setState` for anything that could be a provider | Riverpod is the source of truth |
| Subscribe to streams in `initState` | Use a `StreamProvider` and `ref.watch` |

### Repository

- Reads from local DB first, always
- Writes go to local DB first, then sync queue handles the rest
- Exposes `Stream<T>` for lists, `Future<T?>` for single items
- No Dio calls directly — delegates to a remote service class

```dart
// ✅ Good pattern
class StudentRepository {
  final StudentDao _local;
  final StudentRemoteService _remote;
  final SyncEngine _sync;

  Stream<List<Student>> watchAll() => _local.watchAll();

  Future<void> save(Student student) async {
    // Write locally + queue sync — one transaction
    await _local.upsertWithSyncEvent(student);
  }

  Future<void> refreshFromServer() async {
    try {
      final remoteData = await _remote.fetchAll();
      await _local.upsertAll(remoteData);
    } catch (_) {
      // Silent fail — local data still serves the UI
    }
  }
}
```

### Local Database (Drift DAOs)

- One DAO per feature/entity
- Use `watch()` methods to return `Stream<T>`
- Always use transactions when writing multiple tables
- Name methods clearly: `watchAll`, `findById`, `upsert`, `deleteById`

```dart
// ✅ Good
@DriftAccessor(tables: [Students])
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
  StudentDao(AppDatabase db) : super(db);

  Stream<List<StudentData>> watchAll() => select(students).watch();

  Future<void> upsert(StudentsCompanion entry) =>
      into(students).insertOnConflictUpdate(entry);
}
```

### Sync Agent

- Runs in background via `workmanager`
- Reads from `sync_queue` table, sends batches to server
- Applies server deltas back into local DB
- Never blocks the UI thread

---

## 🔄 Data Flow Rules

**Reading data:**

```
UI (watch provider) → Notifier → Repository → Drift DAO → Stream<T> → UI updates
                                                         ↓ (if online)
                                               Remote service refreshes DB in background
```

**Writing data:**

```
UI action → Notifier.method() → Repository.save() → DAO writes locally + adds to sync_queue
                                                  → UI updates immediately via stream
                                                  → Sync agent picks up queue later
```

---

## ✍️ Code Style Rules

### Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables & methods: `camelCase`
- Constants: `kConstantName` or `SCREAMING_SNAKE` in `app_constants.dart`
- Providers: `featureNameProvider` (e.g. `studentListProvider`)

### General

- Max **500 lines per file**. If a file hits 500 lines — stop and split it immediately.
- Max **5 lines per function**. If a function grows beyond 5 lines — extract the extra logic into a helper function with a clear name.
- Prefer named parameters for functions with 2+ args
- Always handle `null` explicitly — avoid `!` unless you're 100% sure
- Use `const` wherever possible
- Avoid deeply nested widgets — extract to named widget methods or separate widget classes

```dart
// ✅ Good — function under 5 lines
Future<void> saveStudent(Student student) async {
  await _local.upsert(student.toCompanion());
  await _sync.enqueue(SyncEvent.upsert(student.id));
}

// ❌ Bad — function doing too much, way over 5 lines
Future<void> saveStudent(Student student) async {
  final companion = StudentsCompanion(
    id: Value(student.id),
    name: Value(student.name),
    // ... 10 more fields
  );
  await _local.upsert(companion);
  final event = SyncEvent(entityId: student.id, action: 'upsert', table: 'students', createdAt: DateTime.now());
  await _syncQueue.insert(event);
  log.info('Student saved and queued: ${student.id}');
}

// ✅ Fix — split into helpers
Future<void> saveStudent(Student student) async {
  await _local.upsert(student.toCompanion());
  await _queueSyncEvent(student.id);
}

Future<void> _queueSyncEvent(String id) async {
  await _syncQueue.insert(SyncEvent.upsert(id, table: 'students'));
  log.info('Queued sync for: $id');
}
```

### Widget Splitting Rules

- A widget file must not exceed **500 lines**. Split it when it gets close.
- If a widget has more than **one distinct visual section**, each section becomes its own widget class in its own file.
- Never build large trees inline — extract every meaningful chunk into a named widget.
- Name extracted widgets descriptively: `StudentCard`, `EmptyStudentList`, `SyncStatusBanner` — not `_Widget1` or `_Helper`.

```dart
// ✅ Good — split into small focused widgets
// student_list_page.dart
class StudentListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentListProvider);
    return Scaffold(
      appBar: const StudentListAppBar(),
      body: students.when(
        data: (list) => list.isEmpty ? const EmptyStudentList() : StudentList(students: list),
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorText(message: e.toString()),
      ),
    );
  }
}
// student_list.dart         — just the list
// empty_student_list.dart   — just the empty state
// student_list_app_bar.dart — just the app bar

// ❌ Bad — everything crammed into one build method
@override
Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Students'),
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () { /* search logic */ }),
        IconButton(icon: const Icon(Icons.filter), onPressed: () { /* filter logic */ }),
      ],
    ),
    body: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text('Total: ${students.length}', style: Theme.of(context).textTheme.titleLarge),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(students[i].name),
              subtitle: Text(students[i].email),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () { /* delete logic */ },
              ),
            ),
          ),
        ),
        // ... keeps going for 300 more lines ❌
      ],
    ),
  );
}
```

### Widget Placement (Tier Rule)

Pick where a widget lives by **how widely it is reused** — not by guessing future reuse. Three tiers:

| Tier | Used by | Lives in | Visibility |
|---|---|---|---|
| 1 — Page-private | One page only | Same file as the page | `class _Foo extends StatelessWidget` |
| 2 — Feature-shared | 2+ pages in one feature | `features/<feature>/presentation/widgets/foo.dart` | Public class `Foo` |
| 3 — Truly shared | 2+ features | `core/widgets/foo.dart` | Public class `Foo` |

**Promotion rule:** start at Tier 1. Promote up only when reuse actually happens. Don't predict — observe.

```dart
// ✅ Tier 1 — single page, inline private class
// In sync_center_page.dart
class SyncCenterPage extends ConsumerWidget { ... }
class _StatusCard extends StatelessWidget { ... }   // private to this file
class _OpTile extends StatelessWidget { ... }       // private to this file

// ✅ Tier 2 — used by multiple pages in the contacts feature
// features/contacts/presentation/widgets/contact_tile.dart
class ContactTile extends StatelessWidget { ... }

// ✅ Tier 3 — used by contacts + auto_call + stats pages
// core/widgets/loading_widget.dart
class LoadingWidget extends StatelessWidget { ... }

// ❌ Bad — generic widget hidden inside one feature
// features/contacts/presentation/widgets/loading_widget.dart  ← belongs in core/widgets/
```

**Always prefer a private class over a private build method:**

```dart
// ❌ Bad — Widget-returning function
Widget _buildHeader(BuildContext context) { ... }

// ✅ Good — private widget class
class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) { ... }
}
```

The class form gets a `const` constructor (skipped rebuilds), proper rebuild scoping (only rebuilds when its inputs change), key support, and shows up in DevTools by name.

**Decision flow before extracting any widget:**

```
Will another feature ever use it?
└─ Yes → core/widgets/<name>.dart                                (Tier 3)

Will another page in this feature use it?
└─ Yes → features/<feature>/presentation/widgets/<name>.dart     (Tier 2)

Only this page uses it?
└─ Inline private class _<Name> in the same file                 (Tier 1)
```

Re-evaluate each time you copy-paste — that's the signal it's time to promote.

#### Tier 1 overflow — when a page file approaches 500 lines

The 500-line rule wins over the "keep private widgets inline" rule. When a Tier 1 page file gets too big, **don't promote to Tier 2** (that would falsely signal "feature-shared"). Instead, split into a **page-scoped subfolder**.

**First, sanity-check before splitting:**

1. Is the page actually doing too much? A 500-line page is often a sign it should be 2 pages.
2. Are these widgets really only used by this page? Half the time you'll realize one *is* reusable — that's a real Tier 2 candidate.

If neither applies, create a subfolder named after the page:

```
features/contacts/presentation/pages/
  contacts_list/                              ← page-scoped folder
    contacts_list_page.dart                   ← the page itself
    contacts_list_search_bar.dart             ← was _SearchBar
    contacts_list_empty_state.dart            ← was _EmptyState
    contacts_list_pinned_section.dart         ← was _PinnedSection
```

**Rules for the page subfolder:**

- Filenames prefixed with the page name (`contacts_list_*`) so flat-search makes ownership obvious
- Classes become public (`SearchBar` instead of `_SearchBar`) — Dart can't share private classes across files without `part of`
- **Convention only:** nothing outside this folder imports from inside it. The folder is the encapsulation boundary, even though Dart can't enforce it
- If something in the subfolder later gets imported by another page — that's the Tier 2 promotion signal. Move it up to `presentation/widgets/`

**Decision flow for an oversized Tier 1 page:**

```
Page file approaching 500 lines.
│
├─ Is the page doing too much? → Split it into 2 pages first.
│
├─ Is one of the inline widgets actually reusable? → Promote that one to Tier 2.
│
└─ Genuinely page-scoped, just big? → Create pages/<page_name>/ subfolder
                                       and split the inline classes into files.
```

### Error Handling

- Repositories catch errors silently and serve cached data
- Only surface errors to the user when they genuinely need to take action
- Log all errors with the `logger` utility
- Never swallow errors without at least logging them

```dart
// ✅ Good
try {
  await _remote.push(events);
} catch (e, stack) {
  log.error('Sync push failed', error: e, stackTrace: stack);
  // Will retry next cycle — no need to crash or alert user
}
```

---

## 🔐 Security Rules

- **Never** hardcode API keys, secrets, or passwords
- Store encryption key and tokens only in `flutter_secure_storage`
- Always use HTTPS
- Encrypt the local DB with SQLCipher
- Never log sensitive user data

---

## 🚫 Things the Agent Must Never Do

| Never | Why |
|---|---|
| Put API calls directly in widgets | Breaks separation of concerns |
| Skip local DB write and only write to server | Breaks offline-first guarantee |
| Use `setState` for app-level state | Use Riverpod instead |
| Create a new package for something already in the list | Bloats dependencies |
| Use `Future<void>` where a `Stream` would be better | Kills reactivity |
| Duplicate a model, DAO, or service that already exists | Breaks DRY principle |
| Use `dynamic` types | Kills type safety |
| Write a function longer than 5 lines without splitting | Hard to read and test |
| Let a file grow past 500 lines without splitting | Becomes unmaintainable |
| Build a long widget tree inline instead of extracting widgets | Impossible to scan and reuse |
| Leave `TODO` comments in committed code | Finish it or file an issue |

---

## ✅ Agent Checklist Before Writing Any Code

1. Does this feature already exist somewhere? Check `features/` first.
2. Is there a shared utility in `core/` I should reuse?
3. Am I writing to local DB first before any network call?
4. Am I returning a `Stream` from the repository for reactive UI?
5. Have I added a sync queue event for every write?
6. Is every function ≤5 lines? If not — extract helpers now, not later.
7. Is this file under 500 lines? If not — split it before committing.
8. If this is a widget file — have I extracted every distinct section into its own named widget?

---

## 💬 Communication Style for the Agent

- Be concise in explanations — code speaks louder
- When generating a file, always show the full file content (not partial diffs) unless told otherwise
- If asked to modify existing code, show only what changes and why
- Always explain **why** a pattern is used if it's not immediately obvious
- If you're unsure about a design decision, ask before generating — don't assume

---

*Last updated: project bootstrap. Update this file as the project evolves.*
