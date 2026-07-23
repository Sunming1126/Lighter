// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FastingPlansTable extends FastingPlans
    with TableInfo<$FastingPlansTable, FastingPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FastingPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fastMinutesMeta = const VerificationMeta(
    'fastMinutes',
  );
  @override
  late final GeneratedColumn<int> fastMinutes = GeneratedColumn<int>(
    'fast_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(720),
  );
  static const VerificationMeta _eatingMinutesMeta = const VerificationMeta(
    'eatingMinutes',
  );
  @override
  late final GeneratedColumn<int> eatingMinutes = GeneratedColumn<int>(
    'eating_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(720),
  );
  static const VerificationMeta _startMinuteOfDayMeta = const VerificationMeta(
    'startMinuteOfDay',
  );
  @override
  late final GeneratedColumn<int> startMinuteOfDay = GeneratedColumn<int>(
    'start_minute_of_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1200),
  );
  static const VerificationMeta _timezoneNameMeta = const VerificationMeta(
    'timezoneName',
  );
  @override
  late final GeneratedColumn<String> timezoneName = GeneratedColumn<String>(
    'timezone_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _pausedMeta = const VerificationMeta('paused');
  @override
  late final GeneratedColumn<bool> paused = GeneratedColumn<bool>(
    'paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMsMeta = const VerificationMeta(
    'deletedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtcMs = GeneratedColumn<int>(
    'deleted_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fastMinutes,
    eatingMinutes,
    startMinuteOfDay,
    timezoneName,
    active,
    paused,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fasting_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<FastingPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('fast_minutes')) {
      context.handle(
        _fastMinutesMeta,
        fastMinutes.isAcceptableOrUnknown(
          data['fast_minutes']!,
          _fastMinutesMeta,
        ),
      );
    }
    if (data.containsKey('eating_minutes')) {
      context.handle(
        _eatingMinutesMeta,
        eatingMinutes.isAcceptableOrUnknown(
          data['eating_minutes']!,
          _eatingMinutesMeta,
        ),
      );
    }
    if (data.containsKey('start_minute_of_day')) {
      context.handle(
        _startMinuteOfDayMeta,
        startMinuteOfDay.isAcceptableOrUnknown(
          data['start_minute_of_day']!,
          _startMinuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('timezone_name')) {
      context.handle(
        _timezoneNameMeta,
        timezoneName.isAcceptableOrUnknown(
          data['timezone_name']!,
          _timezoneNameMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('paused')) {
      context.handle(
        _pausedMeta,
        paused.isAcceptableOrUnknown(data['paused']!, _pausedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    if (data.containsKey('deleted_at_utc_ms')) {
      context.handle(
        _deletedAtUtcMsMeta,
        deletedAtUtcMs.isAcceptableOrUnknown(
          data['deleted_at_utc_ms']!,
          _deletedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FastingPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FastingPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fastMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fast_minutes'],
      )!,
      eatingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eating_minutes'],
      )!,
      startMinuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute_of_day'],
      )!,
      timezoneName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone_name'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      paused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paused'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
      deletedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc_ms'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $FastingPlansTable createAlias(String alias) {
    return $FastingPlansTable(attachedDatabase, alias);
  }
}

class FastingPlan extends DataClass implements Insertable<FastingPlan> {
  final String id;
  final int fastMinutes;
  final int eatingMinutes;
  final int startMinuteOfDay;
  final String timezoneName;
  final bool active;
  final bool paused;
  final int revision;
  final int updatedAtUtcMs;
  final int? deletedAtUtcMs;
  final String syncStatus;
  const FastingPlan({
    required this.id,
    required this.fastMinutes,
    required this.eatingMinutes,
    required this.startMinuteOfDay,
    required this.timezoneName,
    required this.active,
    required this.paused,
    required this.revision,
    required this.updatedAtUtcMs,
    this.deletedAtUtcMs,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['fast_minutes'] = Variable<int>(fastMinutes);
    map['eating_minutes'] = Variable<int>(eatingMinutes);
    map['start_minute_of_day'] = Variable<int>(startMinuteOfDay);
    map['timezone_name'] = Variable<String>(timezoneName);
    map['active'] = Variable<bool>(active);
    map['paused'] = Variable<bool>(paused);
    map['revision'] = Variable<int>(revision);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    if (!nullToAbsent || deletedAtUtcMs != null) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  FastingPlansCompanion toCompanion(bool nullToAbsent) {
    return FastingPlansCompanion(
      id: Value(id),
      fastMinutes: Value(fastMinutes),
      eatingMinutes: Value(eatingMinutes),
      startMinuteOfDay: Value(startMinuteOfDay),
      timezoneName: Value(timezoneName),
      active: Value(active),
      paused: Value(paused),
      revision: Value(revision),
      updatedAtUtcMs: Value(updatedAtUtcMs),
      deletedAtUtcMs: deletedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtcMs),
      syncStatus: Value(syncStatus),
    );
  }

  factory FastingPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FastingPlan(
      id: serializer.fromJson<String>(json['id']),
      fastMinutes: serializer.fromJson<int>(json['fastMinutes']),
      eatingMinutes: serializer.fromJson<int>(json['eatingMinutes']),
      startMinuteOfDay: serializer.fromJson<int>(json['startMinuteOfDay']),
      timezoneName: serializer.fromJson<String>(json['timezoneName']),
      active: serializer.fromJson<bool>(json['active']),
      paused: serializer.fromJson<bool>(json['paused']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
      deletedAtUtcMs: serializer.fromJson<int?>(json['deletedAtUtcMs']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fastMinutes': serializer.toJson<int>(fastMinutes),
      'eatingMinutes': serializer.toJson<int>(eatingMinutes),
      'startMinuteOfDay': serializer.toJson<int>(startMinuteOfDay),
      'timezoneName': serializer.toJson<String>(timezoneName),
      'active': serializer.toJson<bool>(active),
      'paused': serializer.toJson<bool>(paused),
      'revision': serializer.toJson<int>(revision),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
      'deletedAtUtcMs': serializer.toJson<int?>(deletedAtUtcMs),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  FastingPlan copyWith({
    String? id,
    int? fastMinutes,
    int? eatingMinutes,
    int? startMinuteOfDay,
    String? timezoneName,
    bool? active,
    bool? paused,
    int? revision,
    int? updatedAtUtcMs,
    Value<int?> deletedAtUtcMs = const Value.absent(),
    String? syncStatus,
  }) => FastingPlan(
    id: id ?? this.id,
    fastMinutes: fastMinutes ?? this.fastMinutes,
    eatingMinutes: eatingMinutes ?? this.eatingMinutes,
    startMinuteOfDay: startMinuteOfDay ?? this.startMinuteOfDay,
    timezoneName: timezoneName ?? this.timezoneName,
    active: active ?? this.active,
    paused: paused ?? this.paused,
    revision: revision ?? this.revision,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
    deletedAtUtcMs: deletedAtUtcMs.present
        ? deletedAtUtcMs.value
        : this.deletedAtUtcMs,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  FastingPlan copyWithCompanion(FastingPlansCompanion data) {
    return FastingPlan(
      id: data.id.present ? data.id.value : this.id,
      fastMinutes: data.fastMinutes.present
          ? data.fastMinutes.value
          : this.fastMinutes,
      eatingMinutes: data.eatingMinutes.present
          ? data.eatingMinutes.value
          : this.eatingMinutes,
      startMinuteOfDay: data.startMinuteOfDay.present
          ? data.startMinuteOfDay.value
          : this.startMinuteOfDay,
      timezoneName: data.timezoneName.present
          ? data.timezoneName.value
          : this.timezoneName,
      active: data.active.present ? data.active.value : this.active,
      paused: data.paused.present ? data.paused.value : this.paused,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
      deletedAtUtcMs: data.deletedAtUtcMs.present
          ? data.deletedAtUtcMs.value
          : this.deletedAtUtcMs,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FastingPlan(')
          ..write('id: $id, ')
          ..write('fastMinutes: $fastMinutes, ')
          ..write('eatingMinutes: $eatingMinutes, ')
          ..write('startMinuteOfDay: $startMinuteOfDay, ')
          ..write('timezoneName: $timezoneName, ')
          ..write('active: $active, ')
          ..write('paused: $paused, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fastMinutes,
    eatingMinutes,
    startMinuteOfDay,
    timezoneName,
    active,
    paused,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FastingPlan &&
          other.id == this.id &&
          other.fastMinutes == this.fastMinutes &&
          other.eatingMinutes == this.eatingMinutes &&
          other.startMinuteOfDay == this.startMinuteOfDay &&
          other.timezoneName == this.timezoneName &&
          other.active == this.active &&
          other.paused == this.paused &&
          other.revision == this.revision &&
          other.updatedAtUtcMs == this.updatedAtUtcMs &&
          other.deletedAtUtcMs == this.deletedAtUtcMs &&
          other.syncStatus == this.syncStatus);
}

class FastingPlansCompanion extends UpdateCompanion<FastingPlan> {
  final Value<String> id;
  final Value<int> fastMinutes;
  final Value<int> eatingMinutes;
  final Value<int> startMinuteOfDay;
  final Value<String> timezoneName;
  final Value<bool> active;
  final Value<bool> paused;
  final Value<int> revision;
  final Value<int> updatedAtUtcMs;
  final Value<int?> deletedAtUtcMs;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const FastingPlansCompanion({
    this.id = const Value.absent(),
    this.fastMinutes = const Value.absent(),
    this.eatingMinutes = const Value.absent(),
    this.startMinuteOfDay = const Value.absent(),
    this.timezoneName = const Value.absent(),
    this.active = const Value.absent(),
    this.paused = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FastingPlansCompanion.insert({
    required String id,
    this.fastMinutes = const Value.absent(),
    this.eatingMinutes = const Value.absent(),
    this.startMinuteOfDay = const Value.absent(),
    this.timezoneName = const Value.absent(),
    this.active = const Value.absent(),
    this.paused = const Value.absent(),
    this.revision = const Value.absent(),
    required int updatedAtUtcMs,
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<FastingPlan> custom({
    Expression<String>? id,
    Expression<int>? fastMinutes,
    Expression<int>? eatingMinutes,
    Expression<int>? startMinuteOfDay,
    Expression<String>? timezoneName,
    Expression<bool>? active,
    Expression<bool>? paused,
    Expression<int>? revision,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? deletedAtUtcMs,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fastMinutes != null) 'fast_minutes': fastMinutes,
      if (eatingMinutes != null) 'eating_minutes': eatingMinutes,
      if (startMinuteOfDay != null) 'start_minute_of_day': startMinuteOfDay,
      if (timezoneName != null) 'timezone_name': timezoneName,
      if (active != null) 'active': active,
      if (paused != null) 'paused': paused,
      if (revision != null) 'revision': revision,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (deletedAtUtcMs != null) 'deleted_at_utc_ms': deletedAtUtcMs,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FastingPlansCompanion copyWith({
    Value<String>? id,
    Value<int>? fastMinutes,
    Value<int>? eatingMinutes,
    Value<int>? startMinuteOfDay,
    Value<String>? timezoneName,
    Value<bool>? active,
    Value<bool>? paused,
    Value<int>? revision,
    Value<int>? updatedAtUtcMs,
    Value<int?>? deletedAtUtcMs,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return FastingPlansCompanion(
      id: id ?? this.id,
      fastMinutes: fastMinutes ?? this.fastMinutes,
      eatingMinutes: eatingMinutes ?? this.eatingMinutes,
      startMinuteOfDay: startMinuteOfDay ?? this.startMinuteOfDay,
      timezoneName: timezoneName ?? this.timezoneName,
      active: active ?? this.active,
      paused: paused ?? this.paused,
      revision: revision ?? this.revision,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      deletedAtUtcMs: deletedAtUtcMs ?? this.deletedAtUtcMs,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fastMinutes.present) {
      map['fast_minutes'] = Variable<int>(fastMinutes.value);
    }
    if (eatingMinutes.present) {
      map['eating_minutes'] = Variable<int>(eatingMinutes.value);
    }
    if (startMinuteOfDay.present) {
      map['start_minute_of_day'] = Variable<int>(startMinuteOfDay.value);
    }
    if (timezoneName.present) {
      map['timezone_name'] = Variable<String>(timezoneName.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (paused.present) {
      map['paused'] = Variable<bool>(paused.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (deletedAtUtcMs.present) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FastingPlansCompanion(')
          ..write('id: $id, ')
          ..write('fastMinutes: $fastMinutes, ')
          ..write('eatingMinutes: $eatingMinutes, ')
          ..write('startMinuteOfDay: $startMinuteOfDay, ')
          ..write('timezoneName: $timezoneName, ')
          ..write('active: $active, ')
          ..write('paused: $paused, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FastingSessionsTable extends FastingSessions
    with TableInfo<$FastingSessionsTable, FastingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FastingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtUtcMsMeta = const VerificationMeta(
    'startedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> startedAtUtcMs = GeneratedColumn<int>(
    'started_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMinutesMeta = const VerificationMeta(
    'targetMinutes',
  );
  @override
  late final GeneratedColumn<int> targetMinutes = GeneratedColumn<int>(
    'target_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timezoneNameMeta = const VerificationMeta(
    'timezoneName',
  );
  @override
  late final GeneratedColumn<String> timezoneName = GeneratedColumn<String>(
    'timezone_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
  );
  static const VerificationMeta _endedAtUtcMsMeta = const VerificationMeta(
    'endedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> endedAtUtcMs = GeneratedColumn<int>(
    'ended_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endReasonMeta = const VerificationMeta(
    'endReason',
  );
  @override
  late final GeneratedColumn<String> endReason = GeneratedColumn<String>(
    'end_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _symptomsJsonMeta = const VerificationMeta(
    'symptomsJson',
  );
  @override
  late final GeneratedColumn<String> symptomsJson = GeneratedColumn<String>(
    'symptoms_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMsMeta = const VerificationMeta(
    'deletedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtcMs = GeneratedColumn<int>(
    'deleted_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    startedAtUtcMs,
    targetMinutes,
    timezoneName,
    endedAtUtcMs,
    endReason,
    symptomsJson,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fasting_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FastingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('started_at_utc_ms')) {
      context.handle(
        _startedAtUtcMsMeta,
        startedAtUtcMs.isAcceptableOrUnknown(
          data['started_at_utc_ms']!,
          _startedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtUtcMsMeta);
    }
    if (data.containsKey('target_minutes')) {
      context.handle(
        _targetMinutesMeta,
        targetMinutes.isAcceptableOrUnknown(
          data['target_minutes']!,
          _targetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetMinutesMeta);
    }
    if (data.containsKey('timezone_name')) {
      context.handle(
        _timezoneNameMeta,
        timezoneName.isAcceptableOrUnknown(
          data['timezone_name']!,
          _timezoneNameMeta,
        ),
      );
    }
    if (data.containsKey('ended_at_utc_ms')) {
      context.handle(
        _endedAtUtcMsMeta,
        endedAtUtcMs.isAcceptableOrUnknown(
          data['ended_at_utc_ms']!,
          _endedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('end_reason')) {
      context.handle(
        _endReasonMeta,
        endReason.isAcceptableOrUnknown(data['end_reason']!, _endReasonMeta),
      );
    }
    if (data.containsKey('symptoms_json')) {
      context.handle(
        _symptomsJsonMeta,
        symptomsJson.isAcceptableOrUnknown(
          data['symptoms_json']!,
          _symptomsJsonMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    if (data.containsKey('deleted_at_utc_ms')) {
      context.handle(
        _deletedAtUtcMsMeta,
        deletedAtUtcMs.isAcceptableOrUnknown(
          data['deleted_at_utc_ms']!,
          _deletedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FastingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FastingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      ),
      startedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_utc_ms'],
      )!,
      targetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_minutes'],
      )!,
      timezoneName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone_name'],
      )!,
      endedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at_utc_ms'],
      ),
      endReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_reason'],
      ),
      symptomsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms_json'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
      deletedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc_ms'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $FastingSessionsTable createAlias(String alias) {
    return $FastingSessionsTable(attachedDatabase, alias);
  }
}

class FastingSession extends DataClass implements Insertable<FastingSession> {
  final String id;
  final String? planId;
  final int startedAtUtcMs;
  final int targetMinutes;
  final String timezoneName;
  final int? endedAtUtcMs;
  final String? endReason;
  final String symptomsJson;
  final int revision;
  final int updatedAtUtcMs;
  final int? deletedAtUtcMs;
  final String syncStatus;
  const FastingSession({
    required this.id,
    this.planId,
    required this.startedAtUtcMs,
    required this.targetMinutes,
    required this.timezoneName,
    this.endedAtUtcMs,
    this.endReason,
    required this.symptomsJson,
    required this.revision,
    required this.updatedAtUtcMs,
    this.deletedAtUtcMs,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<String>(planId);
    }
    map['started_at_utc_ms'] = Variable<int>(startedAtUtcMs);
    map['target_minutes'] = Variable<int>(targetMinutes);
    map['timezone_name'] = Variable<String>(timezoneName);
    if (!nullToAbsent || endedAtUtcMs != null) {
      map['ended_at_utc_ms'] = Variable<int>(endedAtUtcMs);
    }
    if (!nullToAbsent || endReason != null) {
      map['end_reason'] = Variable<String>(endReason);
    }
    map['symptoms_json'] = Variable<String>(symptomsJson);
    map['revision'] = Variable<int>(revision);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    if (!nullToAbsent || deletedAtUtcMs != null) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  FastingSessionsCompanion toCompanion(bool nullToAbsent) {
    return FastingSessionsCompanion(
      id: Value(id),
      planId: planId == null && nullToAbsent
          ? const Value.absent()
          : Value(planId),
      startedAtUtcMs: Value(startedAtUtcMs),
      targetMinutes: Value(targetMinutes),
      timezoneName: Value(timezoneName),
      endedAtUtcMs: endedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtUtcMs),
      endReason: endReason == null && nullToAbsent
          ? const Value.absent()
          : Value(endReason),
      symptomsJson: Value(symptomsJson),
      revision: Value(revision),
      updatedAtUtcMs: Value(updatedAtUtcMs),
      deletedAtUtcMs: deletedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtcMs),
      syncStatus: Value(syncStatus),
    );
  }

  factory FastingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FastingSession(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String?>(json['planId']),
      startedAtUtcMs: serializer.fromJson<int>(json['startedAtUtcMs']),
      targetMinutes: serializer.fromJson<int>(json['targetMinutes']),
      timezoneName: serializer.fromJson<String>(json['timezoneName']),
      endedAtUtcMs: serializer.fromJson<int?>(json['endedAtUtcMs']),
      endReason: serializer.fromJson<String?>(json['endReason']),
      symptomsJson: serializer.fromJson<String>(json['symptomsJson']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
      deletedAtUtcMs: serializer.fromJson<int?>(json['deletedAtUtcMs']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String?>(planId),
      'startedAtUtcMs': serializer.toJson<int>(startedAtUtcMs),
      'targetMinutes': serializer.toJson<int>(targetMinutes),
      'timezoneName': serializer.toJson<String>(timezoneName),
      'endedAtUtcMs': serializer.toJson<int?>(endedAtUtcMs),
      'endReason': serializer.toJson<String?>(endReason),
      'symptomsJson': serializer.toJson<String>(symptomsJson),
      'revision': serializer.toJson<int>(revision),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
      'deletedAtUtcMs': serializer.toJson<int?>(deletedAtUtcMs),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  FastingSession copyWith({
    String? id,
    Value<String?> planId = const Value.absent(),
    int? startedAtUtcMs,
    int? targetMinutes,
    String? timezoneName,
    Value<int?> endedAtUtcMs = const Value.absent(),
    Value<String?> endReason = const Value.absent(),
    String? symptomsJson,
    int? revision,
    int? updatedAtUtcMs,
    Value<int?> deletedAtUtcMs = const Value.absent(),
    String? syncStatus,
  }) => FastingSession(
    id: id ?? this.id,
    planId: planId.present ? planId.value : this.planId,
    startedAtUtcMs: startedAtUtcMs ?? this.startedAtUtcMs,
    targetMinutes: targetMinutes ?? this.targetMinutes,
    timezoneName: timezoneName ?? this.timezoneName,
    endedAtUtcMs: endedAtUtcMs.present ? endedAtUtcMs.value : this.endedAtUtcMs,
    endReason: endReason.present ? endReason.value : this.endReason,
    symptomsJson: symptomsJson ?? this.symptomsJson,
    revision: revision ?? this.revision,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
    deletedAtUtcMs: deletedAtUtcMs.present
        ? deletedAtUtcMs.value
        : this.deletedAtUtcMs,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  FastingSession copyWithCompanion(FastingSessionsCompanion data) {
    return FastingSession(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      startedAtUtcMs: data.startedAtUtcMs.present
          ? data.startedAtUtcMs.value
          : this.startedAtUtcMs,
      targetMinutes: data.targetMinutes.present
          ? data.targetMinutes.value
          : this.targetMinutes,
      timezoneName: data.timezoneName.present
          ? data.timezoneName.value
          : this.timezoneName,
      endedAtUtcMs: data.endedAtUtcMs.present
          ? data.endedAtUtcMs.value
          : this.endedAtUtcMs,
      endReason: data.endReason.present ? data.endReason.value : this.endReason,
      symptomsJson: data.symptomsJson.present
          ? data.symptomsJson.value
          : this.symptomsJson,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
      deletedAtUtcMs: data.deletedAtUtcMs.present
          ? data.deletedAtUtcMs.value
          : this.deletedAtUtcMs,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FastingSession(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('startedAtUtcMs: $startedAtUtcMs, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('timezoneName: $timezoneName, ')
          ..write('endedAtUtcMs: $endedAtUtcMs, ')
          ..write('endReason: $endReason, ')
          ..write('symptomsJson: $symptomsJson, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    startedAtUtcMs,
    targetMinutes,
    timezoneName,
    endedAtUtcMs,
    endReason,
    symptomsJson,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FastingSession &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.startedAtUtcMs == this.startedAtUtcMs &&
          other.targetMinutes == this.targetMinutes &&
          other.timezoneName == this.timezoneName &&
          other.endedAtUtcMs == this.endedAtUtcMs &&
          other.endReason == this.endReason &&
          other.symptomsJson == this.symptomsJson &&
          other.revision == this.revision &&
          other.updatedAtUtcMs == this.updatedAtUtcMs &&
          other.deletedAtUtcMs == this.deletedAtUtcMs &&
          other.syncStatus == this.syncStatus);
}

class FastingSessionsCompanion extends UpdateCompanion<FastingSession> {
  final Value<String> id;
  final Value<String?> planId;
  final Value<int> startedAtUtcMs;
  final Value<int> targetMinutes;
  final Value<String> timezoneName;
  final Value<int?> endedAtUtcMs;
  final Value<String?> endReason;
  final Value<String> symptomsJson;
  final Value<int> revision;
  final Value<int> updatedAtUtcMs;
  final Value<int?> deletedAtUtcMs;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const FastingSessionsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.startedAtUtcMs = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.timezoneName = const Value.absent(),
    this.endedAtUtcMs = const Value.absent(),
    this.endReason = const Value.absent(),
    this.symptomsJson = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FastingSessionsCompanion.insert({
    required String id,
    this.planId = const Value.absent(),
    required int startedAtUtcMs,
    required int targetMinutes,
    this.timezoneName = const Value.absent(),
    this.endedAtUtcMs = const Value.absent(),
    this.endReason = const Value.absent(),
    this.symptomsJson = const Value.absent(),
    this.revision = const Value.absent(),
    required int updatedAtUtcMs,
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAtUtcMs = Value(startedAtUtcMs),
       targetMinutes = Value(targetMinutes),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<FastingSession> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<int>? startedAtUtcMs,
    Expression<int>? targetMinutes,
    Expression<String>? timezoneName,
    Expression<int>? endedAtUtcMs,
    Expression<String>? endReason,
    Expression<String>? symptomsJson,
    Expression<int>? revision,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? deletedAtUtcMs,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (startedAtUtcMs != null) 'started_at_utc_ms': startedAtUtcMs,
      if (targetMinutes != null) 'target_minutes': targetMinutes,
      if (timezoneName != null) 'timezone_name': timezoneName,
      if (endedAtUtcMs != null) 'ended_at_utc_ms': endedAtUtcMs,
      if (endReason != null) 'end_reason': endReason,
      if (symptomsJson != null) 'symptoms_json': symptomsJson,
      if (revision != null) 'revision': revision,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (deletedAtUtcMs != null) 'deleted_at_utc_ms': deletedAtUtcMs,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FastingSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? planId,
    Value<int>? startedAtUtcMs,
    Value<int>? targetMinutes,
    Value<String>? timezoneName,
    Value<int?>? endedAtUtcMs,
    Value<String?>? endReason,
    Value<String>? symptomsJson,
    Value<int>? revision,
    Value<int>? updatedAtUtcMs,
    Value<int?>? deletedAtUtcMs,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return FastingSessionsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      startedAtUtcMs: startedAtUtcMs ?? this.startedAtUtcMs,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      timezoneName: timezoneName ?? this.timezoneName,
      endedAtUtcMs: endedAtUtcMs ?? this.endedAtUtcMs,
      endReason: endReason ?? this.endReason,
      symptomsJson: symptomsJson ?? this.symptomsJson,
      revision: revision ?? this.revision,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      deletedAtUtcMs: deletedAtUtcMs ?? this.deletedAtUtcMs,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (startedAtUtcMs.present) {
      map['started_at_utc_ms'] = Variable<int>(startedAtUtcMs.value);
    }
    if (targetMinutes.present) {
      map['target_minutes'] = Variable<int>(targetMinutes.value);
    }
    if (timezoneName.present) {
      map['timezone_name'] = Variable<String>(timezoneName.value);
    }
    if (endedAtUtcMs.present) {
      map['ended_at_utc_ms'] = Variable<int>(endedAtUtcMs.value);
    }
    if (endReason.present) {
      map['end_reason'] = Variable<String>(endReason.value);
    }
    if (symptomsJson.present) {
      map['symptoms_json'] = Variable<String>(symptomsJson.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (deletedAtUtcMs.present) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FastingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('startedAtUtcMs: $startedAtUtcMs, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('timezoneName: $timezoneName, ')
          ..write('endedAtUtcMs: $endedAtUtcMs, ')
          ..write('endReason: $endReason, ')
          ..write('symptomsJson: $symptomsJson, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaterEntriesTable extends WaterEntries
    with TableInfo<$WaterEntriesTable, WaterEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _millilitersMeta = const VerificationMeta(
    'milliliters',
  );
  @override
  late final GeneratedColumn<int> milliliters = GeneratedColumn<int>(
    'milliliters',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtUtcMsMeta = const VerificationMeta(
    'loggedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> loggedAtUtcMs = GeneratedColumn<int>(
    'logged_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMsMeta = const VerificationMeta(
    'deletedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtcMs = GeneratedColumn<int>(
    'deleted_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    milliliters,
    loggedAtUtcMs,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('milliliters')) {
      context.handle(
        _millilitersMeta,
        milliliters.isAcceptableOrUnknown(
          data['milliliters']!,
          _millilitersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_millilitersMeta);
    }
    if (data.containsKey('logged_at_utc_ms')) {
      context.handle(
        _loggedAtUtcMsMeta,
        loggedAtUtcMs.isAcceptableOrUnknown(
          data['logged_at_utc_ms']!,
          _loggedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_loggedAtUtcMsMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    if (data.containsKey('deleted_at_utc_ms')) {
      context.handle(
        _deletedAtUtcMsMeta,
        deletedAtUtcMs.isAcceptableOrUnknown(
          data['deleted_at_utc_ms']!,
          _deletedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      milliliters: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}milliliters'],
      )!,
      loggedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logged_at_utc_ms'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
      deletedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc_ms'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $WaterEntriesTable createAlias(String alias) {
    return $WaterEntriesTable(attachedDatabase, alias);
  }
}

class WaterEntry extends DataClass implements Insertable<WaterEntry> {
  final String id;
  final String? sessionId;
  final int milliliters;
  final int loggedAtUtcMs;
  final int revision;
  final int updatedAtUtcMs;
  final int? deletedAtUtcMs;
  final String syncStatus;
  const WaterEntry({
    required this.id,
    this.sessionId,
    required this.milliliters,
    required this.loggedAtUtcMs,
    required this.revision,
    required this.updatedAtUtcMs,
    this.deletedAtUtcMs,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['milliliters'] = Variable<int>(milliliters);
    map['logged_at_utc_ms'] = Variable<int>(loggedAtUtcMs);
    map['revision'] = Variable<int>(revision);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    if (!nullToAbsent || deletedAtUtcMs != null) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  WaterEntriesCompanion toCompanion(bool nullToAbsent) {
    return WaterEntriesCompanion(
      id: Value(id),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      milliliters: Value(milliliters),
      loggedAtUtcMs: Value(loggedAtUtcMs),
      revision: Value(revision),
      updatedAtUtcMs: Value(updatedAtUtcMs),
      deletedAtUtcMs: deletedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtcMs),
      syncStatus: Value(syncStatus),
    );
  }

  factory WaterEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterEntry(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      milliliters: serializer.fromJson<int>(json['milliliters']),
      loggedAtUtcMs: serializer.fromJson<int>(json['loggedAtUtcMs']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
      deletedAtUtcMs: serializer.fromJson<int?>(json['deletedAtUtcMs']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String?>(sessionId),
      'milliliters': serializer.toJson<int>(milliliters),
      'loggedAtUtcMs': serializer.toJson<int>(loggedAtUtcMs),
      'revision': serializer.toJson<int>(revision),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
      'deletedAtUtcMs': serializer.toJson<int?>(deletedAtUtcMs),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  WaterEntry copyWith({
    String? id,
    Value<String?> sessionId = const Value.absent(),
    int? milliliters,
    int? loggedAtUtcMs,
    int? revision,
    int? updatedAtUtcMs,
    Value<int?> deletedAtUtcMs = const Value.absent(),
    String? syncStatus,
  }) => WaterEntry(
    id: id ?? this.id,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    milliliters: milliliters ?? this.milliliters,
    loggedAtUtcMs: loggedAtUtcMs ?? this.loggedAtUtcMs,
    revision: revision ?? this.revision,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
    deletedAtUtcMs: deletedAtUtcMs.present
        ? deletedAtUtcMs.value
        : this.deletedAtUtcMs,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  WaterEntry copyWithCompanion(WaterEntriesCompanion data) {
    return WaterEntry(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      milliliters: data.milliliters.present
          ? data.milliliters.value
          : this.milliliters,
      loggedAtUtcMs: data.loggedAtUtcMs.present
          ? data.loggedAtUtcMs.value
          : this.loggedAtUtcMs,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
      deletedAtUtcMs: data.deletedAtUtcMs.present
          ? data.deletedAtUtcMs.value
          : this.deletedAtUtcMs,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterEntry(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('milliliters: $milliliters, ')
          ..write('loggedAtUtcMs: $loggedAtUtcMs, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    milliliters,
    loggedAtUtcMs,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterEntry &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.milliliters == this.milliliters &&
          other.loggedAtUtcMs == this.loggedAtUtcMs &&
          other.revision == this.revision &&
          other.updatedAtUtcMs == this.updatedAtUtcMs &&
          other.deletedAtUtcMs == this.deletedAtUtcMs &&
          other.syncStatus == this.syncStatus);
}

class WaterEntriesCompanion extends UpdateCompanion<WaterEntry> {
  final Value<String> id;
  final Value<String?> sessionId;
  final Value<int> milliliters;
  final Value<int> loggedAtUtcMs;
  final Value<int> revision;
  final Value<int> updatedAtUtcMs;
  final Value<int?> deletedAtUtcMs;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const WaterEntriesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.milliliters = const Value.absent(),
    this.loggedAtUtcMs = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WaterEntriesCompanion.insert({
    required String id,
    this.sessionId = const Value.absent(),
    required int milliliters,
    required int loggedAtUtcMs,
    this.revision = const Value.absent(),
    required int updatedAtUtcMs,
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       milliliters = Value(milliliters),
       loggedAtUtcMs = Value(loggedAtUtcMs),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<WaterEntry> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? milliliters,
    Expression<int>? loggedAtUtcMs,
    Expression<int>? revision,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? deletedAtUtcMs,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (milliliters != null) 'milliliters': milliliters,
      if (loggedAtUtcMs != null) 'logged_at_utc_ms': loggedAtUtcMs,
      if (revision != null) 'revision': revision,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (deletedAtUtcMs != null) 'deleted_at_utc_ms': deletedAtUtcMs,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WaterEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? sessionId,
    Value<int>? milliliters,
    Value<int>? loggedAtUtcMs,
    Value<int>? revision,
    Value<int>? updatedAtUtcMs,
    Value<int?>? deletedAtUtcMs,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return WaterEntriesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      milliliters: milliliters ?? this.milliliters,
      loggedAtUtcMs: loggedAtUtcMs ?? this.loggedAtUtcMs,
      revision: revision ?? this.revision,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      deletedAtUtcMs: deletedAtUtcMs ?? this.deletedAtUtcMs,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (milliliters.present) {
      map['milliliters'] = Variable<int>(milliliters.value);
    }
    if (loggedAtUtcMs.present) {
      map['logged_at_utc_ms'] = Variable<int>(loggedAtUtcMs.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (deletedAtUtcMs.present) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('milliliters: $milliliters, ')
          ..write('loggedAtUtcMs: $loggedAtUtcMs, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightEntriesTable extends WeightEntries
    with TableInfo<$WeightEntriesTable, WeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kilogramsMeta = const VerificationMeta(
    'kilograms',
  );
  @override
  late final GeneratedColumn<double> kilograms = GeneratedColumn<double>(
    'kilograms',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtUtcMsMeta = const VerificationMeta(
    'loggedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> loggedAtUtcMs = GeneratedColumn<int>(
    'logged_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMsMeta = const VerificationMeta(
    'deletedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtcMs = GeneratedColumn<int>(
    'deleted_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kilograms,
    loggedAtUtcMs,
    note,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kilograms')) {
      context.handle(
        _kilogramsMeta,
        kilograms.isAcceptableOrUnknown(data['kilograms']!, _kilogramsMeta),
      );
    } else if (isInserting) {
      context.missing(_kilogramsMeta);
    }
    if (data.containsKey('logged_at_utc_ms')) {
      context.handle(
        _loggedAtUtcMsMeta,
        loggedAtUtcMs.isAcceptableOrUnknown(
          data['logged_at_utc_ms']!,
          _loggedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_loggedAtUtcMsMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    if (data.containsKey('deleted_at_utc_ms')) {
      context.handle(
        _deletedAtUtcMsMeta,
        deletedAtUtcMs.isAcceptableOrUnknown(
          data['deleted_at_utc_ms']!,
          _deletedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kilograms: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kilograms'],
      )!,
      loggedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logged_at_utc_ms'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
      deletedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc_ms'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $WeightEntriesTable createAlias(String alias) {
    return $WeightEntriesTable(attachedDatabase, alias);
  }
}

class WeightEntry extends DataClass implements Insertable<WeightEntry> {
  final String id;
  final double kilograms;
  final int loggedAtUtcMs;
  final String? note;
  final int revision;
  final int updatedAtUtcMs;
  final int? deletedAtUtcMs;
  final String syncStatus;
  const WeightEntry({
    required this.id,
    required this.kilograms,
    required this.loggedAtUtcMs,
    this.note,
    required this.revision,
    required this.updatedAtUtcMs,
    this.deletedAtUtcMs,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kilograms'] = Variable<double>(kilograms);
    map['logged_at_utc_ms'] = Variable<int>(loggedAtUtcMs);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['revision'] = Variable<int>(revision);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    if (!nullToAbsent || deletedAtUtcMs != null) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  WeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeightEntriesCompanion(
      id: Value(id),
      kilograms: Value(kilograms),
      loggedAtUtcMs: Value(loggedAtUtcMs),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      revision: Value(revision),
      updatedAtUtcMs: Value(updatedAtUtcMs),
      deletedAtUtcMs: deletedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtcMs),
      syncStatus: Value(syncStatus),
    );
  }

  factory WeightEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightEntry(
      id: serializer.fromJson<String>(json['id']),
      kilograms: serializer.fromJson<double>(json['kilograms']),
      loggedAtUtcMs: serializer.fromJson<int>(json['loggedAtUtcMs']),
      note: serializer.fromJson<String?>(json['note']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
      deletedAtUtcMs: serializer.fromJson<int?>(json['deletedAtUtcMs']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kilograms': serializer.toJson<double>(kilograms),
      'loggedAtUtcMs': serializer.toJson<int>(loggedAtUtcMs),
      'note': serializer.toJson<String?>(note),
      'revision': serializer.toJson<int>(revision),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
      'deletedAtUtcMs': serializer.toJson<int?>(deletedAtUtcMs),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  WeightEntry copyWith({
    String? id,
    double? kilograms,
    int? loggedAtUtcMs,
    Value<String?> note = const Value.absent(),
    int? revision,
    int? updatedAtUtcMs,
    Value<int?> deletedAtUtcMs = const Value.absent(),
    String? syncStatus,
  }) => WeightEntry(
    id: id ?? this.id,
    kilograms: kilograms ?? this.kilograms,
    loggedAtUtcMs: loggedAtUtcMs ?? this.loggedAtUtcMs,
    note: note.present ? note.value : this.note,
    revision: revision ?? this.revision,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
    deletedAtUtcMs: deletedAtUtcMs.present
        ? deletedAtUtcMs.value
        : this.deletedAtUtcMs,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  WeightEntry copyWithCompanion(WeightEntriesCompanion data) {
    return WeightEntry(
      id: data.id.present ? data.id.value : this.id,
      kilograms: data.kilograms.present ? data.kilograms.value : this.kilograms,
      loggedAtUtcMs: data.loggedAtUtcMs.present
          ? data.loggedAtUtcMs.value
          : this.loggedAtUtcMs,
      note: data.note.present ? data.note.value : this.note,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
      deletedAtUtcMs: data.deletedAtUtcMs.present
          ? data.deletedAtUtcMs.value
          : this.deletedAtUtcMs,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntry(')
          ..write('id: $id, ')
          ..write('kilograms: $kilograms, ')
          ..write('loggedAtUtcMs: $loggedAtUtcMs, ')
          ..write('note: $note, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kilograms,
    loggedAtUtcMs,
    note,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightEntry &&
          other.id == this.id &&
          other.kilograms == this.kilograms &&
          other.loggedAtUtcMs == this.loggedAtUtcMs &&
          other.note == this.note &&
          other.revision == this.revision &&
          other.updatedAtUtcMs == this.updatedAtUtcMs &&
          other.deletedAtUtcMs == this.deletedAtUtcMs &&
          other.syncStatus == this.syncStatus);
}

class WeightEntriesCompanion extends UpdateCompanion<WeightEntry> {
  final Value<String> id;
  final Value<double> kilograms;
  final Value<int> loggedAtUtcMs;
  final Value<String?> note;
  final Value<int> revision;
  final Value<int> updatedAtUtcMs;
  final Value<int?> deletedAtUtcMs;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const WeightEntriesCompanion({
    this.id = const Value.absent(),
    this.kilograms = const Value.absent(),
    this.loggedAtUtcMs = const Value.absent(),
    this.note = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightEntriesCompanion.insert({
    required String id,
    required double kilograms,
    required int loggedAtUtcMs,
    this.note = const Value.absent(),
    this.revision = const Value.absent(),
    required int updatedAtUtcMs,
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kilograms = Value(kilograms),
       loggedAtUtcMs = Value(loggedAtUtcMs),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<WeightEntry> custom({
    Expression<String>? id,
    Expression<double>? kilograms,
    Expression<int>? loggedAtUtcMs,
    Expression<String>? note,
    Expression<int>? revision,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? deletedAtUtcMs,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kilograms != null) 'kilograms': kilograms,
      if (loggedAtUtcMs != null) 'logged_at_utc_ms': loggedAtUtcMs,
      if (note != null) 'note': note,
      if (revision != null) 'revision': revision,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (deletedAtUtcMs != null) 'deleted_at_utc_ms': deletedAtUtcMs,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightEntriesCompanion copyWith({
    Value<String>? id,
    Value<double>? kilograms,
    Value<int>? loggedAtUtcMs,
    Value<String?>? note,
    Value<int>? revision,
    Value<int>? updatedAtUtcMs,
    Value<int?>? deletedAtUtcMs,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return WeightEntriesCompanion(
      id: id ?? this.id,
      kilograms: kilograms ?? this.kilograms,
      loggedAtUtcMs: loggedAtUtcMs ?? this.loggedAtUtcMs,
      note: note ?? this.note,
      revision: revision ?? this.revision,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      deletedAtUtcMs: deletedAtUtcMs ?? this.deletedAtUtcMs,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kilograms.present) {
      map['kilograms'] = Variable<double>(kilograms.value);
    }
    if (loggedAtUtcMs.present) {
      map['logged_at_utc_ms'] = Variable<int>(loggedAtUtcMs.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (deletedAtUtcMs.present) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kilograms: $kilograms, ')
          ..write('loggedAtUtcMs: $loggedAtUtcMs, ')
          ..write('note: $note, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyHealthLogsTable extends DailyHealthLogs
    with TableInfo<$DailyHealthLogsTable, DailyHealthLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyHealthLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _timezoneNameMeta = const VerificationMeta(
    'timezoneName',
  );
  @override
  late final GeneratedColumn<String> timezoneName = GeneratedColumn<String>(
    'timezone_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMsMeta = const VerificationMeta(
    'deletedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtcMs = GeneratedColumn<int>(
    'deleted_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateKey,
    timezoneName,
    calories,
    steps,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_health_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyHealthLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('timezone_name')) {
      context.handle(
        _timezoneNameMeta,
        timezoneName.isAcceptableOrUnknown(
          data['timezone_name']!,
          _timezoneNameMeta,
        ),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    if (data.containsKey('deleted_at_utc_ms')) {
      context.handle(
        _deletedAtUtcMsMeta,
        deletedAtUtcMs.isAcceptableOrUnknown(
          data['deleted_at_utc_ms']!,
          _deletedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyHealthLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyHealthLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      timezoneName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone_name'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
      deletedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc_ms'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $DailyHealthLogsTable createAlias(String alias) {
    return $DailyHealthLogsTable(attachedDatabase, alias);
  }
}

class DailyHealthLog extends DataClass implements Insertable<DailyHealthLog> {
  final String id;
  final String dateKey;
  final String timezoneName;
  final int calories;
  final int steps;
  final int revision;
  final int updatedAtUtcMs;
  final int? deletedAtUtcMs;
  final String syncStatus;
  const DailyHealthLog({
    required this.id,
    required this.dateKey,
    required this.timezoneName,
    required this.calories,
    required this.steps,
    required this.revision,
    required this.updatedAtUtcMs,
    this.deletedAtUtcMs,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['timezone_name'] = Variable<String>(timezoneName);
    map['calories'] = Variable<int>(calories);
    map['steps'] = Variable<int>(steps);
    map['revision'] = Variable<int>(revision);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    if (!nullToAbsent || deletedAtUtcMs != null) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  DailyHealthLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyHealthLogsCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      timezoneName: Value(timezoneName),
      calories: Value(calories),
      steps: Value(steps),
      revision: Value(revision),
      updatedAtUtcMs: Value(updatedAtUtcMs),
      deletedAtUtcMs: deletedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtcMs),
      syncStatus: Value(syncStatus),
    );
  }

  factory DailyHealthLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyHealthLog(
      id: serializer.fromJson<String>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      timezoneName: serializer.fromJson<String>(json['timezoneName']),
      calories: serializer.fromJson<int>(json['calories']),
      steps: serializer.fromJson<int>(json['steps']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
      deletedAtUtcMs: serializer.fromJson<int?>(json['deletedAtUtcMs']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'timezoneName': serializer.toJson<String>(timezoneName),
      'calories': serializer.toJson<int>(calories),
      'steps': serializer.toJson<int>(steps),
      'revision': serializer.toJson<int>(revision),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
      'deletedAtUtcMs': serializer.toJson<int?>(deletedAtUtcMs),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  DailyHealthLog copyWith({
    String? id,
    String? dateKey,
    String? timezoneName,
    int? calories,
    int? steps,
    int? revision,
    int? updatedAtUtcMs,
    Value<int?> deletedAtUtcMs = const Value.absent(),
    String? syncStatus,
  }) => DailyHealthLog(
    id: id ?? this.id,
    dateKey: dateKey ?? this.dateKey,
    timezoneName: timezoneName ?? this.timezoneName,
    calories: calories ?? this.calories,
    steps: steps ?? this.steps,
    revision: revision ?? this.revision,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
    deletedAtUtcMs: deletedAtUtcMs.present
        ? deletedAtUtcMs.value
        : this.deletedAtUtcMs,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  DailyHealthLog copyWithCompanion(DailyHealthLogsCompanion data) {
    return DailyHealthLog(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      timezoneName: data.timezoneName.present
          ? data.timezoneName.value
          : this.timezoneName,
      calories: data.calories.present ? data.calories.value : this.calories,
      steps: data.steps.present ? data.steps.value : this.steps,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
      deletedAtUtcMs: data.deletedAtUtcMs.present
          ? data.deletedAtUtcMs.value
          : this.deletedAtUtcMs,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyHealthLog(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('timezoneName: $timezoneName, ')
          ..write('calories: $calories, ')
          ..write('steps: $steps, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dateKey,
    timezoneName,
    calories,
    steps,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyHealthLog &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.timezoneName == this.timezoneName &&
          other.calories == this.calories &&
          other.steps == this.steps &&
          other.revision == this.revision &&
          other.updatedAtUtcMs == this.updatedAtUtcMs &&
          other.deletedAtUtcMs == this.deletedAtUtcMs &&
          other.syncStatus == this.syncStatus);
}

class DailyHealthLogsCompanion extends UpdateCompanion<DailyHealthLog> {
  final Value<String> id;
  final Value<String> dateKey;
  final Value<String> timezoneName;
  final Value<int> calories;
  final Value<int> steps;
  final Value<int> revision;
  final Value<int> updatedAtUtcMs;
  final Value<int?> deletedAtUtcMs;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const DailyHealthLogsCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.timezoneName = const Value.absent(),
    this.calories = const Value.absent(),
    this.steps = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyHealthLogsCompanion.insert({
    required String id,
    required String dateKey,
    this.timezoneName = const Value.absent(),
    this.calories = const Value.absent(),
    this.steps = const Value.absent(),
    this.revision = const Value.absent(),
    required int updatedAtUtcMs,
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dateKey = Value(dateKey),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<DailyHealthLog> custom({
    Expression<String>? id,
    Expression<String>? dateKey,
    Expression<String>? timezoneName,
    Expression<int>? calories,
    Expression<int>? steps,
    Expression<int>? revision,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? deletedAtUtcMs,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (timezoneName != null) 'timezone_name': timezoneName,
      if (calories != null) 'calories': calories,
      if (steps != null) 'steps': steps,
      if (revision != null) 'revision': revision,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (deletedAtUtcMs != null) 'deleted_at_utc_ms': deletedAtUtcMs,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyHealthLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? dateKey,
    Value<String>? timezoneName,
    Value<int>? calories,
    Value<int>? steps,
    Value<int>? revision,
    Value<int>? updatedAtUtcMs,
    Value<int?>? deletedAtUtcMs,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return DailyHealthLogsCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      timezoneName: timezoneName ?? this.timezoneName,
      calories: calories ?? this.calories,
      steps: steps ?? this.steps,
      revision: revision ?? this.revision,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      deletedAtUtcMs: deletedAtUtcMs ?? this.deletedAtUtcMs,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (timezoneName.present) {
      map['timezone_name'] = Variable<String>(timezoneName.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (deletedAtUtcMs.present) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyHealthLogsCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('timezoneName: $timezoneName, ')
          ..write('calories: $calories, ')
          ..write('steps: $steps, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isGuestMeta = const VerificationMeta(
    'isGuest',
  );
  @override
  late final GeneratedColumn<bool> isGuest = GeneratedColumn<bool>(
    'is_guest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_guest" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtUtcMsMeta = const VerificationMeta(
    'createdAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> createdAtUtcMs = GeneratedColumn<int>(
    'created_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMsMeta = const VerificationMeta(
    'deletedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtcMs = GeneratedColumn<int>(
    'deleted_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    displayName,
    isGuest,
    createdAtUtcMs,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('is_guest')) {
      context.handle(
        _isGuestMeta,
        isGuest.isAcceptableOrUnknown(data['is_guest']!, _isGuestMeta),
      );
    }
    if (data.containsKey('created_at_utc_ms')) {
      context.handle(
        _createdAtUtcMsMeta,
        createdAtUtcMs.isAcceptableOrUnknown(
          data['created_at_utc_ms']!,
          _createdAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMsMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    if (data.containsKey('deleted_at_utc_ms')) {
      context.handle(
        _deletedAtUtcMsMeta,
        deletedAtUtcMs.isAcceptableOrUnknown(
          data['deleted_at_utc_ms']!,
          _deletedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      isGuest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_guest'],
      )!,
      createdAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_ms'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
      deletedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc_ms'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final String? email;
  final String displayName;
  final bool isGuest;
  final int createdAtUtcMs;
  final int revision;
  final int updatedAtUtcMs;
  final int? deletedAtUtcMs;
  final String syncStatus;
  const UserProfile({
    required this.id,
    this.email,
    required this.displayName,
    required this.isGuest,
    required this.createdAtUtcMs,
    required this.revision,
    required this.updatedAtUtcMs,
    this.deletedAtUtcMs,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['display_name'] = Variable<String>(displayName);
    map['is_guest'] = Variable<bool>(isGuest);
    map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs);
    map['revision'] = Variable<int>(revision);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    if (!nullToAbsent || deletedAtUtcMs != null) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      displayName: Value(displayName),
      isGuest: Value(isGuest),
      createdAtUtcMs: Value(createdAtUtcMs),
      revision: Value(revision),
      updatedAtUtcMs: Value(updatedAtUtcMs),
      deletedAtUtcMs: deletedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtcMs),
      syncStatus: Value(syncStatus),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String?>(json['email']),
      displayName: serializer.fromJson<String>(json['displayName']),
      isGuest: serializer.fromJson<bool>(json['isGuest']),
      createdAtUtcMs: serializer.fromJson<int>(json['createdAtUtcMs']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
      deletedAtUtcMs: serializer.fromJson<int?>(json['deletedAtUtcMs']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String?>(email),
      'displayName': serializer.toJson<String>(displayName),
      'isGuest': serializer.toJson<bool>(isGuest),
      'createdAtUtcMs': serializer.toJson<int>(createdAtUtcMs),
      'revision': serializer.toJson<int>(revision),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
      'deletedAtUtcMs': serializer.toJson<int?>(deletedAtUtcMs),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  UserProfile copyWith({
    String? id,
    Value<String?> email = const Value.absent(),
    String? displayName,
    bool? isGuest,
    int? createdAtUtcMs,
    int? revision,
    int? updatedAtUtcMs,
    Value<int?> deletedAtUtcMs = const Value.absent(),
    String? syncStatus,
  }) => UserProfile(
    id: id ?? this.id,
    email: email.present ? email.value : this.email,
    displayName: displayName ?? this.displayName,
    isGuest: isGuest ?? this.isGuest,
    createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
    revision: revision ?? this.revision,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
    deletedAtUtcMs: deletedAtUtcMs.present
        ? deletedAtUtcMs.value
        : this.deletedAtUtcMs,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      isGuest: data.isGuest.present ? data.isGuest.value : this.isGuest,
      createdAtUtcMs: data.createdAtUtcMs.present
          ? data.createdAtUtcMs.value
          : this.createdAtUtcMs,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
      deletedAtUtcMs: data.deletedAtUtcMs.present
          ? data.deletedAtUtcMs.value
          : this.deletedAtUtcMs,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('isGuest: $isGuest, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    displayName,
    isGuest,
    createdAtUtcMs,
    revision,
    updatedAtUtcMs,
    deletedAtUtcMs,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.isGuest == this.isGuest &&
          other.createdAtUtcMs == this.createdAtUtcMs &&
          other.revision == this.revision &&
          other.updatedAtUtcMs == this.updatedAtUtcMs &&
          other.deletedAtUtcMs == this.deletedAtUtcMs &&
          other.syncStatus == this.syncStatus);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String?> email;
  final Value<String> displayName;
  final Value<bool> isGuest;
  final Value<int> createdAtUtcMs;
  final Value<int> revision;
  final Value<int> updatedAtUtcMs;
  final Value<int?> deletedAtUtcMs;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.isGuest = const Value.absent(),
    this.createdAtUtcMs = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    this.email = const Value.absent(),
    required String displayName,
    this.isGuest = const Value.absent(),
    required int createdAtUtcMs,
    this.revision = const Value.absent(),
    required int updatedAtUtcMs,
    this.deletedAtUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       createdAtUtcMs = Value(createdAtUtcMs),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<bool>? isGuest,
    Expression<int>? createdAtUtcMs,
    Expression<int>? revision,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? deletedAtUtcMs,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (isGuest != null) 'is_guest': isGuest,
      if (createdAtUtcMs != null) 'created_at_utc_ms': createdAtUtcMs,
      if (revision != null) 'revision': revision,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (deletedAtUtcMs != null) 'deleted_at_utc_ms': deletedAtUtcMs,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? email,
    Value<String>? displayName,
    Value<bool>? isGuest,
    Value<int>? createdAtUtcMs,
    Value<int>? revision,
    Value<int>? updatedAtUtcMs,
    Value<int?>? deletedAtUtcMs,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isGuest: isGuest ?? this.isGuest,
      createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
      revision: revision ?? this.revision,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      deletedAtUtcMs: deletedAtUtcMs ?? this.deletedAtUtcMs,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (isGuest.present) {
      map['is_guest'] = Variable<bool>(isGuest.value);
    }
    if (createdAtUtcMs.present) {
      map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (deletedAtUtcMs.present) {
      map['deleted_at_utc_ms'] = Variable<int>(deletedAtUtcMs.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('isGuest: $isGuest, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('revision: $revision, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('deletedAtUtcMs: $deletedAtUtcMs, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OnboardingProfilesTable extends OnboardingProfiles
    with TableInfo<$OnboardingProfilesTable, OnboardingProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnboardingProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStepMeta = const VerificationMeta(
    'currentStep',
  );
  @override
  late final GeneratedColumn<int> currentStep = GeneratedColumn<int>(
    'current_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _answersJsonMeta = const VerificationMeta(
    'answersJson',
  );
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
    'answers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currentStep,
    completed,
    answersJson,
    updatedAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'onboarding_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnboardingProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('current_step')) {
      context.handle(
        _currentStepMeta,
        currentStep.isAcceptableOrUnknown(
          data['current_step']!,
          _currentStepMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('answers_json')) {
      context.handle(
        _answersJsonMeta,
        answersJson.isAcceptableOrUnknown(
          data['answers_json']!,
          _answersJsonMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OnboardingProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnboardingProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      currentStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_step'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      answersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers_json'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
    );
  }

  @override
  $OnboardingProfilesTable createAlias(String alias) {
    return $OnboardingProfilesTable(attachedDatabase, alias);
  }
}

class OnboardingProfile extends DataClass
    implements Insertable<OnboardingProfile> {
  final String id;
  final int currentStep;
  final bool completed;
  final String answersJson;
  final int updatedAtUtcMs;
  const OnboardingProfile({
    required this.id,
    required this.currentStep,
    required this.completed,
    required this.answersJson,
    required this.updatedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['current_step'] = Variable<int>(currentStep);
    map['completed'] = Variable<bool>(completed);
    map['answers_json'] = Variable<String>(answersJson);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    return map;
  }

  OnboardingProfilesCompanion toCompanion(bool nullToAbsent) {
    return OnboardingProfilesCompanion(
      id: Value(id),
      currentStep: Value(currentStep),
      completed: Value(completed),
      answersJson: Value(answersJson),
      updatedAtUtcMs: Value(updatedAtUtcMs),
    );
  }

  factory OnboardingProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnboardingProfile(
      id: serializer.fromJson<String>(json['id']),
      currentStep: serializer.fromJson<int>(json['currentStep']),
      completed: serializer.fromJson<bool>(json['completed']),
      answersJson: serializer.fromJson<String>(json['answersJson']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'currentStep': serializer.toJson<int>(currentStep),
      'completed': serializer.toJson<bool>(completed),
      'answersJson': serializer.toJson<String>(answersJson),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
    };
  }

  OnboardingProfile copyWith({
    String? id,
    int? currentStep,
    bool? completed,
    String? answersJson,
    int? updatedAtUtcMs,
  }) => OnboardingProfile(
    id: id ?? this.id,
    currentStep: currentStep ?? this.currentStep,
    completed: completed ?? this.completed,
    answersJson: answersJson ?? this.answersJson,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
  );
  OnboardingProfile copyWithCompanion(OnboardingProfilesCompanion data) {
    return OnboardingProfile(
      id: data.id.present ? data.id.value : this.id,
      currentStep: data.currentStep.present
          ? data.currentStep.value
          : this.currentStep,
      completed: data.completed.present ? data.completed.value : this.completed,
      answersJson: data.answersJson.present
          ? data.answersJson.value
          : this.answersJson,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingProfile(')
          ..write('id: $id, ')
          ..write('currentStep: $currentStep, ')
          ..write('completed: $completed, ')
          ..write('answersJson: $answersJson, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, currentStep, completed, answersJson, updatedAtUtcMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnboardingProfile &&
          other.id == this.id &&
          other.currentStep == this.currentStep &&
          other.completed == this.completed &&
          other.answersJson == this.answersJson &&
          other.updatedAtUtcMs == this.updatedAtUtcMs);
}

class OnboardingProfilesCompanion extends UpdateCompanion<OnboardingProfile> {
  final Value<String> id;
  final Value<int> currentStep;
  final Value<bool> completed;
  final Value<String> answersJson;
  final Value<int> updatedAtUtcMs;
  final Value<int> rowid;
  const OnboardingProfilesCompanion({
    this.id = const Value.absent(),
    this.currentStep = const Value.absent(),
    this.completed = const Value.absent(),
    this.answersJson = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OnboardingProfilesCompanion.insert({
    required String id,
    this.currentStep = const Value.absent(),
    this.completed = const Value.absent(),
    this.answersJson = const Value.absent(),
    required int updatedAtUtcMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<OnboardingProfile> custom({
    Expression<String>? id,
    Expression<int>? currentStep,
    Expression<bool>? completed,
    Expression<String>? answersJson,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentStep != null) 'current_step': currentStep,
      if (completed != null) 'completed': completed,
      if (answersJson != null) 'answers_json': answersJson,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OnboardingProfilesCompanion copyWith({
    Value<String>? id,
    Value<int>? currentStep,
    Value<bool>? completed,
    Value<String>? answersJson,
    Value<int>? updatedAtUtcMs,
    Value<int>? rowid,
  }) {
    return OnboardingProfilesCompanion(
      id: id ?? this.id,
      currentStep: currentStep ?? this.currentStep,
      completed: completed ?? this.completed,
      answersJson: answersJson ?? this.answersJson,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (currentStep.present) {
      map['current_step'] = Variable<int>(currentStep.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingProfilesCompanion(')
          ..write('id: $id, ')
          ..write('currentStep: $currentStep, ')
          ..write('completed: $completed, ')
          ..write('answersJson: $answersJson, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAtUtcMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final int updatedAtUtcMs;
  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAtUtcMs: Value(updatedAtUtcMs),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
    };
  }

  AppSetting copyWith({String? key, String? value, int? updatedAtUtcMs}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAtUtcMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAtUtcMs == this.updatedAtUtcMs);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAtUtcMs;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required int updatedAtUtcMs,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAtUtcMs,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOperationsTable extends SyncOperations
    with TableInfo<$SyncOperationsTable, SyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
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
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseRevisionMeta = const VerificationMeta(
    'baseRevision',
  );
  @override
  late final GeneratedColumn<int> baseRevision = GeneratedColumn<int>(
    'base_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtUtcMsMeta = const VerificationMeta(
    'createdAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> createdAtUtcMs = GeneratedColumn<int>(
    'created_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextAttemptAtUtcMsMeta =
      const VerificationMeta('nextAttemptAtUtcMs');
  @override
  late final GeneratedColumn<int> nextAttemptAtUtcMs = GeneratedColumn<int>(
    'next_attempt_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idempotencyKey,
    entityType,
    entityId,
    operation,
    baseRevision,
    payloadJson,
    status,
    attempts,
    createdAtUtcMs,
    nextAttemptAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('base_revision')) {
      context.handle(
        _baseRevisionMeta,
        baseRevision.isAcceptableOrUnknown(
          data['base_revision']!,
          _baseRevisionMeta,
        ),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('created_at_utc_ms')) {
      context.handle(
        _createdAtUtcMsMeta,
        createdAtUtcMs.isAcceptableOrUnknown(
          data['created_at_utc_ms']!,
          _createdAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMsMeta);
    }
    if (data.containsKey('next_attempt_at_utc_ms')) {
      context.handle(
        _nextAttemptAtUtcMsMeta,
        nextAttemptAtUtcMs.isAcceptableOrUnknown(
          data['next_attempt_at_utc_ms']!,
          _nextAttemptAtUtcMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOperation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      baseRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_revision'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      createdAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_ms'],
      )!,
      nextAttemptAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_attempt_at_utc_ms'],
      ),
    );
  }

  @override
  $SyncOperationsTable createAlias(String alias) {
    return $SyncOperationsTable(attachedDatabase, alias);
  }
}

class SyncOperation extends DataClass implements Insertable<SyncOperation> {
  final String id;
  final String idempotencyKey;
  final String entityType;
  final String entityId;
  final String operation;
  final int baseRevision;
  final String payloadJson;
  final String status;
  final int attempts;
  final int createdAtUtcMs;
  final int? nextAttemptAtUtcMs;
  const SyncOperation({
    required this.id,
    required this.idempotencyKey,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.baseRevision,
    required this.payloadJson,
    required this.status,
    required this.attempts,
    required this.createdAtUtcMs,
    this.nextAttemptAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['base_revision'] = Variable<int>(baseRevision);
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs);
    if (!nullToAbsent || nextAttemptAtUtcMs != null) {
      map['next_attempt_at_utc_ms'] = Variable<int>(nextAttemptAtUtcMs);
    }
    return map;
  }

  SyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return SyncOperationsCompanion(
      id: Value(id),
      idempotencyKey: Value(idempotencyKey),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      baseRevision: Value(baseRevision),
      payloadJson: Value(payloadJson),
      status: Value(status),
      attempts: Value(attempts),
      createdAtUtcMs: Value(createdAtUtcMs),
      nextAttemptAtUtcMs: nextAttemptAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAtUtcMs),
    );
  }

  factory SyncOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOperation(
      id: serializer.fromJson<String>(json['id']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      baseRevision: serializer.fromJson<int>(json['baseRevision']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAtUtcMs: serializer.fromJson<int>(json['createdAtUtcMs']),
      nextAttemptAtUtcMs: serializer.fromJson<int?>(json['nextAttemptAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'baseRevision': serializer.toJson<int>(baseRevision),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'createdAtUtcMs': serializer.toJson<int>(createdAtUtcMs),
      'nextAttemptAtUtcMs': serializer.toJson<int?>(nextAttemptAtUtcMs),
    };
  }

  SyncOperation copyWith({
    String? id,
    String? idempotencyKey,
    String? entityType,
    String? entityId,
    String? operation,
    int? baseRevision,
    String? payloadJson,
    String? status,
    int? attempts,
    int? createdAtUtcMs,
    Value<int?> nextAttemptAtUtcMs = const Value.absent(),
  }) => SyncOperation(
    id: id ?? this.id,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    baseRevision: baseRevision ?? this.baseRevision,
    payloadJson: payloadJson ?? this.payloadJson,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
    nextAttemptAtUtcMs: nextAttemptAtUtcMs.present
        ? nextAttemptAtUtcMs.value
        : this.nextAttemptAtUtcMs,
  );
  SyncOperation copyWithCompanion(SyncOperationsCompanion data) {
    return SyncOperation(
      id: data.id.present ? data.id.value : this.id,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      baseRevision: data.baseRevision.present
          ? data.baseRevision.value
          : this.baseRevision,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAtUtcMs: data.createdAtUtcMs.present
          ? data.createdAtUtcMs.value
          : this.createdAtUtcMs,
      nextAttemptAtUtcMs: data.nextAttemptAtUtcMs.present
          ? data.nextAttemptAtUtcMs.value
          : this.nextAttemptAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperation(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('baseRevision: $baseRevision, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('nextAttemptAtUtcMs: $nextAttemptAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idempotencyKey,
    entityType,
    entityId,
    operation,
    baseRevision,
    payloadJson,
    status,
    attempts,
    createdAtUtcMs,
    nextAttemptAtUtcMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOperation &&
          other.id == this.id &&
          other.idempotencyKey == this.idempotencyKey &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.baseRevision == this.baseRevision &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.createdAtUtcMs == this.createdAtUtcMs &&
          other.nextAttemptAtUtcMs == this.nextAttemptAtUtcMs);
}

class SyncOperationsCompanion extends UpdateCompanion<SyncOperation> {
  final Value<String> id;
  final Value<String> idempotencyKey;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<int> baseRevision;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int> attempts;
  final Value<int> createdAtUtcMs;
  final Value<int?> nextAttemptAtUtcMs;
  final Value<int> rowid;
  const SyncOperationsCompanion({
    this.id = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.baseRevision = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAtUtcMs = const Value.absent(),
    this.nextAttemptAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOperationsCompanion.insert({
    required String id,
    required String idempotencyKey,
    required String entityType,
    required String entityId,
    required String operation,
    this.baseRevision = const Value.absent(),
    required String payloadJson,
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    required int createdAtUtcMs,
    this.nextAttemptAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idempotencyKey = Value(idempotencyKey),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payloadJson = Value(payloadJson),
       createdAtUtcMs = Value(createdAtUtcMs);
  static Insertable<SyncOperation> custom({
    Expression<String>? id,
    Expression<String>? idempotencyKey,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<int>? baseRevision,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<int>? createdAtUtcMs,
    Expression<int>? nextAttemptAtUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (baseRevision != null) 'base_revision': baseRevision,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (createdAtUtcMs != null) 'created_at_utc_ms': createdAtUtcMs,
      if (nextAttemptAtUtcMs != null)
        'next_attempt_at_utc_ms': nextAttemptAtUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOperationsCompanion copyWith({
    Value<String>? id,
    Value<String>? idempotencyKey,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<int>? baseRevision,
    Value<String>? payloadJson,
    Value<String>? status,
    Value<int>? attempts,
    Value<int>? createdAtUtcMs,
    Value<int?>? nextAttemptAtUtcMs,
    Value<int>? rowid,
  }) {
    return SyncOperationsCompanion(
      id: id ?? this.id,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      baseRevision: baseRevision ?? this.baseRevision,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
      nextAttemptAtUtcMs: nextAttemptAtUtcMs ?? this.nextAttemptAtUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (baseRevision.present) {
      map['base_revision'] = Variable<int>(baseRevision.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAtUtcMs.present) {
      map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs.value);
    }
    if (nextAttemptAtUtcMs.present) {
      map['next_attempt_at_utc_ms'] = Variable<int>(nextAttemptAtUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationsCompanion(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('baseRevision: $baseRevision, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('nextAttemptAtUtcMs: $nextAttemptAtUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FastingPlansTable fastingPlans = $FastingPlansTable(this);
  late final $FastingSessionsTable fastingSessions = $FastingSessionsTable(
    this,
  );
  late final $WaterEntriesTable waterEntries = $WaterEntriesTable(this);
  late final $WeightEntriesTable weightEntries = $WeightEntriesTable(this);
  late final $DailyHealthLogsTable dailyHealthLogs = $DailyHealthLogsTable(
    this,
  );
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $OnboardingProfilesTable onboardingProfiles =
      $OnboardingProfilesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $SyncOperationsTable syncOperations = $SyncOperationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    fastingPlans,
    fastingSessions,
    waterEntries,
    weightEntries,
    dailyHealthLogs,
    userProfiles,
    onboardingProfiles,
    appSettings,
    syncOperations,
  ];
}

typedef $$FastingPlansTableCreateCompanionBuilder =
    FastingPlansCompanion Function({
      required String id,
      Value<int> fastMinutes,
      Value<int> eatingMinutes,
      Value<int> startMinuteOfDay,
      Value<String> timezoneName,
      Value<bool> active,
      Value<bool> paused,
      Value<int> revision,
      required int updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$FastingPlansTableUpdateCompanionBuilder =
    FastingPlansCompanion Function({
      Value<String> id,
      Value<int> fastMinutes,
      Value<int> eatingMinutes,
      Value<int> startMinuteOfDay,
      Value<String> timezoneName,
      Value<bool> active,
      Value<bool> paused,
      Value<int> revision,
      Value<int> updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$FastingPlansTableFilterComposer
    extends Composer<_$AppDatabase, $FastingPlansTable> {
  $$FastingPlansTableFilterComposer({
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

  ColumnFilters<int> get fastMinutes => $composableBuilder(
    column: $table.fastMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eatingMinutes => $composableBuilder(
    column: $table.eatingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezoneName => $composableBuilder(
    column: $table.timezoneName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FastingPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $FastingPlansTable> {
  $$FastingPlansTableOrderingComposer({
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

  ColumnOrderings<int> get fastMinutes => $composableBuilder(
    column: $table.fastMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eatingMinutes => $composableBuilder(
    column: $table.eatingMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezoneName => $composableBuilder(
    column: $table.timezoneName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FastingPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $FastingPlansTable> {
  $$FastingPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fastMinutes => $composableBuilder(
    column: $table.fastMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eatingMinutes => $composableBuilder(
    column: $table.eatingMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezoneName => $composableBuilder(
    column: $table.timezoneName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<bool> get paused =>
      $composableBuilder(column: $table.paused, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$FastingPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FastingPlansTable,
          FastingPlan,
          $$FastingPlansTableFilterComposer,
          $$FastingPlansTableOrderingComposer,
          $$FastingPlansTableAnnotationComposer,
          $$FastingPlansTableCreateCompanionBuilder,
          $$FastingPlansTableUpdateCompanionBuilder,
          (
            FastingPlan,
            BaseReferences<_$AppDatabase, $FastingPlansTable, FastingPlan>,
          ),
          FastingPlan,
          PrefetchHooks Function()
        > {
  $$FastingPlansTableTableManager(_$AppDatabase db, $FastingPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FastingPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FastingPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FastingPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> fastMinutes = const Value.absent(),
                Value<int> eatingMinutes = const Value.absent(),
                Value<int> startMinuteOfDay = const Value.absent(),
                Value<String> timezoneName = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FastingPlansCompanion(
                id: id,
                fastMinutes: fastMinutes,
                eatingMinutes: eatingMinutes,
                startMinuteOfDay: startMinuteOfDay,
                timezoneName: timezoneName,
                active: active,
                paused: paused,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> fastMinutes = const Value.absent(),
                Value<int> eatingMinutes = const Value.absent(),
                Value<int> startMinuteOfDay = const Value.absent(),
                Value<String> timezoneName = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<int> revision = const Value.absent(),
                required int updatedAtUtcMs,
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FastingPlansCompanion.insert(
                id: id,
                fastMinutes: fastMinutes,
                eatingMinutes: eatingMinutes,
                startMinuteOfDay: startMinuteOfDay,
                timezoneName: timezoneName,
                active: active,
                paused: paused,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FastingPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FastingPlansTable,
      FastingPlan,
      $$FastingPlansTableFilterComposer,
      $$FastingPlansTableOrderingComposer,
      $$FastingPlansTableAnnotationComposer,
      $$FastingPlansTableCreateCompanionBuilder,
      $$FastingPlansTableUpdateCompanionBuilder,
      (
        FastingPlan,
        BaseReferences<_$AppDatabase, $FastingPlansTable, FastingPlan>,
      ),
      FastingPlan,
      PrefetchHooks Function()
    >;
typedef $$FastingSessionsTableCreateCompanionBuilder =
    FastingSessionsCompanion Function({
      required String id,
      Value<String?> planId,
      required int startedAtUtcMs,
      required int targetMinutes,
      Value<String> timezoneName,
      Value<int?> endedAtUtcMs,
      Value<String?> endReason,
      Value<String> symptomsJson,
      Value<int> revision,
      required int updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$FastingSessionsTableUpdateCompanionBuilder =
    FastingSessionsCompanion Function({
      Value<String> id,
      Value<String?> planId,
      Value<int> startedAtUtcMs,
      Value<int> targetMinutes,
      Value<String> timezoneName,
      Value<int?> endedAtUtcMs,
      Value<String?> endReason,
      Value<String> symptomsJson,
      Value<int> revision,
      Value<int> updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$FastingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableFilterComposer({
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

  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtUtcMs => $composableBuilder(
    column: $table.startedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezoneName => $composableBuilder(
    column: $table.timezoneName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAtUtcMs => $composableBuilder(
    column: $table.endedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endReason => $composableBuilder(
    column: $table.endReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptomsJson => $composableBuilder(
    column: $table.symptomsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FastingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtUtcMs => $composableBuilder(
    column: $table.startedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezoneName => $composableBuilder(
    column: $table.timezoneName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAtUtcMs => $composableBuilder(
    column: $table.endedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endReason => $composableBuilder(
    column: $table.endReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptomsJson => $composableBuilder(
    column: $table.symptomsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FastingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<int> get startedAtUtcMs => $composableBuilder(
    column: $table.startedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezoneName => $composableBuilder(
    column: $table.timezoneName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endedAtUtcMs => $composableBuilder(
    column: $table.endedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endReason =>
      $composableBuilder(column: $table.endReason, builder: (column) => column);

  GeneratedColumn<String> get symptomsJson => $composableBuilder(
    column: $table.symptomsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$FastingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FastingSessionsTable,
          FastingSession,
          $$FastingSessionsTableFilterComposer,
          $$FastingSessionsTableOrderingComposer,
          $$FastingSessionsTableAnnotationComposer,
          $$FastingSessionsTableCreateCompanionBuilder,
          $$FastingSessionsTableUpdateCompanionBuilder,
          (
            FastingSession,
            BaseReferences<
              _$AppDatabase,
              $FastingSessionsTable,
              FastingSession
            >,
          ),
          FastingSession,
          PrefetchHooks Function()
        > {
  $$FastingSessionsTableTableManager(
    _$AppDatabase db,
    $FastingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FastingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FastingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FastingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> planId = const Value.absent(),
                Value<int> startedAtUtcMs = const Value.absent(),
                Value<int> targetMinutes = const Value.absent(),
                Value<String> timezoneName = const Value.absent(),
                Value<int?> endedAtUtcMs = const Value.absent(),
                Value<String?> endReason = const Value.absent(),
                Value<String> symptomsJson = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FastingSessionsCompanion(
                id: id,
                planId: planId,
                startedAtUtcMs: startedAtUtcMs,
                targetMinutes: targetMinutes,
                timezoneName: timezoneName,
                endedAtUtcMs: endedAtUtcMs,
                endReason: endReason,
                symptomsJson: symptomsJson,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> planId = const Value.absent(),
                required int startedAtUtcMs,
                required int targetMinutes,
                Value<String> timezoneName = const Value.absent(),
                Value<int?> endedAtUtcMs = const Value.absent(),
                Value<String?> endReason = const Value.absent(),
                Value<String> symptomsJson = const Value.absent(),
                Value<int> revision = const Value.absent(),
                required int updatedAtUtcMs,
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FastingSessionsCompanion.insert(
                id: id,
                planId: planId,
                startedAtUtcMs: startedAtUtcMs,
                targetMinutes: targetMinutes,
                timezoneName: timezoneName,
                endedAtUtcMs: endedAtUtcMs,
                endReason: endReason,
                symptomsJson: symptomsJson,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FastingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FastingSessionsTable,
      FastingSession,
      $$FastingSessionsTableFilterComposer,
      $$FastingSessionsTableOrderingComposer,
      $$FastingSessionsTableAnnotationComposer,
      $$FastingSessionsTableCreateCompanionBuilder,
      $$FastingSessionsTableUpdateCompanionBuilder,
      (
        FastingSession,
        BaseReferences<_$AppDatabase, $FastingSessionsTable, FastingSession>,
      ),
      FastingSession,
      PrefetchHooks Function()
    >;
typedef $$WaterEntriesTableCreateCompanionBuilder =
    WaterEntriesCompanion Function({
      required String id,
      Value<String?> sessionId,
      required int milliliters,
      required int loggedAtUtcMs,
      Value<int> revision,
      required int updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$WaterEntriesTableUpdateCompanionBuilder =
    WaterEntriesCompanion Function({
      Value<String> id,
      Value<String?> sessionId,
      Value<int> milliliters,
      Value<int> loggedAtUtcMs,
      Value<int> revision,
      Value<int> updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$WaterEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableFilterComposer({
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

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get milliliters => $composableBuilder(
    column: $table.milliliters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loggedAtUtcMs => $composableBuilder(
    column: $table.loggedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get milliliters => $composableBuilder(
    column: $table.milliliters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loggedAtUtcMs => $composableBuilder(
    column: $table.loggedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get milliliters => $composableBuilder(
    column: $table.milliliters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get loggedAtUtcMs => $composableBuilder(
    column: $table.loggedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$WaterEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterEntriesTable,
          WaterEntry,
          $$WaterEntriesTableFilterComposer,
          $$WaterEntriesTableOrderingComposer,
          $$WaterEntriesTableAnnotationComposer,
          $$WaterEntriesTableCreateCompanionBuilder,
          $$WaterEntriesTableUpdateCompanionBuilder,
          (
            WaterEntry,
            BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>,
          ),
          WaterEntry,
          PrefetchHooks Function()
        > {
  $$WaterEntriesTableTableManager(_$AppDatabase db, $WaterEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<int> milliliters = const Value.absent(),
                Value<int> loggedAtUtcMs = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaterEntriesCompanion(
                id: id,
                sessionId: sessionId,
                milliliters: milliliters,
                loggedAtUtcMs: loggedAtUtcMs,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> sessionId = const Value.absent(),
                required int milliliters,
                required int loggedAtUtcMs,
                Value<int> revision = const Value.absent(),
                required int updatedAtUtcMs,
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaterEntriesCompanion.insert(
                id: id,
                sessionId: sessionId,
                milliliters: milliliters,
                loggedAtUtcMs: loggedAtUtcMs,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterEntriesTable,
      WaterEntry,
      $$WaterEntriesTableFilterComposer,
      $$WaterEntriesTableOrderingComposer,
      $$WaterEntriesTableAnnotationComposer,
      $$WaterEntriesTableCreateCompanionBuilder,
      $$WaterEntriesTableUpdateCompanionBuilder,
      (
        WaterEntry,
        BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>,
      ),
      WaterEntry,
      PrefetchHooks Function()
    >;
typedef $$WeightEntriesTableCreateCompanionBuilder =
    WeightEntriesCompanion Function({
      required String id,
      required double kilograms,
      required int loggedAtUtcMs,
      Value<String?> note,
      Value<int> revision,
      required int updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$WeightEntriesTableUpdateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<String> id,
      Value<double> kilograms,
      Value<int> loggedAtUtcMs,
      Value<String?> note,
      Value<int> revision,
      Value<int> updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$WeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableFilterComposer({
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

  ColumnFilters<double> get kilograms => $composableBuilder(
    column: $table.kilograms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loggedAtUtcMs => $composableBuilder(
    column: $table.loggedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableOrderingComposer({
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

  ColumnOrderings<double> get kilograms => $composableBuilder(
    column: $table.kilograms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loggedAtUtcMs => $composableBuilder(
    column: $table.loggedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get kilograms =>
      $composableBuilder(column: $table.kilograms, builder: (column) => column);

  GeneratedColumn<int> get loggedAtUtcMs => $composableBuilder(
    column: $table.loggedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$WeightEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightEntriesTable,
          WeightEntry,
          $$WeightEntriesTableFilterComposer,
          $$WeightEntriesTableOrderingComposer,
          $$WeightEntriesTableAnnotationComposer,
          $$WeightEntriesTableCreateCompanionBuilder,
          $$WeightEntriesTableUpdateCompanionBuilder,
          (
            WeightEntry,
            BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>,
          ),
          WeightEntry,
          PrefetchHooks Function()
        > {
  $$WeightEntriesTableTableManager(_$AppDatabase db, $WeightEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> kilograms = const Value.absent(),
                Value<int> loggedAtUtcMs = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightEntriesCompanion(
                id: id,
                kilograms: kilograms,
                loggedAtUtcMs: loggedAtUtcMs,
                note: note,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double kilograms,
                required int loggedAtUtcMs,
                Value<String?> note = const Value.absent(),
                Value<int> revision = const Value.absent(),
                required int updatedAtUtcMs,
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightEntriesCompanion.insert(
                id: id,
                kilograms: kilograms,
                loggedAtUtcMs: loggedAtUtcMs,
                note: note,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightEntriesTable,
      WeightEntry,
      $$WeightEntriesTableFilterComposer,
      $$WeightEntriesTableOrderingComposer,
      $$WeightEntriesTableAnnotationComposer,
      $$WeightEntriesTableCreateCompanionBuilder,
      $$WeightEntriesTableUpdateCompanionBuilder,
      (
        WeightEntry,
        BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>,
      ),
      WeightEntry,
      PrefetchHooks Function()
    >;
typedef $$DailyHealthLogsTableCreateCompanionBuilder =
    DailyHealthLogsCompanion Function({
      required String id,
      required String dateKey,
      Value<String> timezoneName,
      Value<int> calories,
      Value<int> steps,
      Value<int> revision,
      required int updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$DailyHealthLogsTableUpdateCompanionBuilder =
    DailyHealthLogsCompanion Function({
      Value<String> id,
      Value<String> dateKey,
      Value<String> timezoneName,
      Value<int> calories,
      Value<int> steps,
      Value<int> revision,
      Value<int> updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$DailyHealthLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyHealthLogsTable> {
  $$DailyHealthLogsTableFilterComposer({
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

  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezoneName => $composableBuilder(
    column: $table.timezoneName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyHealthLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyHealthLogsTable> {
  $$DailyHealthLogsTableOrderingComposer({
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

  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezoneName => $composableBuilder(
    column: $table.timezoneName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyHealthLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyHealthLogsTable> {
  $$DailyHealthLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<String> get timezoneName => $composableBuilder(
    column: $table.timezoneName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$DailyHealthLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyHealthLogsTable,
          DailyHealthLog,
          $$DailyHealthLogsTableFilterComposer,
          $$DailyHealthLogsTableOrderingComposer,
          $$DailyHealthLogsTableAnnotationComposer,
          $$DailyHealthLogsTableCreateCompanionBuilder,
          $$DailyHealthLogsTableUpdateCompanionBuilder,
          (
            DailyHealthLog,
            BaseReferences<
              _$AppDatabase,
              $DailyHealthLogsTable,
              DailyHealthLog
            >,
          ),
          DailyHealthLog,
          PrefetchHooks Function()
        > {
  $$DailyHealthLogsTableTableManager(
    _$AppDatabase db,
    $DailyHealthLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyHealthLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyHealthLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyHealthLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dateKey = const Value.absent(),
                Value<String> timezoneName = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyHealthLogsCompanion(
                id: id,
                dateKey: dateKey,
                timezoneName: timezoneName,
                calories: calories,
                steps: steps,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dateKey,
                Value<String> timezoneName = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<int> revision = const Value.absent(),
                required int updatedAtUtcMs,
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyHealthLogsCompanion.insert(
                id: id,
                dateKey: dateKey,
                timezoneName: timezoneName,
                calories: calories,
                steps: steps,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyHealthLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyHealthLogsTable,
      DailyHealthLog,
      $$DailyHealthLogsTableFilterComposer,
      $$DailyHealthLogsTableOrderingComposer,
      $$DailyHealthLogsTableAnnotationComposer,
      $$DailyHealthLogsTableCreateCompanionBuilder,
      $$DailyHealthLogsTableUpdateCompanionBuilder,
      (
        DailyHealthLog,
        BaseReferences<_$AppDatabase, $DailyHealthLogsTable, DailyHealthLog>,
      ),
      DailyHealthLog,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      Value<String?> email,
      required String displayName,
      Value<bool> isGuest,
      required int createdAtUtcMs,
      Value<int> revision,
      required int updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String?> email,
      Value<String> displayName,
      Value<bool> isGuest,
      Value<int> createdAtUtcMs,
      Value<int> revision,
      Value<int> updatedAtUtcMs,
      Value<int?> deletedAtUtcMs,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGuest => $composableBuilder(
    column: $table.isGuest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGuest => $composableBuilder(
    column: $table.isGuest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isGuest =>
      $composableBuilder(column: $table.isGuest, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtcMs => $composableBuilder(
    column: $table.deletedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> isGuest = const Value.absent(),
                Value<int> createdAtUtcMs = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                email: email,
                displayName: displayName,
                isGuest: isGuest,
                createdAtUtcMs: createdAtUtcMs,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> email = const Value.absent(),
                required String displayName,
                Value<bool> isGuest = const Value.absent(),
                required int createdAtUtcMs,
                Value<int> revision = const Value.absent(),
                required int updatedAtUtcMs,
                Value<int?> deletedAtUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                email: email,
                displayName: displayName,
                isGuest: isGuest,
                createdAtUtcMs: createdAtUtcMs,
                revision: revision,
                updatedAtUtcMs: updatedAtUtcMs,
                deletedAtUtcMs: deletedAtUtcMs,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$OnboardingProfilesTableCreateCompanionBuilder =
    OnboardingProfilesCompanion Function({
      required String id,
      Value<int> currentStep,
      Value<bool> completed,
      Value<String> answersJson,
      required int updatedAtUtcMs,
      Value<int> rowid,
    });
typedef $$OnboardingProfilesTableUpdateCompanionBuilder =
    OnboardingProfilesCompanion Function({
      Value<String> id,
      Value<int> currentStep,
      Value<bool> completed,
      Value<String> answersJson,
      Value<int> updatedAtUtcMs,
      Value<int> rowid,
    });

class $$OnboardingProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $OnboardingProfilesTable> {
  $$OnboardingProfilesTableFilterComposer({
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

  ColumnFilters<int> get currentStep => $composableBuilder(
    column: $table.currentStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OnboardingProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $OnboardingProfilesTable> {
  $$OnboardingProfilesTableOrderingComposer({
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

  ColumnOrderings<int> get currentStep => $composableBuilder(
    column: $table.currentStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OnboardingProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OnboardingProfilesTable> {
  $$OnboardingProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentStep => $composableBuilder(
    column: $table.currentStep,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );
}

class $$OnboardingProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OnboardingProfilesTable,
          OnboardingProfile,
          $$OnboardingProfilesTableFilterComposer,
          $$OnboardingProfilesTableOrderingComposer,
          $$OnboardingProfilesTableAnnotationComposer,
          $$OnboardingProfilesTableCreateCompanionBuilder,
          $$OnboardingProfilesTableUpdateCompanionBuilder,
          (
            OnboardingProfile,
            BaseReferences<
              _$AppDatabase,
              $OnboardingProfilesTable,
              OnboardingProfile
            >,
          ),
          OnboardingProfile,
          PrefetchHooks Function()
        > {
  $$OnboardingProfilesTableTableManager(
    _$AppDatabase db,
    $OnboardingProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnboardingProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnboardingProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OnboardingProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> currentStep = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnboardingProfilesCompanion(
                id: id,
                currentStep: currentStep,
                completed: completed,
                answersJson: answersJson,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> currentStep = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
                required int updatedAtUtcMs,
                Value<int> rowid = const Value.absent(),
              }) => OnboardingProfilesCompanion.insert(
                id: id,
                currentStep: currentStep,
                completed: completed,
                answersJson: answersJson,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OnboardingProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OnboardingProfilesTable,
      OnboardingProfile,
      $$OnboardingProfilesTableFilterComposer,
      $$OnboardingProfilesTableOrderingComposer,
      $$OnboardingProfilesTableAnnotationComposer,
      $$OnboardingProfilesTableCreateCompanionBuilder,
      $$OnboardingProfilesTableUpdateCompanionBuilder,
      (
        OnboardingProfile,
        BaseReferences<
          _$AppDatabase,
          $OnboardingProfilesTable,
          OnboardingProfile
        >,
      ),
      OnboardingProfile,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      required int updatedAtUtcMs,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> updatedAtUtcMs,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required int updatedAtUtcMs,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$SyncOperationsTableCreateCompanionBuilder =
    SyncOperationsCompanion Function({
      required String id,
      required String idempotencyKey,
      required String entityType,
      required String entityId,
      required String operation,
      Value<int> baseRevision,
      required String payloadJson,
      Value<String> status,
      Value<int> attempts,
      required int createdAtUtcMs,
      Value<int?> nextAttemptAtUtcMs,
      Value<int> rowid,
    });
typedef $$SyncOperationsTableUpdateCompanionBuilder =
    SyncOperationsCompanion Function({
      Value<String> id,
      Value<String> idempotencyKey,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<int> baseRevision,
      Value<String> payloadJson,
      Value<String> status,
      Value<int> attempts,
      Value<int> createdAtUtcMs,
      Value<int?> nextAttemptAtUtcMs,
      Value<int> rowid,
    });

class $$SyncOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableFilterComposer({
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

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseRevision => $composableBuilder(
    column: $table.baseRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextAttemptAtUtcMs => $composableBuilder(
    column: $table.nextAttemptAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableOrderingComposer({
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

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseRevision => $composableBuilder(
    column: $table.baseRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextAttemptAtUtcMs => $composableBuilder(
    column: $table.nextAttemptAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<int> get baseRevision => $composableBuilder(
    column: $table.baseRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextAttemptAtUtcMs => $composableBuilder(
    column: $table.nextAttemptAtUtcMs,
    builder: (column) => column,
  );
}

class $$SyncOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOperationsTable,
          SyncOperation,
          $$SyncOperationsTableFilterComposer,
          $$SyncOperationsTableOrderingComposer,
          $$SyncOperationsTableAnnotationComposer,
          $$SyncOperationsTableCreateCompanionBuilder,
          $$SyncOperationsTableUpdateCompanionBuilder,
          (
            SyncOperation,
            BaseReferences<_$AppDatabase, $SyncOperationsTable, SyncOperation>,
          ),
          SyncOperation,
          PrefetchHooks Function()
        > {
  $$SyncOperationsTableTableManager(
    _$AppDatabase db,
    $SyncOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<int> baseRevision = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> createdAtUtcMs = const Value.absent(),
                Value<int?> nextAttemptAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsCompanion(
                id: id,
                idempotencyKey: idempotencyKey,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                baseRevision: baseRevision,
                payloadJson: payloadJson,
                status: status,
                attempts: attempts,
                createdAtUtcMs: createdAtUtcMs,
                nextAttemptAtUtcMs: nextAttemptAtUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idempotencyKey,
                required String entityType,
                required String entityId,
                required String operation,
                Value<int> baseRevision = const Value.absent(),
                required String payloadJson,
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                required int createdAtUtcMs,
                Value<int?> nextAttemptAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsCompanion.insert(
                id: id,
                idempotencyKey: idempotencyKey,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                baseRevision: baseRevision,
                payloadJson: payloadJson,
                status: status,
                attempts: attempts,
                createdAtUtcMs: createdAtUtcMs,
                nextAttemptAtUtcMs: nextAttemptAtUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOperationsTable,
      SyncOperation,
      $$SyncOperationsTableFilterComposer,
      $$SyncOperationsTableOrderingComposer,
      $$SyncOperationsTableAnnotationComposer,
      $$SyncOperationsTableCreateCompanionBuilder,
      $$SyncOperationsTableUpdateCompanionBuilder,
      (
        SyncOperation,
        BaseReferences<_$AppDatabase, $SyncOperationsTable, SyncOperation>,
      ),
      SyncOperation,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FastingPlansTableTableManager get fastingPlans =>
      $$FastingPlansTableTableManager(_db, _db.fastingPlans);
  $$FastingSessionsTableTableManager get fastingSessions =>
      $$FastingSessionsTableTableManager(_db, _db.fastingSessions);
  $$WaterEntriesTableTableManager get waterEntries =>
      $$WaterEntriesTableTableManager(_db, _db.waterEntries);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db, _db.weightEntries);
  $$DailyHealthLogsTableTableManager get dailyHealthLogs =>
      $$DailyHealthLogsTableTableManager(_db, _db.dailyHealthLogs);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$OnboardingProfilesTableTableManager get onboardingProfiles =>
      $$OnboardingProfilesTableTableManager(_db, _db.onboardingProfiles);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$SyncOperationsTableTableManager get syncOperations =>
      $$SyncOperationsTableTableManager(_db, _db.syncOperations);
}
