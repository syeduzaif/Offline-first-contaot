// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SyncCursorsTable extends SyncCursors
    with TableInfo<$SyncCursorsTable, SyncCursorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<int> ts = GeneratedColumn<int>(
    'ts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastIdMeta = const VerificationMeta('lastId');
  @override
  late final GeneratedColumn<String> lastId = GeneratedColumn<String>(
    'last_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [kind, ts, lastId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursorData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('last_id')) {
      context.handle(
        _lastIdMeta,
        lastId.isAcceptableOrUnknown(data['last_id']!, _lastIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lastIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kind};
  @override
  SyncCursorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursorData(
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      ts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ts'],
      )!,
      lastId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_id'],
      )!,
    );
  }

  @override
  $SyncCursorsTable createAlias(String alias) {
    return $SyncCursorsTable(attachedDatabase, alias);
  }
}

class SyncCursorsCompanion extends UpdateCompanion<SyncCursorData> {
  final Value<String> kind;
  final Value<int> ts;
  final Value<String> lastId;
  final Value<int> rowid;
  const SyncCursorsCompanion({
    this.kind = const Value.absent(),
    this.ts = const Value.absent(),
    this.lastId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsCompanion.insert({
    required String kind,
    required int ts,
    required String lastId,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       ts = Value(ts),
       lastId = Value(lastId);
  static Insertable<SyncCursorData> custom({
    Expression<String>? kind,
    Expression<int>? ts,
    Expression<String>? lastId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kind != null) 'kind': kind,
      if (ts != null) 'ts': ts,
      if (lastId != null) 'last_id': lastId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsCompanion copyWith({
    Value<String>? kind,
    Value<int>? ts,
    Value<String>? lastId,
    Value<int>? rowid,
  }) {
    return SyncCursorsCompanion(
      kind: kind ?? this.kind,
      ts: ts ?? this.ts,
      lastId: lastId ?? this.lastId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (ts.present) {
      map['ts'] = Variable<int>(ts.value);
    }
    if (lastId.present) {
      map['last_id'] = Variable<String>(lastId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsCompanion(')
          ..write('kind: $kind, ')
          ..write('ts: $ts, ')
          ..write('lastId: $lastId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opIdMeta = const VerificationMeta('opId');
  @override
  late final GeneratedColumn<String> opId = GeneratedColumn<String>(
    'op_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<int> ts = GeneratedColumn<int>(
    'ts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tryCountMeta = const VerificationMeta(
    'tryCount',
  );
  @override
  late final GeneratedColumn<int> tryCount = GeneratedColumn<int>(
    'try_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _baseUpdatedAtMeta = const VerificationMeta(
    'baseUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> baseUpdatedAt = GeneratedColumn<int>(
    'base_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changedFieldsMeta = const VerificationMeta(
    'changedFields',
  );
  @override
  late final GeneratedColumn<String> changedFields = GeneratedColumn<String>(
    'changed_fields',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    opId,
    kind,
    entityId,
    op,
    payload,
    ts,
    tryCount,
    baseUpdatedAt,
    changedFields,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('op_id')) {
      context.handle(
        _opIdMeta,
        opId.isAcceptableOrUnknown(data['op_id']!, _opIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('try_count')) {
      context.handle(
        _tryCountMeta,
        tryCount.isAcceptableOrUnknown(data['try_count']!, _tryCountMeta),
      );
    }
    if (data.containsKey('base_updated_at')) {
      context.handle(
        _baseUpdatedAtMeta,
        baseUpdatedAt.isAcceptableOrUnknown(
          data['base_updated_at']!,
          _baseUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('changed_fields')) {
      context.handle(
        _changedFieldsMeta,
        changedFields.isAcceptableOrUnknown(
          data['changed_fields']!,
          _changedFieldsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {opId};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      opId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      ts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ts'],
      )!,
      tryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}try_count'],
      )!,
      baseUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_updated_at'],
      ),
      changedFields: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changed_fields'],
      ),
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> opId;
  final Value<String> kind;
  final Value<String> entityId;
  final Value<String> op;
  final Value<String?> payload;
  final Value<int> ts;
  final Value<int> tryCount;
  final Value<int?> baseUpdatedAt;
  final Value<String?> changedFields;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.opId = const Value.absent(),
    this.kind = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.ts = const Value.absent(),
    this.tryCount = const Value.absent(),
    this.baseUpdatedAt = const Value.absent(),
    this.changedFields = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String opId,
    required String kind,
    required String entityId,
    required String op,
    this.payload = const Value.absent(),
    required int ts,
    this.tryCount = const Value.absent(),
    this.baseUpdatedAt = const Value.absent(),
    this.changedFields = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : opId = Value(opId),
       kind = Value(kind),
       entityId = Value(entityId),
       op = Value(op),
       ts = Value(ts);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? opId,
    Expression<String>? kind,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<int>? ts,
    Expression<int>? tryCount,
    Expression<int>? baseUpdatedAt,
    Expression<String>? changedFields,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opId != null) 'op_id': opId,
      if (kind != null) 'kind': kind,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (ts != null) 'ts': ts,
      if (tryCount != null) 'try_count': tryCount,
      if (baseUpdatedAt != null) 'base_updated_at': baseUpdatedAt,
      if (changedFields != null) 'changed_fields': changedFields,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? opId,
    Value<String>? kind,
    Value<String>? entityId,
    Value<String>? op,
    Value<String?>? payload,
    Value<int>? ts,
    Value<int>? tryCount,
    Value<int?>? baseUpdatedAt,
    Value<String?>? changedFields,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      opId: opId ?? this.opId,
      kind: kind ?? this.kind,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      ts: ts ?? this.ts,
      tryCount: tryCount ?? this.tryCount,
      baseUpdatedAt: baseUpdatedAt ?? this.baseUpdatedAt,
      changedFields: changedFields ?? this.changedFields,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opId.present) {
      map['op_id'] = Variable<String>(opId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (ts.present) {
      map['ts'] = Variable<int>(ts.value);
    }
    if (tryCount.present) {
      map['try_count'] = Variable<int>(tryCount.value);
    }
    if (baseUpdatedAt.present) {
      map['base_updated_at'] = Variable<int>(baseUpdatedAt.value);
    }
    if (changedFields.present) {
      map['changed_fields'] = Variable<String>(changedFields.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('opId: $opId, ')
          ..write('kind: $kind, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('ts: $ts, ')
          ..write('tryCount: $tryCount, ')
          ..write('baseUpdatedAt: $baseUpdatedAt, ')
          ..write('changedFields: $changedFields, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtLocalMeta = const VerificationMeta(
    'deletedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtLocal =
      GeneratedColumn<DateTime>(
        'deleted_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
    'street',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suiteMeta = const VerificationMeta('suite');
  @override
  late final GeneratedColumn<String> suite = GeneratedColumn<String>(
    'suite',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zipcodeMeta = const VerificationMeta(
    'zipcode',
  );
  @override
  late final GeneratedColumn<String> zipcode = GeneratedColumn<String>(
    'zipcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    updatedAt,
    deletedAt,
    deletedAtLocal,
    id,
    name,
    username,
    email,
    phone,
    website,
    street,
    suite,
    city,
    zipcode,
    companyName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('deleted_at_local')) {
      context.handle(
        _deletedAtLocalMeta,
        deletedAtLocal.isAcceptableOrUnknown(
          data['deleted_at_local']!,
          _deletedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('street')) {
      context.handle(
        _streetMeta,
        street.isAcceptableOrUnknown(data['street']!, _streetMeta),
      );
    }
    if (data.containsKey('suite')) {
      context.handle(
        _suiteMeta,
        suite.isAcceptableOrUnknown(data['suite']!, _suiteMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('zipcode')) {
      context.handle(
        _zipcodeMeta,
        zipcode.isAcceptableOrUnknown(data['zipcode']!, _zipcodeMeta),
      );
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deletedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_local'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      street: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}street'],
      ),
      suite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suite'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      zipcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zipcode'],
      ),
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      ),
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  /// Время последнего обновления (UTC).
  final DateTime updatedAt;

  /// Время удаления на сервере (UTC), null если не удалено.
  final DateTime? deletedAt;

  /// Время локального удаления (UTC), для отложенной очистки.
  final DateTime? deletedAtLocal;
  final String id;
  final String name;
  final String? username;
  final String email;
  final String? phone;
  final String? website;
  final String? street;
  final String? suite;
  final String? city;
  final String? zipcode;
  final String? companyName;
  const Contact({
    required this.updatedAt,
    this.deletedAt,
    this.deletedAtLocal,
    required this.id,
    required this.name,
    this.username,
    required this.email,
    this.phone,
    this.website,
    this.street,
    this.suite,
    this.city,
    this.zipcode,
    this.companyName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedAtLocal != null) {
      map['deleted_at_local'] = Variable<DateTime>(deletedAtLocal);
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || street != null) {
      map['street'] = Variable<String>(street);
    }
    if (!nullToAbsent || suite != null) {
      map['suite'] = Variable<String>(suite);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || zipcode != null) {
      map['zipcode'] = Variable<String>(zipcode);
    }
    if (!nullToAbsent || companyName != null) {
      map['company_name'] = Variable<String>(companyName);
    }
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedAtLocal: deletedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtLocal),
      id: Value(id),
      name: Value(name),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      email: Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      street: street == null && nullToAbsent
          ? const Value.absent()
          : Value(street),
      suite: suite == null && nullToAbsent
          ? const Value.absent()
          : Value(suite),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      zipcode: zipcode == null && nullToAbsent
          ? const Value.absent()
          : Value(zipcode),
      companyName: companyName == null && nullToAbsent
          ? const Value.absent()
          : Value(companyName),
    );
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deletedAtLocal: serializer.fromJson<DateTime?>(json['deletedAtLocal']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      username: serializer.fromJson<String?>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      website: serializer.fromJson<String?>(json['website']),
      street: serializer.fromJson<String?>(json['street']),
      suite: serializer.fromJson<String?>(json['suite']),
      city: serializer.fromJson<String?>(json['city']),
      zipcode: serializer.fromJson<String?>(json['zipcode']),
      companyName: serializer.fromJson<String?>(json['companyName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deletedAtLocal': serializer.toJson<DateTime?>(deletedAtLocal),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'username': serializer.toJson<String?>(username),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String?>(phone),
      'website': serializer.toJson<String?>(website),
      'street': serializer.toJson<String?>(street),
      'suite': serializer.toJson<String?>(suite),
      'city': serializer.toJson<String?>(city),
      'zipcode': serializer.toJson<String?>(zipcode),
      'companyName': serializer.toJson<String?>(companyName),
    };
  }

  Contact copyWith({
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<DateTime?> deletedAtLocal = const Value.absent(),
    String? id,
    String? name,
    Value<String?> username = const Value.absent(),
    String? email,
    Value<String?> phone = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> street = const Value.absent(),
    Value<String?> suite = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> zipcode = const Value.absent(),
    Value<String?> companyName = const Value.absent(),
  }) => Contact(
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deletedAtLocal: deletedAtLocal.present
        ? deletedAtLocal.value
        : this.deletedAtLocal,
    id: id ?? this.id,
    name: name ?? this.name,
    username: username.present ? username.value : this.username,
    email: email ?? this.email,
    phone: phone.present ? phone.value : this.phone,
    website: website.present ? website.value : this.website,
    street: street.present ? street.value : this.street,
    suite: suite.present ? suite.value : this.suite,
    city: city.present ? city.value : this.city,
    zipcode: zipcode.present ? zipcode.value : this.zipcode,
    companyName: companyName.present ? companyName.value : this.companyName,
  );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedAtLocal: data.deletedAtLocal.present
          ? data.deletedAtLocal.value
          : this.deletedAtLocal,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      website: data.website.present ? data.website.value : this.website,
      street: data.street.present ? data.street.value : this.street,
      suite: data.suite.present ? data.suite.value : this.suite,
      city: data.city.present ? data.city.value : this.city,
      zipcode: data.zipcode.present ? data.zipcode.value : this.zipcode,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedAtLocal: $deletedAtLocal, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('street: $street, ')
          ..write('suite: $suite, ')
          ..write('city: $city, ')
          ..write('zipcode: $zipcode, ')
          ..write('companyName: $companyName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    updatedAt,
    deletedAt,
    deletedAtLocal,
    id,
    name,
    username,
    email,
    phone,
    website,
    street,
    suite,
    city,
    zipcode,
    companyName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deletedAtLocal == this.deletedAtLocal &&
          other.id == this.id &&
          other.name == this.name &&
          other.username == this.username &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.website == this.website &&
          other.street == this.street &&
          other.suite == this.suite &&
          other.city == this.city &&
          other.zipcode == this.zipcode &&
          other.companyName == this.companyName);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> deletedAtLocal;
  final Value<String> id;
  final Value<String> name;
  final Value<String?> username;
  final Value<String> email;
  final Value<String?> phone;
  final Value<String?> website;
  final Value<String?> street;
  final Value<String?> suite;
  final Value<String?> city;
  final Value<String?> zipcode;
  final Value<String?> companyName;
  final Value<int> rowid;
  const ContactsCompanion({
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedAtLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.street = const Value.absent(),
    this.suite = const Value.absent(),
    this.city = const Value.absent(),
    this.zipcode = const Value.absent(),
    this.companyName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactsCompanion.insert({
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deletedAtLocal = const Value.absent(),
    required String id,
    required String name,
    this.username = const Value.absent(),
    required String email,
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.street = const Value.absent(),
    this.suite = const Value.absent(),
    this.city = const Value.absent(),
    this.zipcode = const Value.absent(),
    this.companyName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : updatedAt = Value(updatedAt),
       id = Value(id),
       name = Value(name),
       email = Value(email);
  static Insertable<Contact> custom({
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? deletedAtLocal,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? website,
    Expression<String>? street,
    Expression<String>? suite,
    Expression<String>? city,
    Expression<String>? zipcode,
    Expression<String>? companyName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedAtLocal != null) 'deleted_at_local': deletedAtLocal,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (street != null) 'street': street,
      if (suite != null) 'suite': suite,
      if (city != null) 'city': city,
      if (zipcode != null) 'zipcode': zipcode,
      if (companyName != null) 'company_name': companyName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactsCompanion copyWith({
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime?>? deletedAtLocal,
    Value<String>? id,
    Value<String>? name,
    Value<String?>? username,
    Value<String>? email,
    Value<String?>? phone,
    Value<String?>? website,
    Value<String?>? street,
    Value<String?>? suite,
    Value<String?>? city,
    Value<String?>? zipcode,
    Value<String?>? companyName,
    Value<int>? rowid,
  }) {
    return ContactsCompanion(
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedAtLocal: deletedAtLocal ?? this.deletedAtLocal,
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      street: street ?? this.street,
      suite: suite ?? this.suite,
      city: city ?? this.city,
      zipcode: zipcode ?? this.zipcode,
      companyName: companyName ?? this.companyName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedAtLocal.present) {
      map['deleted_at_local'] = Variable<DateTime>(deletedAtLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (suite.present) {
      map['suite'] = Variable<String>(suite.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (zipcode.present) {
      map['zipcode'] = Variable<String>(zipcode.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedAtLocal: $deletedAtLocal, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('street: $street, ')
          ..write('suite: $suite, ')
          ..write('city: $city, ')
          ..write('zipcode: $zipcode, ')
          ..write('companyName: $companyName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduledCallsTable extends ScheduledCalls
    with TableInfo<$ScheduledCallsTable, ScheduledCall> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledCallsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactIdMeta = const VerificationMeta(
    'contactId',
  );
  @override
  late final GeneratedColumn<String> contactId = GeneratedColumn<String>(
    'contact_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactNameMeta = const VerificationMeta(
    'contactName',
  );
  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
    'contact_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _runAtMeta = const VerificationMeta('runAt');
  @override
  late final GeneratedColumn<DateTime> runAt = GeneratedColumn<DateTime>(
    'run_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firedAtMeta = const VerificationMeta(
    'firedAt',
  );
  @override
  late final GeneratedColumn<DateTime> firedAt = GeneratedColumn<DateTime>(
    'fired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    contactId,
    contactName,
    phone,
    runAt,
    reason,
    createdAt,
    firedAt,
    outcome,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_calls';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduledCall> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('contact_id')) {
      context.handle(
        _contactIdMeta,
        contactId.isAcceptableOrUnknown(data['contact_id']!, _contactIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contactIdMeta);
    }
    if (data.containsKey('contact_name')) {
      context.handle(
        _contactNameMeta,
        contactName.isAcceptableOrUnknown(
          data['contact_name']!,
          _contactNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contactNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('run_at')) {
      context.handle(
        _runAtMeta,
        runAt.isAcceptableOrUnknown(data['run_at']!, _runAtMeta),
      );
    } else if (isInserting) {
      context.missing(_runAtMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('fired_at')) {
      context.handle(
        _firedAtMeta,
        firedAt.isAcceptableOrUnknown(data['fired_at']!, _firedAtMeta),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledCall map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledCall(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      contactId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_id'],
      )!,
      contactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      runAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}run_at'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      firedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fired_at'],
      ),
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      ),
    );
  }

  @override
  $ScheduledCallsTable createAlias(String alias) {
    return $ScheduledCallsTable(attachedDatabase, alias);
  }
}

class ScheduledCall extends DataClass implements Insertable<ScheduledCall> {
  final String id;
  final String contactId;
  final String contactName;
  final String? phone;
  final DateTime runAt;
  final String? reason;
  final DateTime createdAt;
  final DateTime? firedAt;

  /// 'placed' | 'cancelled' | 'missed' | null (still upcoming)
  final String? outcome;
  const ScheduledCall({
    required this.id,
    required this.contactId,
    required this.contactName,
    this.phone,
    required this.runAt,
    this.reason,
    required this.createdAt,
    this.firedAt,
    this.outcome,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['contact_id'] = Variable<String>(contactId);
    map['contact_name'] = Variable<String>(contactName);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['run_at'] = Variable<DateTime>(runAt);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || firedAt != null) {
      map['fired_at'] = Variable<DateTime>(firedAt);
    }
    if (!nullToAbsent || outcome != null) {
      map['outcome'] = Variable<String>(outcome);
    }
    return map;
  }

  ScheduledCallsCompanion toCompanion(bool nullToAbsent) {
    return ScheduledCallsCompanion(
      id: Value(id),
      contactId: Value(contactId),
      contactName: Value(contactName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      runAt: Value(runAt),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      createdAt: Value(createdAt),
      firedAt: firedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(firedAt),
      outcome: outcome == null && nullToAbsent
          ? const Value.absent()
          : Value(outcome),
    );
  }

  factory ScheduledCall.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledCall(
      id: serializer.fromJson<String>(json['id']),
      contactId: serializer.fromJson<String>(json['contactId']),
      contactName: serializer.fromJson<String>(json['contactName']),
      phone: serializer.fromJson<String?>(json['phone']),
      runAt: serializer.fromJson<DateTime>(json['runAt']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      firedAt: serializer.fromJson<DateTime?>(json['firedAt']),
      outcome: serializer.fromJson<String?>(json['outcome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'contactId': serializer.toJson<String>(contactId),
      'contactName': serializer.toJson<String>(contactName),
      'phone': serializer.toJson<String?>(phone),
      'runAt': serializer.toJson<DateTime>(runAt),
      'reason': serializer.toJson<String?>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'firedAt': serializer.toJson<DateTime?>(firedAt),
      'outcome': serializer.toJson<String?>(outcome),
    };
  }

  ScheduledCall copyWith({
    String? id,
    String? contactId,
    String? contactName,
    Value<String?> phone = const Value.absent(),
    DateTime? runAt,
    Value<String?> reason = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> firedAt = const Value.absent(),
    Value<String?> outcome = const Value.absent(),
  }) => ScheduledCall(
    id: id ?? this.id,
    contactId: contactId ?? this.contactId,
    contactName: contactName ?? this.contactName,
    phone: phone.present ? phone.value : this.phone,
    runAt: runAt ?? this.runAt,
    reason: reason.present ? reason.value : this.reason,
    createdAt: createdAt ?? this.createdAt,
    firedAt: firedAt.present ? firedAt.value : this.firedAt,
    outcome: outcome.present ? outcome.value : this.outcome,
  );
  ScheduledCall copyWithCompanion(ScheduledCallsCompanion data) {
    return ScheduledCall(
      id: data.id.present ? data.id.value : this.id,
      contactId: data.contactId.present ? data.contactId.value : this.contactId,
      contactName: data.contactName.present
          ? data.contactName.value
          : this.contactName,
      phone: data.phone.present ? data.phone.value : this.phone,
      runAt: data.runAt.present ? data.runAt.value : this.runAt,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      firedAt: data.firedAt.present ? data.firedAt.value : this.firedAt,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledCall(')
          ..write('id: $id, ')
          ..write('contactId: $contactId, ')
          ..write('contactName: $contactName, ')
          ..write('phone: $phone, ')
          ..write('runAt: $runAt, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('firedAt: $firedAt, ')
          ..write('outcome: $outcome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    contactId,
    contactName,
    phone,
    runAt,
    reason,
    createdAt,
    firedAt,
    outcome,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledCall &&
          other.id == this.id &&
          other.contactId == this.contactId &&
          other.contactName == this.contactName &&
          other.phone == this.phone &&
          other.runAt == this.runAt &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt &&
          other.firedAt == this.firedAt &&
          other.outcome == this.outcome);
}

class ScheduledCallsCompanion extends UpdateCompanion<ScheduledCall> {
  final Value<String> id;
  final Value<String> contactId;
  final Value<String> contactName;
  final Value<String?> phone;
  final Value<DateTime> runAt;
  final Value<String?> reason;
  final Value<DateTime> createdAt;
  final Value<DateTime?> firedAt;
  final Value<String?> outcome;
  final Value<int> rowid;
  const ScheduledCallsCompanion({
    this.id = const Value.absent(),
    this.contactId = const Value.absent(),
    this.contactName = const Value.absent(),
    this.phone = const Value.absent(),
    this.runAt = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.firedAt = const Value.absent(),
    this.outcome = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduledCallsCompanion.insert({
    required String id,
    required String contactId,
    required String contactName,
    this.phone = const Value.absent(),
    required DateTime runAt,
    this.reason = const Value.absent(),
    required DateTime createdAt,
    this.firedAt = const Value.absent(),
    this.outcome = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       contactId = Value(contactId),
       contactName = Value(contactName),
       runAt = Value(runAt),
       createdAt = Value(createdAt);
  static Insertable<ScheduledCall> custom({
    Expression<String>? id,
    Expression<String>? contactId,
    Expression<String>? contactName,
    Expression<String>? phone,
    Expression<DateTime>? runAt,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? firedAt,
    Expression<String>? outcome,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contactId != null) 'contact_id': contactId,
      if (contactName != null) 'contact_name': contactName,
      if (phone != null) 'phone': phone,
      if (runAt != null) 'run_at': runAt,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (firedAt != null) 'fired_at': firedAt,
      if (outcome != null) 'outcome': outcome,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduledCallsCompanion copyWith({
    Value<String>? id,
    Value<String>? contactId,
    Value<String>? contactName,
    Value<String?>? phone,
    Value<DateTime>? runAt,
    Value<String?>? reason,
    Value<DateTime>? createdAt,
    Value<DateTime?>? firedAt,
    Value<String?>? outcome,
    Value<int>? rowid,
  }) {
    return ScheduledCallsCompanion(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      runAt: runAt ?? this.runAt,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      firedAt: firedAt ?? this.firedAt,
      outcome: outcome ?? this.outcome,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contactId.present) {
      map['contact_id'] = Variable<String>(contactId.value);
    }
    if (contactName.present) {
      map['contact_name'] = Variable<String>(contactName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (runAt.present) {
      map['run_at'] = Variable<DateTime>(runAt.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (firedAt.present) {
      map['fired_at'] = Variable<DateTime>(firedAt.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledCallsCompanion(')
          ..write('id: $id, ')
          ..write('contactId: $contactId, ')
          ..write('contactName: $contactName, ')
          ..write('phone: $phone, ')
          ..write('runAt: $runAt, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('firedAt: $firedAt, ')
          ..write('outcome: $outcome, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CallLogsTable extends CallLogs with TableInfo<$CallLogsTable, CallLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtLocalMeta = const VerificationMeta(
    'deletedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAtLocal =
      GeneratedColumn<DateTime>(
        'deleted_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactIdMeta = const VerificationMeta(
    'contactId',
  );
  @override
  late final GeneratedColumn<String> contactId = GeneratedColumn<String>(
    'contact_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactNameMeta = const VerificationMeta(
    'contactName',
  );
  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
    'contact_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placedAtMeta = const VerificationMeta(
    'placedAt',
  );
  @override
  late final GeneratedColumn<DateTime> placedAt = GeneratedColumn<DateTime>(
    'placed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    updatedAt,
    deletedAt,
    deletedAtLocal,
    id,
    contactId,
    contactName,
    phone,
    placedAt,
    durationSec,
    notes,
    origin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'call_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CallLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('deleted_at_local')) {
      context.handle(
        _deletedAtLocalMeta,
        deletedAtLocal.isAcceptableOrUnknown(
          data['deleted_at_local']!,
          _deletedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('contact_id')) {
      context.handle(
        _contactIdMeta,
        contactId.isAcceptableOrUnknown(data['contact_id']!, _contactIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contactIdMeta);
    }
    if (data.containsKey('contact_name')) {
      context.handle(
        _contactNameMeta,
        contactName.isAcceptableOrUnknown(
          data['contact_name']!,
          _contactNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contactNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('placed_at')) {
      context.handle(
        _placedAtMeta,
        placedAt.isAcceptableOrUnknown(data['placed_at']!, _placedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_placedAtMeta);
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CallLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallLog(
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deletedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at_local'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      contactId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_id'],
      )!,
      contactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      placedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}placed_at'],
      )!,
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
    );
  }

  @override
  $CallLogsTable createAlias(String alias) {
    return $CallLogsTable(attachedDatabase, alias);
  }
}

class CallLog extends DataClass implements Insertable<CallLog> {
  /// Время последнего обновления (UTC).
  final DateTime updatedAt;

  /// Время удаления на сервере (UTC), null если не удалено.
  final DateTime? deletedAt;

  /// Время локального удаления (UTC), для отложенной очистки.
  final DateTime? deletedAtLocal;
  final String id;
  final String contactId;
  final String contactName;
  final String? phone;
  final DateTime placedAt;
  final int durationSec;
  final String? notes;

  /// 'manual' (Quick Dial) | 'scheduled' (fired by the auto_call timer)
  final String origin;
  const CallLog({
    required this.updatedAt,
    this.deletedAt,
    this.deletedAtLocal,
    required this.id,
    required this.contactId,
    required this.contactName,
    this.phone,
    required this.placedAt,
    required this.durationSec,
    this.notes,
    required this.origin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedAtLocal != null) {
      map['deleted_at_local'] = Variable<DateTime>(deletedAtLocal);
    }
    map['id'] = Variable<String>(id);
    map['contact_id'] = Variable<String>(contactId);
    map['contact_name'] = Variable<String>(contactName);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['placed_at'] = Variable<DateTime>(placedAt);
    map['duration_sec'] = Variable<int>(durationSec);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['origin'] = Variable<String>(origin);
    return map;
  }

  CallLogsCompanion toCompanion(bool nullToAbsent) {
    return CallLogsCompanion(
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedAtLocal: deletedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtLocal),
      id: Value(id),
      contactId: Value(contactId),
      contactName: Value(contactName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      placedAt: Value(placedAt),
      durationSec: Value(durationSec),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      origin: Value(origin),
    );
  }

  factory CallLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallLog(
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deletedAtLocal: serializer.fromJson<DateTime?>(json['deletedAtLocal']),
      id: serializer.fromJson<String>(json['id']),
      contactId: serializer.fromJson<String>(json['contactId']),
      contactName: serializer.fromJson<String>(json['contactName']),
      phone: serializer.fromJson<String?>(json['phone']),
      placedAt: serializer.fromJson<DateTime>(json['placedAt']),
      durationSec: serializer.fromJson<int>(json['durationSec']),
      notes: serializer.fromJson<String?>(json['notes']),
      origin: serializer.fromJson<String>(json['origin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deletedAtLocal': serializer.toJson<DateTime?>(deletedAtLocal),
      'id': serializer.toJson<String>(id),
      'contactId': serializer.toJson<String>(contactId),
      'contactName': serializer.toJson<String>(contactName),
      'phone': serializer.toJson<String?>(phone),
      'placedAt': serializer.toJson<DateTime>(placedAt),
      'durationSec': serializer.toJson<int>(durationSec),
      'notes': serializer.toJson<String?>(notes),
      'origin': serializer.toJson<String>(origin),
    };
  }

  CallLog copyWith({
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<DateTime?> deletedAtLocal = const Value.absent(),
    String? id,
    String? contactId,
    String? contactName,
    Value<String?> phone = const Value.absent(),
    DateTime? placedAt,
    int? durationSec,
    Value<String?> notes = const Value.absent(),
    String? origin,
  }) => CallLog(
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deletedAtLocal: deletedAtLocal.present
        ? deletedAtLocal.value
        : this.deletedAtLocal,
    id: id ?? this.id,
    contactId: contactId ?? this.contactId,
    contactName: contactName ?? this.contactName,
    phone: phone.present ? phone.value : this.phone,
    placedAt: placedAt ?? this.placedAt,
    durationSec: durationSec ?? this.durationSec,
    notes: notes.present ? notes.value : this.notes,
    origin: origin ?? this.origin,
  );
  CallLog copyWithCompanion(CallLogsCompanion data) {
    return CallLog(
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedAtLocal: data.deletedAtLocal.present
          ? data.deletedAtLocal.value
          : this.deletedAtLocal,
      id: data.id.present ? data.id.value : this.id,
      contactId: data.contactId.present ? data.contactId.value : this.contactId,
      contactName: data.contactName.present
          ? data.contactName.value
          : this.contactName,
      phone: data.phone.present ? data.phone.value : this.phone,
      placedAt: data.placedAt.present ? data.placedAt.value : this.placedAt,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      notes: data.notes.present ? data.notes.value : this.notes,
      origin: data.origin.present ? data.origin.value : this.origin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CallLog(')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedAtLocal: $deletedAtLocal, ')
          ..write('id: $id, ')
          ..write('contactId: $contactId, ')
          ..write('contactName: $contactName, ')
          ..write('phone: $phone, ')
          ..write('placedAt: $placedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('notes: $notes, ')
          ..write('origin: $origin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    updatedAt,
    deletedAt,
    deletedAtLocal,
    id,
    contactId,
    contactName,
    phone,
    placedAt,
    durationSec,
    notes,
    origin,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallLog &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deletedAtLocal == this.deletedAtLocal &&
          other.id == this.id &&
          other.contactId == this.contactId &&
          other.contactName == this.contactName &&
          other.phone == this.phone &&
          other.placedAt == this.placedAt &&
          other.durationSec == this.durationSec &&
          other.notes == this.notes &&
          other.origin == this.origin);
}

class CallLogsCompanion extends UpdateCompanion<CallLog> {
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> deletedAtLocal;
  final Value<String> id;
  final Value<String> contactId;
  final Value<String> contactName;
  final Value<String?> phone;
  final Value<DateTime> placedAt;
  final Value<int> durationSec;
  final Value<String?> notes;
  final Value<String> origin;
  final Value<int> rowid;
  const CallLogsCompanion({
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedAtLocal = const Value.absent(),
    this.id = const Value.absent(),
    this.contactId = const Value.absent(),
    this.contactName = const Value.absent(),
    this.phone = const Value.absent(),
    this.placedAt = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.notes = const Value.absent(),
    this.origin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CallLogsCompanion.insert({
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deletedAtLocal = const Value.absent(),
    required String id,
    required String contactId,
    required String contactName,
    this.phone = const Value.absent(),
    required DateTime placedAt,
    this.durationSec = const Value.absent(),
    this.notes = const Value.absent(),
    this.origin = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : updatedAt = Value(updatedAt),
       id = Value(id),
       contactId = Value(contactId),
       contactName = Value(contactName),
       placedAt = Value(placedAt);
  static Insertable<CallLog> custom({
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? deletedAtLocal,
    Expression<String>? id,
    Expression<String>? contactId,
    Expression<String>? contactName,
    Expression<String>? phone,
    Expression<DateTime>? placedAt,
    Expression<int>? durationSec,
    Expression<String>? notes,
    Expression<String>? origin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedAtLocal != null) 'deleted_at_local': deletedAtLocal,
      if (id != null) 'id': id,
      if (contactId != null) 'contact_id': contactId,
      if (contactName != null) 'contact_name': contactName,
      if (phone != null) 'phone': phone,
      if (placedAt != null) 'placed_at': placedAt,
      if (durationSec != null) 'duration_sec': durationSec,
      if (notes != null) 'notes': notes,
      if (origin != null) 'origin': origin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CallLogsCompanion copyWith({
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime?>? deletedAtLocal,
    Value<String>? id,
    Value<String>? contactId,
    Value<String>? contactName,
    Value<String?>? phone,
    Value<DateTime>? placedAt,
    Value<int>? durationSec,
    Value<String?>? notes,
    Value<String>? origin,
    Value<int>? rowid,
  }) {
    return CallLogsCompanion(
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedAtLocal: deletedAtLocal ?? this.deletedAtLocal,
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      placedAt: placedAt ?? this.placedAt,
      durationSec: durationSec ?? this.durationSec,
      notes: notes ?? this.notes,
      origin: origin ?? this.origin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedAtLocal.present) {
      map['deleted_at_local'] = Variable<DateTime>(deletedAtLocal.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contactId.present) {
      map['contact_id'] = Variable<String>(contactId.value);
    }
    if (contactName.present) {
      map['contact_name'] = Variable<String>(contactName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (placedAt.present) {
      map['placed_at'] = Variable<DateTime>(placedAt.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallLogsCompanion(')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedAtLocal: $deletedAtLocal, ')
          ..write('id: $id, ')
          ..write('contactId: $contactId, ')
          ..write('contactName: $contactName, ')
          ..write('phone: $phone, ')
          ..write('placedAt: $placedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('notes: $notes, ')
          ..write('origin: $origin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncCursorsTable syncCursors = $SyncCursorsTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $ScheduledCallsTable scheduledCalls = $ScheduledCallsTable(this);
  late final $CallLogsTable callLogs = $CallLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    syncCursors,
    syncOutbox,
    contacts,
    scheduledCalls,
    callLogs,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$SyncCursorsTableCreateCompanionBuilder =
    SyncCursorsCompanion Function({
      required String kind,
      required int ts,
      required String lastId,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableUpdateCompanionBuilder =
    SyncCursorsCompanion Function({
      Value<String> kind,
      Value<int> ts,
      Value<String> lastId,
      Value<int> rowid,
    });

class $$SyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastId => $composableBuilder(
    column: $table.lastId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastId => $composableBuilder(
    column: $table.lastId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumn<String> get lastId =>
      $composableBuilder(column: $table.lastId, builder: (column) => column);
}

class $$SyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCursorsTable,
          SyncCursorData,
          $$SyncCursorsTableFilterComposer,
          $$SyncCursorsTableOrderingComposer,
          $$SyncCursorsTableAnnotationComposer,
          $$SyncCursorsTableCreateCompanionBuilder,
          $$SyncCursorsTableUpdateCompanionBuilder,
          (
            SyncCursorData,
            BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursorData>,
          ),
          SyncCursorData,
          PrefetchHooks Function()
        > {
  $$SyncCursorsTableTableManager(_$AppDatabase db, $SyncCursorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> kind = const Value.absent(),
                Value<int> ts = const Value.absent(),
                Value<String> lastId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion(
                kind: kind,
                ts: ts,
                lastId: lastId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String kind,
                required int ts,
                required String lastId,
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion.insert(
                kind: kind,
                ts: ts,
                lastId: lastId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCursorsTable,
      SyncCursorData,
      $$SyncCursorsTableFilterComposer,
      $$SyncCursorsTableOrderingComposer,
      $$SyncCursorsTableAnnotationComposer,
      $$SyncCursorsTableCreateCompanionBuilder,
      $$SyncCursorsTableUpdateCompanionBuilder,
      (
        SyncCursorData,
        BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursorData>,
      ),
      SyncCursorData,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String opId,
      required String kind,
      required String entityId,
      required String op,
      Value<String?> payload,
      required int ts,
      Value<int> tryCount,
      Value<int?> baseUpdatedAt,
      Value<String?> changedFields,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> opId,
      Value<String> kind,
      Value<String> entityId,
      Value<String> op,
      Value<String?> payload,
      Value<int> ts,
      Value<int> tryCount,
      Value<int?> baseUpdatedAt,
      Value<String?> changedFields,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tryCount => $composableBuilder(
    column: $table.tryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseUpdatedAt => $composableBuilder(
    column: $table.baseUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changedFields => $composableBuilder(
    column: $table.changedFields,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tryCount => $composableBuilder(
    column: $table.tryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseUpdatedAt => $composableBuilder(
    column: $table.baseUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changedFields => $composableBuilder(
    column: $table.changedFields,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opId =>
      $composableBuilder(column: $table.opId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumn<int> get tryCount =>
      $composableBuilder(column: $table.tryCount, builder: (column) => column);

  GeneratedColumn<int> get baseUpdatedAt => $composableBuilder(
    column: $table.baseUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get changedFields => $composableBuilder(
    column: $table.changedFields,
    builder: (column) => column,
  );
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxData,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxData,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
          ),
          SyncOutboxData,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> opId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<int> ts = const Value.absent(),
                Value<int> tryCount = const Value.absent(),
                Value<int?> baseUpdatedAt = const Value.absent(),
                Value<String?> changedFields = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                opId: opId,
                kind: kind,
                entityId: entityId,
                op: op,
                payload: payload,
                ts: ts,
                tryCount: tryCount,
                baseUpdatedAt: baseUpdatedAt,
                changedFields: changedFields,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opId,
                required String kind,
                required String entityId,
                required String op,
                Value<String?> payload = const Value.absent(),
                required int ts,
                Value<int> tryCount = const Value.absent(),
                Value<int?> baseUpdatedAt = const Value.absent(),
                Value<String?> changedFields = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                opId: opId,
                kind: kind,
                entityId: entityId,
                op: op,
                payload: payload,
                ts: ts,
                tryCount: tryCount,
                baseUpdatedAt: baseUpdatedAt,
                changedFields: changedFields,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxData,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxData,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
      ),
      SyncOutboxData,
      PrefetchHooks Function()
    >;
typedef $$ContactsTableCreateCompanionBuilder =
    ContactsCompanion Function({
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime?> deletedAtLocal,
      required String id,
      required String name,
      Value<String?> username,
      required String email,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> street,
      Value<String?> suite,
      Value<String?> city,
      Value<String?> zipcode,
      Value<String?> companyName,
      Value<int> rowid,
    });
typedef $$ContactsTableUpdateCompanionBuilder =
    ContactsCompanion Function({
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime?> deletedAtLocal,
      Value<String> id,
      Value<String> name,
      Value<String?> username,
      Value<String> email,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> street,
      Value<String?> suite,
      Value<String?> city,
      Value<String?> zipcode,
      Value<String?> companyName,
      Value<int> rowid,
    });

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtLocal => $composableBuilder(
    column: $table.deletedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suite => $composableBuilder(
    column: $table.suite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zipcode => $composableBuilder(
    column: $table.zipcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtLocal => $composableBuilder(
    column: $table.deletedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suite => $composableBuilder(
    column: $table.suite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zipcode => $composableBuilder(
    column: $table.zipcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtLocal => $composableBuilder(
    column: $table.deletedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get street =>
      $composableBuilder(column: $table.street, builder: (column) => column);

  GeneratedColumn<String> get suite =>
      $composableBuilder(column: $table.suite, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get zipcode =>
      $composableBuilder(column: $table.zipcode, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
          Contact,
          PrefetchHooks Function()
        > {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime?> deletedAtLocal = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> suite = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> zipcode = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion(
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deletedAtLocal: deletedAtLocal,
                id: id,
                name: name,
                username: username,
                email: email,
                phone: phone,
                website: website,
                street: street,
                suite: suite,
                city: city,
                zipcode: zipcode,
                companyName: companyName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime?> deletedAtLocal = const Value.absent(),
                required String id,
                required String name,
                Value<String?> username = const Value.absent(),
                required String email,
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> suite = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> zipcode = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion.insert(
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deletedAtLocal: deletedAtLocal,
                id: id,
                name: name,
                username: username,
                email: email,
                phone: phone,
                website: website,
                street: street,
                suite: suite,
                city: city,
                zipcode: zipcode,
                companyName: companyName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
      Contact,
      PrefetchHooks Function()
    >;
typedef $$ScheduledCallsTableCreateCompanionBuilder =
    ScheduledCallsCompanion Function({
      required String id,
      required String contactId,
      required String contactName,
      Value<String?> phone,
      required DateTime runAt,
      Value<String?> reason,
      required DateTime createdAt,
      Value<DateTime?> firedAt,
      Value<String?> outcome,
      Value<int> rowid,
    });
typedef $$ScheduledCallsTableUpdateCompanionBuilder =
    ScheduledCallsCompanion Function({
      Value<String> id,
      Value<String> contactId,
      Value<String> contactName,
      Value<String?> phone,
      Value<DateTime> runAt,
      Value<String?> reason,
      Value<DateTime> createdAt,
      Value<DateTime?> firedAt,
      Value<String?> outcome,
      Value<int> rowid,
    });

class $$ScheduledCallsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledCallsTable> {
  $$ScheduledCallsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactId => $composableBuilder(
    column: $table.contactId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get runAt => $composableBuilder(
    column: $table.runAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firedAt => $composableBuilder(
    column: $table.firedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScheduledCallsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledCallsTable> {
  $$ScheduledCallsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactId => $composableBuilder(
    column: $table.contactId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get runAt => $composableBuilder(
    column: $table.runAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firedAt => $composableBuilder(
    column: $table.firedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduledCallsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledCallsTable> {
  $$ScheduledCallsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contactId =>
      $composableBuilder(column: $table.contactId, builder: (column) => column);

  GeneratedColumn<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get runAt =>
      $composableBuilder(column: $table.runAt, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get firedAt =>
      $composableBuilder(column: $table.firedAt, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);
}

class $$ScheduledCallsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduledCallsTable,
          ScheduledCall,
          $$ScheduledCallsTableFilterComposer,
          $$ScheduledCallsTableOrderingComposer,
          $$ScheduledCallsTableAnnotationComposer,
          $$ScheduledCallsTableCreateCompanionBuilder,
          $$ScheduledCallsTableUpdateCompanionBuilder,
          (
            ScheduledCall,
            BaseReferences<_$AppDatabase, $ScheduledCallsTable, ScheduledCall>,
          ),
          ScheduledCall,
          PrefetchHooks Function()
        > {
  $$ScheduledCallsTableTableManager(
    _$AppDatabase db,
    $ScheduledCallsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledCallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledCallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduledCallsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> contactId = const Value.absent(),
                Value<String> contactName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<DateTime> runAt = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> firedAt = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduledCallsCompanion(
                id: id,
                contactId: contactId,
                contactName: contactName,
                phone: phone,
                runAt: runAt,
                reason: reason,
                createdAt: createdAt,
                firedAt: firedAt,
                outcome: outcome,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String contactId,
                required String contactName,
                Value<String?> phone = const Value.absent(),
                required DateTime runAt,
                Value<String?> reason = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> firedAt = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduledCallsCompanion.insert(
                id: id,
                contactId: contactId,
                contactName: contactName,
                phone: phone,
                runAt: runAt,
                reason: reason,
                createdAt: createdAt,
                firedAt: firedAt,
                outcome: outcome,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScheduledCallsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduledCallsTable,
      ScheduledCall,
      $$ScheduledCallsTableFilterComposer,
      $$ScheduledCallsTableOrderingComposer,
      $$ScheduledCallsTableAnnotationComposer,
      $$ScheduledCallsTableCreateCompanionBuilder,
      $$ScheduledCallsTableUpdateCompanionBuilder,
      (
        ScheduledCall,
        BaseReferences<_$AppDatabase, $ScheduledCallsTable, ScheduledCall>,
      ),
      ScheduledCall,
      PrefetchHooks Function()
    >;
typedef $$CallLogsTableCreateCompanionBuilder =
    CallLogsCompanion Function({
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime?> deletedAtLocal,
      required String id,
      required String contactId,
      required String contactName,
      Value<String?> phone,
      required DateTime placedAt,
      Value<int> durationSec,
      Value<String?> notes,
      Value<String> origin,
      Value<int> rowid,
    });
typedef $$CallLogsTableUpdateCompanionBuilder =
    CallLogsCompanion Function({
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime?> deletedAtLocal,
      Value<String> id,
      Value<String> contactId,
      Value<String> contactName,
      Value<String?> phone,
      Value<DateTime> placedAt,
      Value<int> durationSec,
      Value<String?> notes,
      Value<String> origin,
      Value<int> rowid,
    });

class $$CallLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CallLogsTable> {
  $$CallLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAtLocal => $composableBuilder(
    column: $table.deletedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactId => $composableBuilder(
    column: $table.contactId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get placedAt => $composableBuilder(
    column: $table.placedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CallLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CallLogsTable> {
  $$CallLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAtLocal => $composableBuilder(
    column: $table.deletedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactId => $composableBuilder(
    column: $table.contactId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get placedAt => $composableBuilder(
    column: $table.placedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CallLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CallLogsTable> {
  $$CallLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtLocal => $composableBuilder(
    column: $table.deletedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contactId =>
      $composableBuilder(column: $table.contactId, builder: (column) => column);

  GeneratedColumn<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get placedAt =>
      $composableBuilder(column: $table.placedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);
}

class $$CallLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CallLogsTable,
          CallLog,
          $$CallLogsTableFilterComposer,
          $$CallLogsTableOrderingComposer,
          $$CallLogsTableAnnotationComposer,
          $$CallLogsTableCreateCompanionBuilder,
          $$CallLogsTableUpdateCompanionBuilder,
          (CallLog, BaseReferences<_$AppDatabase, $CallLogsTable, CallLog>),
          CallLog,
          PrefetchHooks Function()
        > {
  $$CallLogsTableTableManager(_$AppDatabase db, $CallLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime?> deletedAtLocal = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> contactId = const Value.absent(),
                Value<String> contactName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<DateTime> placedAt = const Value.absent(),
                Value<int> durationSec = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CallLogsCompanion(
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deletedAtLocal: deletedAtLocal,
                id: id,
                contactId: contactId,
                contactName: contactName,
                phone: phone,
                placedAt: placedAt,
                durationSec: durationSec,
                notes: notes,
                origin: origin,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime?> deletedAtLocal = const Value.absent(),
                required String id,
                required String contactId,
                required String contactName,
                Value<String?> phone = const Value.absent(),
                required DateTime placedAt,
                Value<int> durationSec = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CallLogsCompanion.insert(
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deletedAtLocal: deletedAtLocal,
                id: id,
                contactId: contactId,
                contactName: contactName,
                phone: phone,
                placedAt: placedAt,
                durationSec: durationSec,
                notes: notes,
                origin: origin,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CallLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CallLogsTable,
      CallLog,
      $$CallLogsTableFilterComposer,
      $$CallLogsTableOrderingComposer,
      $$CallLogsTableAnnotationComposer,
      $$CallLogsTableCreateCompanionBuilder,
      $$CallLogsTableUpdateCompanionBuilder,
      (CallLog, BaseReferences<_$AppDatabase, $CallLogsTable, CallLog>),
      CallLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncCursorsTableTableManager get syncCursors =>
      $$SyncCursorsTableTableManager(_db, _db.syncCursors);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$ScheduledCallsTableTableManager get scheduledCalls =>
      $$ScheduledCallsTableTableManager(_db, _db.scheduledCalls);
  $$CallLogsTableTableManager get callLogs =>
      $$CallLogsTableTableManager(_db, _db.callLogs);
}
