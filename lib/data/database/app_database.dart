import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class FastingPlans extends Table {
  TextColumn get id => text()();
  IntColumn get fastMinutes => integer().withDefault(const Constant(720))();
  IntColumn get eatingMinutes => integer().withDefault(const Constant(720))();
  IntColumn get startMinuteOfDay =>
      integer().withDefault(const Constant(1200))();
  TextColumn get timezoneName => text().withDefault(const Constant('UTC'))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  BoolColumn get paused => boolean().withDefault(const Constant(false))();
  IntColumn get revision => integer().withDefault(const Constant(1))();
  IntColumn get updatedAtUtcMs => integer()();
  IntColumn get deletedAtUtcMs => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class FastingSessions extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().nullable()();
  IntColumn get startedAtUtcMs => integer()();
  IntColumn get targetMinutes => integer()();
  TextColumn get timezoneName => text().withDefault(const Constant('UTC'))();
  IntColumn get endedAtUtcMs => integer().nullable()();
  TextColumn get endReason => text().nullable()();
  TextColumn get symptomsJson => text().withDefault(const Constant('[]'))();
  IntColumn get revision => integer().withDefault(const Constant(1))();
  IntColumn get updatedAtUtcMs => integer()();
  IntColumn get deletedAtUtcMs => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WaterEntries extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().nullable()();
  IntColumn get milliliters => integer()();
  IntColumn get loggedAtUtcMs => integer()();
  IntColumn get revision => integer().withDefault(const Constant(1))();
  IntColumn get updatedAtUtcMs => integer()();
  IntColumn get deletedAtUtcMs => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WeightEntries extends Table {
  TextColumn get id => text()();
  RealColumn get kilograms => real()();
  IntColumn get loggedAtUtcMs => integer()();
  TextColumn get note => text().nullable()();
  IntColumn get revision => integer().withDefault(const Constant(1))();
  IntColumn get updatedAtUtcMs => integer()();
  IntColumn get deletedAtUtcMs => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class DailyHealthLogs extends Table {
  TextColumn get id => text()();
  TextColumn get dateKey => text().unique()();
  TextColumn get timezoneName => text().withDefault(const Constant('UTC'))();
  IntColumn get calories => integer().withDefault(const Constant(0))();
  IntColumn get steps => integer().withDefault(const Constant(0))();
  IntColumn get revision => integer().withDefault(const Constant(1))();
  IntColumn get updatedAtUtcMs => integer()();
  IntColumn get deletedAtUtcMs => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().nullable()();
  TextColumn get displayName => text()();
  BoolColumn get isGuest => boolean().withDefault(const Constant(true))();
  IntColumn get createdAtUtcMs => integer()();
  IntColumn get revision => integer().withDefault(const Constant(1))();
  IntColumn get updatedAtUtcMs => integer()();
  IntColumn get deletedAtUtcMs => integer().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class OnboardingProfiles extends Table {
  TextColumn get id => text()();
  IntColumn get currentStep => integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get answersJson => text().withDefault(const Constant('{}'))();
  IntColumn get updatedAtUtcMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAtUtcMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class SyncOperations extends Table {
  TextColumn get id => text()();
  TextColumn get idempotencyKey => text().unique()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  IntColumn get baseRevision => integer().withDefault(const Constant(0))();
  TextColumn get payloadJson => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get createdAtUtcMs => integer()();
  IntColumn get nextAttemptAtUtcMs => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    FastingPlans,
    FastingSessions,
    WaterEntries,
    WeightEntries,
    DailyHealthLogs,
    UserProfiles,
    OnboardingProfiles,
    AppSettings,
    SyncOperations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(fastingPlans, fastingPlans.timezoneName);
        await m.addColumn(fastingSessions, fastingSessions.timezoneName);
      }
      if (from < 3) {
        await m.createTable(dailyHealthLogs);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );

  Stream<FastingSession?> watchActiveSession() {
    final query = select(fastingSessions)
      ..where((row) => row.endedAtUtcMs.isNull() & row.deletedAtUtcMs.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.startedAtUtcMs)])
      ..limit(1);
    return query.watchSingleOrNull();
  }

  Future<FastingSession?> activeSession() =>
      (select(fastingSessions)
            ..where(
              (row) => row.endedAtUtcMs.isNull() & row.deletedAtUtcMs.isNull(),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.startedAtUtcMs)])
            ..limit(1))
          .getSingleOrNull();

  Stream<List<FastingSession>> watchSessions() =>
      (select(fastingSessions)
            ..where((row) => row.deletedAtUtcMs.isNull())
            ..orderBy([(row) => OrderingTerm.desc(row.startedAtUtcMs)]))
          .watch();

  Stream<List<WeightEntry>> watchWeights() =>
      (select(weightEntries)
            ..where((row) => row.deletedAtUtcMs.isNull())
            ..orderBy([(row) => OrderingTerm.asc(row.loggedAtUtcMs)]))
          .watch();

  Stream<List<WaterEntry>> watchWaterForSession(String sessionId) =>
      (select(waterEntries)
            ..where(
              (row) =>
                  row.sessionId.equals(sessionId) & row.deletedAtUtcMs.isNull(),
            )
            ..orderBy([(row) => OrderingTerm.asc(row.loggedAtUtcMs)]))
          .watch();

  Stream<List<WaterEntry>> watchWaterForRange(int startUtcMs, int endUtcMs) =>
      (select(waterEntries)
            ..where(
              (row) =>
                  row.loggedAtUtcMs.isBiggerOrEqualValue(startUtcMs) &
                  row.loggedAtUtcMs.isSmallerThanValue(endUtcMs) &
                  row.deletedAtUtcMs.isNull(),
            )
            ..orderBy([(row) => OrderingTerm.asc(row.loggedAtUtcMs)]))
          .watch();

  Stream<DailyHealthLog?> watchDailyHealth(String dateKey) =>
      (select(dailyHealthLogs)
            ..where(
              (row) =>
                  row.dateKey.equals(dateKey) & row.deletedAtUtcMs.isNull(),
            )
            ..limit(1))
          .watchSingleOrNull();

  Future<DailyHealthLog?> dailyHealth(String dateKey) =>
      (select(dailyHealthLogs)
            ..where(
              (row) =>
                  row.dateKey.equals(dateKey) & row.deletedAtUtcMs.isNull(),
            )
            ..limit(1))
          .getSingleOrNull();

  Future<FastingPlan?> activePlan() =>
      (select(fastingPlans)
            ..where(
              (row) => row.active.equals(true) & row.deletedAtUtcMs.isNull(),
            )
            ..limit(1))
          .getSingleOrNull();

  Stream<FastingPlan?> watchActivePlan() =>
      (select(fastingPlans)
            ..where(
              (row) => row.active.equals(true) & row.deletedAtUtcMs.isNull(),
            )
            ..limit(1))
          .watchSingleOrNull();

  Future<void> putSetting(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(
          key: key,
          value: value,
          updatedAtUtcMs: DateTime.now().toUtc().millisecondsSinceEpoch,
        ),
      );

  Future<String?> getSetting(String key) async => (await (select(
    appSettings,
  )..where((row) => row.key.equals(key))).getSingleOrNull())?.value;

  Future<void> enqueue({
    required String id,
    required String idempotencyKey,
    required String entityType,
    required String entityId,
    required String operation,
    required int baseRevision,
    required Map<String, Object?> payload,
    required int now,
  }) => into(syncOperations).insert(
    SyncOperationsCompanion.insert(
      id: id,
      idempotencyKey: idempotencyKey,
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      baseRevision: Value(baseRevision),
      payloadJson: jsonEncode(payload),
      createdAtUtcMs: now,
    ),
    mode: InsertMode.insertOrIgnore,
  );

  Future<Map<String, Object?>> exportSnapshot() async => {
    'schemaVersion': schemaVersion,
    'exportedAt': DateTime.now().toUtc().toIso8601String(),
    'plans': (await select(fastingPlans).get()).map(_planJson).toList(),
    'sessions': (await select(
      fastingSessions,
    ).get()).map(_sessionJson).toList(),
    'waterEntries': (await select(waterEntries).get()).map(_waterJson).toList(),
    'weightEntries': (await select(
      weightEntries,
    ).get()).map(_weightJson).toList(),
    'dailyHealthLogs': (await select(
      dailyHealthLogs,
    ).get()).map(_dailyHealthJson).toList(),
    'profiles': (await select(userProfiles).get()).map(_profileJson).toList(),
    'settings': (await select(appSettings).get())
        .map(
          (row) => {
            'key': row.key,
            'value': row.value,
            'updatedAtUtcMs': row.updatedAtUtcMs,
          },
        )
        .toList(),
  };

  Future<void> clearUserData({required int now}) async {
    await transaction(() async {
      await (update(
        fastingPlans,
      )..where((row) => row.deletedAtUtcMs.isNull())).write(
        FastingPlansCompanion(
          active: const Value(false),
          deletedAtUtcMs: Value(now),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await (update(
        fastingSessions,
      )..where((row) => row.deletedAtUtcMs.isNull())).write(
        FastingSessionsCompanion(
          deletedAtUtcMs: Value(now),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await (update(
        waterEntries,
      )..where((row) => row.deletedAtUtcMs.isNull())).write(
        WaterEntriesCompanion(
          deletedAtUtcMs: Value(now),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await (update(
        weightEntries,
      )..where((row) => row.deletedAtUtcMs.isNull())).write(
        WeightEntriesCompanion(
          deletedAtUtcMs: Value(now),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await (update(
        dailyHealthLogs,
      )..where((row) => row.deletedAtUtcMs.isNull())).write(
        DailyHealthLogsCompanion(
          deletedAtUtcMs: Value(now),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await delete(appSettings).go();
      await delete(onboardingProfiles).go();
    });
  }

  Map<String, Object?> _planJson(FastingPlan row) => {
    'id': row.id,
    'fastMinutes': row.fastMinutes,
    'eatingMinutes': row.eatingMinutes,
    'startMinuteOfDay': row.startMinuteOfDay,
    'timezone': row.timezoneName,
    'active': row.active,
    'paused': row.paused,
    'revision': row.revision,
    'updatedAtUtcMs': row.updatedAtUtcMs,
    'deletedAtUtcMs': row.deletedAtUtcMs,
  };

  Map<String, Object?> _sessionJson(FastingSession row) => {
    'id': row.id,
    'planId': row.planId,
    'startedAtUtcMs': row.startedAtUtcMs,
    'targetMinutes': row.targetMinutes,
    'timezone': row.timezoneName,
    'endedAtUtcMs': row.endedAtUtcMs,
    'endReason': row.endReason,
    'symptoms': jsonDecode(row.symptomsJson),
    'revision': row.revision,
    'updatedAtUtcMs': row.updatedAtUtcMs,
    'deletedAtUtcMs': row.deletedAtUtcMs,
  };

  Map<String, Object?> _waterJson(WaterEntry row) => {
    'id': row.id,
    'sessionId': row.sessionId,
    'milliliters': row.milliliters,
    'loggedAtUtcMs': row.loggedAtUtcMs,
    'revision': row.revision,
    'updatedAtUtcMs': row.updatedAtUtcMs,
    'deletedAtUtcMs': row.deletedAtUtcMs,
  };

  Map<String, Object?> _weightJson(WeightEntry row) => {
    'id': row.id,
    'kilograms': row.kilograms,
    'loggedAtUtcMs': row.loggedAtUtcMs,
    'note': row.note,
    'revision': row.revision,
    'updatedAtUtcMs': row.updatedAtUtcMs,
    'deletedAtUtcMs': row.deletedAtUtcMs,
  };

  Map<String, Object?> _dailyHealthJson(DailyHealthLog row) => {
    'id': row.id,
    'dateKey': row.dateKey,
    'timezone': row.timezoneName,
    'calories': row.calories,
    'steps': row.steps,
    'revision': row.revision,
    'updatedAtUtcMs': row.updatedAtUtcMs,
    'deletedAtUtcMs': row.deletedAtUtcMs,
  };

  Map<String, Object?> _profileJson(UserProfile row) => {
    'id': row.id,
    'email': row.email,
    'displayName': row.displayName,
    'isGuest': row.isGuest,
    'createdAtUtcMs': row.createdAtUtcMs,
    'revision': row.revision,
    'updatedAtUtcMs': row.updatedAtUtcMs,
    'deletedAtUtcMs': row.deletedAtUtcMs,
  };
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/lighter.sqlite');
  return NativeDatabase.createInBackground(
    file,
    setup: (database) {
      database.execute('PRAGMA journal_mode = WAL');
      database.execute('PRAGMA foreign_keys = ON');
    },
  );
});
