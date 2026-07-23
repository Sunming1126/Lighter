import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/contracts.dart';
import '../database/app_database.dart';
import '../services/health_data_service.dart';

class AppRepository {
  AppRepository(this.db, {HealthDataSource? healthDataSource})
    : healthDataSource =
          healthDataSource ?? const UnavailableHealthDataSource();

  final AppDatabase db;
  final Uuid _uuid = const Uuid();
  final HealthDataSource healthDataSource;

  Stream<FastingSession?> watchActiveSession() => db.watchActiveSession();
  Stream<List<FastingSession>> watchSessions() => db.watchSessions();
  Stream<List<WeightEntry>> watchWeights() => db.watchWeights();
  Stream<FastingPlan?> watchPlan() => db.watchActivePlan();
  Stream<List<WaterEntry>> watchWater(String sessionId) =>
      db.watchWaterForSession(sessionId);
  Stream<List<WaterEntry>> watchWaterForDay(DateTime localDay) {
    final start = DateTime(localDay.year, localDay.month, localDay.day);
    final end = start.add(const Duration(days: 1));
    return db.watchWaterForRange(
      start.toUtc().millisecondsSinceEpoch,
      end.toUtc().millisecondsSinceEpoch,
    );
  }

  Stream<DailyHealthLog?> watchDailyHealth(String dateKey) =>
      db.watchDailyHealth(dateKey);
  Stream<List<CalorieEntry>> watchCalories(String dateKey) =>
      db.watchCaloriesForDay(dateKey);
  Stream<List<DailyTask>> watchDailyTasks() => db.watchDailyTasks();
  Stream<List<TaskProgressEntry>> watchTaskProgress(String dateKey) =>
      db.watchTaskProgressForDay(dateKey);
  Future<List<DailyTask>> getDailyTasks() => db.getDailyTasks();

  Future<FastingPlan> ensureDefaultPlan({int startMinuteOfDay = 1200}) async {
    final existing = await db.activePlan();
    if (existing != null) return existing;
    final now = _now;
    final id = _uuid.v7();
    final timezone = await getPreference('timezone') ?? 'UTC';
    final row = FastingPlansCompanion.insert(
      id: id,
      startMinuteOfDay: Value(startMinuteOfDay),
      timezoneName: Value(timezone),
      updatedAtUtcMs: now,
    );
    await db.transaction(() async {
      await db.into(db.fastingPlans).insert(row);
      await _enqueue('fasting_plan', id, 'upsert', 0, {
        'id': id,
        'fastMinutes': 720,
        'eatingMinutes': 720,
        'startMinuteOfDay': startMinuteOfDay,
        'timezone': timezone,
        'active': true,
        'paused': false,
        'updatedAtUtcMs': now,
      });
    });
    return (await db.activePlan())!;
  }

  Future<void> updatePlan({
    required int fastMinutes,
    required int startMinuteOfDay,
    bool? paused,
  }) async {
    final plan = await ensureDefaultPlan();
    final now = _now;
    final nextRevision = plan.revision + 1;
    await db.transaction(() async {
      await (db.update(
        db.fastingPlans,
      )..where((row) => row.id.equals(plan.id))).write(
        FastingPlansCompanion(
          fastMinutes: Value(fastMinutes),
          eatingMinutes: Value(1440 - fastMinutes),
          startMinuteOfDay: Value(startMinuteOfDay),
          paused: paused == null ? const Value.absent() : Value(paused),
          revision: Value(nextRevision),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue('fasting_plan', plan.id, 'upsert', plan.revision, {
        'id': plan.id,
        'fastMinutes': fastMinutes,
        'eatingMinutes': 1440 - fastMinutes,
        'startMinuteOfDay': startMinuteOfDay,
        'paused': paused ?? plan.paused,
        'revision': nextRevision,
        'updatedAtUtcMs': now,
      });
    });
  }

  Future<FastingSession> startFast({
    DateTime? start,
    int? targetMinutes,
  }) async {
    final active = await db.activeSession();
    if (active != null) return active;
    final plan = await ensureDefaultPlan();
    final now = _now;
    final id = _uuid.v7();
    final started = (start ?? DateTime.now()).toUtc().millisecondsSinceEpoch;
    final target = targetMinutes ?? plan.fastMinutes;
    await db.transaction(() async {
      await db
          .into(db.fastingSessions)
          .insert(
            FastingSessionsCompanion.insert(
              id: id,
              planId: Value(plan.id),
              startedAtUtcMs: started,
              targetMinutes: target,
              timezoneName: Value(plan.timezoneName),
              updatedAtUtcMs: now,
            ),
          );
      await _enqueue('fasting_session', id, 'upsert', 0, {
        'id': id,
        'planId': plan.id,
        'startedAtUtcMs': started,
        'targetMinutes': target,
        'timezone': plan.timezoneName,
        'updatedAtUtcMs': now,
      });
    });
    return (await db.activeSession())!;
  }

  Future<void> adjustActiveFast({
    required DateTime start,
    required int targetMinutes,
  }) async {
    final session = await db.activeSession();
    if (session == null) return;
    final now = _now;
    final nextRevision = session.revision + 1;
    await db.transaction(() async {
      await (db.update(
        db.fastingSessions,
      )..where((row) => row.id.equals(session.id))).write(
        FastingSessionsCompanion(
          startedAtUtcMs: Value(start.toUtc().millisecondsSinceEpoch),
          targetMinutes: Value(targetMinutes),
          revision: Value(nextRevision),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue(
        'fasting_session',
        session.id,
        'upsert',
        session.revision,
        {
          'id': session.id,
          'startedAtUtcMs': start.toUtc().millisecondsSinceEpoch,
          'targetMinutes': targetMinutes,
          'revision': nextRevision,
          'updatedAtUtcMs': now,
        },
      );
    });
  }

  Future<void> endFast({
    String reason = 'manual',
    List<String> symptoms = const [],
  }) async {
    final session = await db.activeSession();
    if (session == null) return;
    final now = _now;
    final nextRevision = session.revision + 1;
    await db.transaction(() async {
      await (db.update(
        db.fastingSessions,
      )..where((row) => row.id.equals(session.id))).write(
        FastingSessionsCompanion(
          endedAtUtcMs: Value(now),
          endReason: Value(reason),
          symptomsJson: Value(jsonEncode(symptoms)),
          revision: Value(nextRevision),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue(
        'fasting_session',
        session.id,
        'upsert',
        session.revision,
        {
          'id': session.id,
          'endedAtUtcMs': now,
          'endReason': reason,
          'symptoms': symptoms,
          'revision': nextRevision,
          'updatedAtUtcMs': now,
        },
      );
    });
  }

  Future<void> addWater({String? sessionId, int milliliters = 250}) async {
    if (milliliters < 10 || milliliters > 5000) {
      throw const FormatException('Please enter a realistic water amount.');
    }
    final now = _now;
    final id = _uuid.v7();
    final actualSessionId = sessionId ?? (await db.activeSession())?.id;
    await db.transaction(() async {
      await db
          .into(db.waterEntries)
          .insert(
            WaterEntriesCompanion.insert(
              id: id,
              sessionId: Value(actualSessionId),
              milliliters: milliliters,
              loggedAtUtcMs: now,
              updatedAtUtcMs: now,
            ),
          );
      await _enqueue('water_entry', id, 'upsert', 0, {
        'id': id,
        'sessionId': actualSessionId,
        'milliliters': milliliters,
        'loggedAtUtcMs': now,
        'updatedAtUtcMs': now,
      });
    });
  }

  Future<bool> undoLatestWaterForDay(DateTime localDay) async {
    final start = DateTime(localDay.year, localDay.month, localDay.day);
    final end = start.add(const Duration(days: 1));
    final latest = await db.latestWaterForRange(
      start.toUtc().millisecondsSinceEpoch,
      end.toUtc().millisecondsSinceEpoch,
    );
    if (latest == null) return false;
    final now = _now;
    await db.transaction(() async {
      await (db.update(
        db.waterEntries,
      )..where((row) => row.id.equals(latest.id))).write(
        WaterEntriesCompanion(
          deletedAtUtcMs: Value(now),
          updatedAtUtcMs: Value(now),
          revision: Value(latest.revision + 1),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue('water_entry', latest.id, 'delete', latest.revision, {
        'id': latest.id,
        'revision': latest.revision + 1,
        'deletedAtUtcMs': now,
        'updatedAtUtcMs': now,
      });
    });
    return true;
  }

  Future<void> addWeight({required double kilograms, DateTime? at}) async {
    if (kilograms < 25 || kilograms > 350) {
      throw const FormatException('Please enter a realistic weight.');
    }
    final now = _now;
    final loggedAt = (at ?? DateTime.now()).toUtc().millisecondsSinceEpoch;
    final id = _uuid.v7();
    await db.transaction(() async {
      await db
          .into(db.weightEntries)
          .insert(
            WeightEntriesCompanion.insert(
              id: id,
              kilograms: kilograms,
              loggedAtUtcMs: loggedAt,
              updatedAtUtcMs: now,
            ),
          );
      await _enqueue('weight_entry', id, 'upsert', 0, {
        'id': id,
        'kilograms': kilograms,
        'loggedAtUtcMs': loggedAt,
        'updatedAtUtcMs': now,
      });
    });
  }

  Future<void> setDailyHealth({
    required String dateKey,
    int? calories,
    int? steps,
    String? stepSource,
    int? stepsSyncedAtUtcMs,
  }) async {
    if (calories != null && (calories < 0 || calories > 20000)) {
      throw const FormatException('Please enter realistic calories.');
    }
    if (steps != null && (steps < 0 || steps > 200000)) {
      throw const FormatException('Please enter realistic steps.');
    }
    await db.transaction(
      () => _upsertDailyHealth(
        dateKey: dateKey,
        calories: calories,
        steps: steps,
        stepSource: stepSource,
        stepsSyncedAtUtcMs: stepsSyncedAtUtcMs,
      ),
    );
  }

  Future<void> _upsertDailyHealth({
    required String dateKey,
    int? calories,
    int? steps,
    String? stepSource,
    int? stepsSyncedAtUtcMs,
  }) async {
    final existing = await db.dailyHealth(dateKey);
    final now = _now;
    final timezone = await getPreference('timezone') ?? 'UTC';
    if (existing == null) {
      final id = _uuid.v7();
      final source = stepSource ?? 'manual';
      await db
          .into(db.dailyHealthLogs)
          .insert(
            DailyHealthLogsCompanion.insert(
              id: id,
              dateKey: dateKey,
              timezoneName: Value(timezone),
              calories: Value(calories ?? 0),
              steps: Value(steps ?? 0),
              stepSource: Value(source),
              stepsSyncedAtUtcMs: Value(stepsSyncedAtUtcMs),
              updatedAtUtcMs: now,
            ),
          );
      await _enqueue('daily_health_log', id, 'upsert', 0, {
        'id': id,
        'dateKey': dateKey,
        'timezone': timezone,
        'calories': calories ?? 0,
        'steps': steps ?? 0,
        'stepSource': source,
        'stepsSyncedAtUtcMs': stepsSyncedAtUtcMs,
        'revision': 1,
        'updatedAtUtcMs': now,
      });
      return;
    }
    final nextRevision = existing.revision + 1;
    final nextCalories = calories ?? existing.calories;
    final nextSteps = steps ?? existing.steps;
    final nextSource = stepSource ?? existing.stepSource;
    final nextSyncedAt = stepsSyncedAtUtcMs ?? existing.stepsSyncedAtUtcMs;
    await (db.update(
      db.dailyHealthLogs,
    )..where((row) => row.id.equals(existing.id))).write(
      DailyHealthLogsCompanion(
        calories: Value(nextCalories),
        steps: Value(nextSteps),
        stepSource: Value(nextSource),
        stepsSyncedAtUtcMs: Value(nextSyncedAt),
        revision: Value(nextRevision),
        updatedAtUtcMs: Value(now),
        syncStatus: const Value('pending'),
      ),
    );
    await _enqueue(
      'daily_health_log',
      existing.id,
      'upsert',
      existing.revision,
      {
        'id': existing.id,
        'dateKey': dateKey,
        'timezone': existing.timezoneName,
        'calories': nextCalories,
        'steps': nextSteps,
        'stepSource': nextSource,
        'stepsSyncedAtUtcMs': nextSyncedAt,
        'revision': nextRevision,
        'updatedAtUtcMs': now,
      },
    );
  }

  Future<void> addCalorie({
    required String dateKey,
    required String mealType,
    required int calories,
    DateTime? at,
  }) async {
    _validateCalorie(mealType, calories);
    final id = _uuid.v7();
    final now = _now;
    final timezone = await getPreference('timezone') ?? 'UTC';
    final loggedAt = (at ?? DateTime.now()).toUtc().millisecondsSinceEpoch;
    await db.transaction(() async {
      await db
          .into(db.calorieEntries)
          .insert(
            CalorieEntriesCompanion.insert(
              id: id,
              dateKey: dateKey,
              mealType: mealType,
              calories: calories,
              loggedAtUtcMs: loggedAt,
              timezoneName: Value(timezone),
              updatedAtUtcMs: now,
            ),
          );
      await _enqueue('calorie_entry', id, 'upsert', 0, {
        'id': id,
        'dateKey': dateKey,
        'mealType': mealType,
        'calories': calories,
        'loggedAtUtcMs': loggedAt,
        'timezone': timezone,
        'revision': 1,
        'updatedAtUtcMs': now,
      });
      await _refreshCalorieTotal(dateKey);
    });
  }

  Future<void> updateCalorie({
    required String id,
    required String mealType,
    required int calories,
  }) async {
    _validateCalorie(mealType, calories);
    final entry = await (db.select(
      db.calorieEntries,
    )..where((row) => row.id.equals(id))).getSingle();
    final now = _now;
    await db.transaction(() async {
      await (db.update(
        db.calorieEntries,
      )..where((row) => row.id.equals(id))).write(
        CalorieEntriesCompanion(
          mealType: Value(mealType),
          calories: Value(calories),
          revision: Value(entry.revision + 1),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue('calorie_entry', id, 'upsert', entry.revision, {
        'id': id,
        'dateKey': entry.dateKey,
        'mealType': mealType,
        'calories': calories,
        'loggedAtUtcMs': entry.loggedAtUtcMs,
        'revision': entry.revision + 1,
        'updatedAtUtcMs': now,
      });
      await _refreshCalorieTotal(entry.dateKey);
    });
  }

  Future<void> deleteCalorie(String id) async {
    final entry = await (db.select(
      db.calorieEntries,
    )..where((row) => row.id.equals(id))).getSingle();
    final now = _now;
    await db.transaction(() async {
      await (db.update(
        db.calorieEntries,
      )..where((row) => row.id.equals(id))).write(
        CalorieEntriesCompanion(
          revision: Value(entry.revision + 1),
          updatedAtUtcMs: Value(now),
          deletedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue('calorie_entry', id, 'delete', entry.revision, {
        'id': id,
        'revision': entry.revision + 1,
        'deletedAtUtcMs': now,
        'updatedAtUtcMs': now,
      });
      await _refreshCalorieTotal(entry.dateKey);
    });
  }

  Future<void> _refreshCalorieTotal(String dateKey) async {
    final entries = await db.caloriesForDay(dateKey);
    final total = entries.fold<int>(0, (sum, item) => sum + item.calories);
    await _upsertDailyHealth(dateKey: dateKey, calories: total);
  }

  void _validateCalorie(String mealType, int calories) {
    const types = {'breakfast', 'lunch', 'dinner', 'snack', 'uncategorized'};
    if (!types.contains(mealType) || calories < 1 || calories > 10000) {
      throw const FormatException('Please enter realistic calories.');
    }
  }

  Future<void> ensureDefaultDailyTasks() async {
    if (await getPreference('dailyTaskSeedVersion') == '1') return;
    final current = await db.getDailyTasks();
    final existingKinds = current.map((task) => task.kind).toSet();
    final missing = _systemTaskSeeds
        .where((seed) => !existingKinds.contains(seed.kind.name))
        .toList();
    final now = _now;
    await db.transaction(() async {
      for (var index = 0; index < current.length; index += 1) {
        final task = current[index];
        final nextSortOrder = index + missing.length;
        if (task.sortOrder == nextSortOrder) continue;
        await (db.update(
          db.dailyTasks,
        )..where((row) => row.id.equals(task.id))).write(
          DailyTasksCompanion(
            sortOrder: Value(nextSortOrder),
            revision: Value(task.revision + 1),
            updatedAtUtcMs: Value(now),
            syncStatus: const Value('pending'),
          ),
        );
        await _enqueue('daily_task', task.id, 'upsert', task.revision, {
          'id': task.id,
          'kind': task.kind,
          'sortOrder': nextSortOrder,
          'revision': task.revision + 1,
          'updatedAtUtcMs': now,
        });
      }
      for (var index = 0; index < missing.length; index += 1) {
        await _insertSystemTask(missing[index], index, now);
      }
      await db.putSetting('dailyTaskSeedVersion', '1');
    });
  }

  Future<DailyTask> createCustomTask({
    required String title,
    required String iconKey,
    required String colorKey,
    required TaskGoalType goalType,
    required double targetValue,
    required String unit,
    required double quickIncrement,
    required int weekdaysMask,
    int? reminderMinute,
  }) async {
    _validateTask(
      title: title,
      targetValue: targetValue,
      quickIncrement: quickIncrement,
      weekdaysMask: weekdaysMask,
      reminderMinute: reminderMinute,
    );
    final id = _uuid.v7();
    final now = _now;
    final tasks = await db.getDailyTasks();
    if (tasks.length >= 10) throw StateError('daily_task_limit');
    final sortOrder = tasks.isEmpty
        ? 0
        : tasks.map((task) => task.sortOrder).reduce((a, b) => a > b ? a : b) +
              1;
    final normalizedTarget = goalType == TaskGoalType.check ? 1.0 : targetValue;
    final normalizedIncrement = goalType == TaskGoalType.check
        ? 1.0
        : quickIncrement;
    await db.transaction(() async {
      await db
          .into(db.dailyTasks)
          .insert(
            DailyTasksCompanion.insert(
              id: id,
              kind: const Value('custom'),
              title: title.trim(),
              iconKey: iconKey,
              colorKey: colorKey,
              goalType: goalType.name,
              targetValue: normalizedTarget,
              unit: unit,
              quickIncrement: normalizedIncrement,
              weekdaysMask: Value(weekdaysMask),
              reminderMinute: Value(reminderMinute),
              sortOrder: Value(sortOrder),
              createdAtUtcMs: now,
              updatedAtUtcMs: now,
            ),
          );
      await _enqueue('daily_task', id, 'upsert', 0, {
        'id': id,
        'kind': 'custom',
        'title': title.trim(),
        'iconKey': iconKey,
        'colorKey': colorKey,
        'goalType': goalType.name,
        'targetValue': normalizedTarget,
        'unit': unit,
        'quickIncrement': normalizedIncrement,
        'weekdaysMask': weekdaysMask,
        'reminderMinute': reminderMinute,
        'sortOrder': sortOrder,
        'enabled': true,
        'createdAtUtcMs': now,
        'revision': 1,
        'updatedAtUtcMs': now,
      });
    });
    return (await db.dailyTask(id))!;
  }

  Future<DailyTask> updateCustomTask({
    required String id,
    required String title,
    required String iconKey,
    required String colorKey,
    required TaskGoalType goalType,
    required double targetValue,
    required String unit,
    required double quickIncrement,
    required int weekdaysMask,
    int? reminderMinute,
  }) async {
    _validateTask(
      title: title,
      targetValue: targetValue,
      quickIncrement: quickIncrement,
      weekdaysMask: weekdaysMask,
      reminderMinute: reminderMinute,
    );
    final task = await db.dailyTask(id);
    if (task == null || task.deletedAtUtcMs != null) {
      throw StateError('task_not_found');
    }
    if (task.kind != DailyTaskKind.custom.name) {
      throw StateError('system_task_not_editable');
    }
    final now = _now;
    final nextRevision = task.revision + 1;
    final normalizedTarget = goalType == TaskGoalType.check ? 1.0 : targetValue;
    final normalizedIncrement = goalType == TaskGoalType.check
        ? 1.0
        : quickIncrement;
    await db.transaction(() async {
      await (db.update(db.dailyTasks)..where((row) => row.id.equals(id))).write(
        DailyTasksCompanion(
          title: Value(title.trim()),
          iconKey: Value(iconKey),
          colorKey: Value(colorKey),
          goalType: Value(goalType.name),
          targetValue: Value(normalizedTarget),
          unit: Value(unit),
          quickIncrement: Value(normalizedIncrement),
          weekdaysMask: Value(weekdaysMask),
          reminderMinute: Value(reminderMinute),
          revision: Value(nextRevision),
          updatedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue('daily_task', id, 'upsert', task.revision, {
        'id': id,
        'kind': task.kind,
        'title': title.trim(),
        'iconKey': iconKey,
        'colorKey': colorKey,
        'goalType': goalType.name,
        'targetValue': normalizedTarget,
        'unit': unit,
        'quickIncrement': normalizedIncrement,
        'weekdaysMask': weekdaysMask,
        'reminderMinute': reminderMinute,
        'sortOrder': task.sortOrder,
        'enabled': task.enabled,
        'revision': nextRevision,
        'updatedAtUtcMs': now,
      });
    });
    return (await db.dailyTask(id))!;
  }

  Future<DailyTask> addSystemTask(DailyTaskKind kind) async {
    if (kind == DailyTaskKind.custom) throw StateError('invalid_system_task');
    final active = await db.getDailyTasks();
    if (active.any((task) => task.kind == kind.name)) {
      throw StateError('task_already_added');
    }
    if (active.length >= 10) throw StateError('daily_task_limit');
    final seed = _systemTaskSeeds.firstWhere((item) => item.kind == kind);
    final existing = await db.dailyTaskByKind(kind.name);
    final now = _now;
    final sortOrder = active.isEmpty
        ? 0
        : active.map((task) => task.sortOrder).reduce((a, b) => a > b ? a : b) +
              1;
    if (existing == null) {
      final id = await db.transaction(() async {
        final insertedId = _uuid.v7();
        await _insertSystemTask(seed, sortOrder, now, id: insertedId);
        return insertedId;
      });
      return (await db.dailyTask(id))!;
    }
    final nextRevision = existing.revision + 1;
    await db.transaction(() async {
      await (db.update(
        db.dailyTasks,
      )..where((row) => row.id.equals(existing.id))).write(
        DailyTasksCompanion(
          title: Value(seed.title),
          iconKey: Value(seed.iconKey),
          colorKey: Value(seed.colorKey),
          goalType: Value(seed.goalType.name),
          targetValue: Value(seed.targetValue),
          unit: Value(seed.unit),
          quickIncrement: Value(seed.quickIncrement),
          weekdaysMask: const Value(TaskSchedule.everyDay),
          reminderMinute: const Value(null),
          sortOrder: Value(sortOrder),
          enabled: const Value(true),
          revision: Value(nextRevision),
          updatedAtUtcMs: Value(now),
          deletedAtUtcMs: const Value(null),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue('daily_task', existing.id, 'upsert', existing.revision, {
        'id': existing.id,
        'kind': kind.name,
        'title': seed.title,
        'iconKey': seed.iconKey,
        'colorKey': seed.colorKey,
        'goalType': seed.goalType.name,
        'targetValue': seed.targetValue,
        'unit': seed.unit,
        'quickIncrement': seed.quickIncrement,
        'weekdaysMask': TaskSchedule.everyDay,
        'reminderMinute': null,
        'sortOrder': sortOrder,
        'enabled': true,
        'revision': nextRevision,
        'updatedAtUtcMs': now,
      });
    });
    return (await db.dailyTask(existing.id))!;
  }

  Future<void> reorderDailyTasks(List<String> orderedIds) async {
    final tasks = await db.getDailyTasks();
    final byId = {for (final task in tasks) task.id: task};
    final now = _now;
    await db.transaction(() async {
      for (var index = 0; index < orderedIds.length; index += 1) {
        final task = byId[orderedIds[index]];
        if (task == null || task.sortOrder == index) continue;
        await (db.update(
          db.dailyTasks,
        )..where((row) => row.id.equals(task.id))).write(
          DailyTasksCompanion(
            sortOrder: Value(index),
            revision: Value(task.revision + 1),
            updatedAtUtcMs: Value(now),
            syncStatus: const Value('pending'),
          ),
        );
        await _enqueue('daily_task', task.id, 'upsert', task.revision, {
          'id': task.id,
          'kind': task.kind,
          'sortOrder': index,
          'revision': task.revision + 1,
          'updatedAtUtcMs': now,
        });
      }
    });
  }

  Future<void> deleteDailyTask(String id) async {
    final task = await db.dailyTask(id);
    if (task == null || task.deletedAtUtcMs != null) return;
    final kind = dailyTaskKindFromWire(task.kind);
    if (kind == DailyTaskKind.water || kind == DailyTaskKind.calories) {
      throw StateError('fixed_daily_task');
    }
    final now = _now;
    await db.transaction(() async {
      await (db.update(db.dailyTasks)..where((row) => row.id.equals(id))).write(
        DailyTasksCompanion(
          enabled: const Value(false),
          revision: Value(task.revision + 1),
          updatedAtUtcMs: Value(now),
          deletedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue('daily_task', id, 'delete', task.revision, {
        'id': id,
        'kind': task.kind,
        'revision': task.revision + 1,
        'deletedAtUtcMs': now,
        'updatedAtUtcMs': now,
      });
    });
  }

  Future<void> _insertSystemTask(
    _SystemTaskSeed seed,
    int sortOrder,
    int now, {
    String? id,
  }) async {
    final taskId = id ?? _uuid.v7();
    await db
        .into(db.dailyTasks)
        .insert(
          DailyTasksCompanion.insert(
            id: taskId,
            kind: Value(seed.kind.name),
            title: seed.title,
            iconKey: seed.iconKey,
            colorKey: seed.colorKey,
            goalType: seed.goalType.name,
            targetValue: seed.targetValue,
            unit: seed.unit,
            quickIncrement: seed.quickIncrement,
            weekdaysMask: const Value(TaskSchedule.everyDay),
            sortOrder: Value(sortOrder),
            createdAtUtcMs: now,
            updatedAtUtcMs: now,
          ),
        );
    await _enqueue('daily_task', taskId, 'upsert', 0, {
      'id': taskId,
      'kind': seed.kind.name,
      'title': seed.title,
      'iconKey': seed.iconKey,
      'colorKey': seed.colorKey,
      'goalType': seed.goalType.name,
      'targetValue': seed.targetValue,
      'unit': seed.unit,
      'quickIncrement': seed.quickIncrement,
      'weekdaysMask': TaskSchedule.everyDay,
      'reminderMinute': null,
      'sortOrder': sortOrder,
      'enabled': true,
      'createdAtUtcMs': now,
      'revision': 1,
      'updatedAtUtcMs': now,
    });
  }

  Future<TaskProgressEntry?> addTaskProgress({
    required String taskId,
    required String dateKey,
    required double deltaValue,
    DateTime? at,
  }) async {
    final task = await db.dailyTask(taskId);
    if (task == null || task.deletedAtUtcMs != null || !task.enabled) {
      throw StateError('task_not_available');
    }
    if (task.kind != DailyTaskKind.custom.name) {
      throw StateError('system_task_progress_is_derived');
    }
    if (!deltaValue.isFinite || deltaValue <= 0 || deltaValue > 100000) {
      throw const FormatException('Please enter realistic task progress.');
    }
    final entries = await db.taskProgressForDay(dateKey);
    final current = entries
        .where((entry) => entry.taskId == taskId)
        .fold<double>(0, (sum, entry) => sum + entry.deltaValue);
    if (task.goalType == TaskGoalType.check.name &&
        current >= task.targetValue) {
      return null;
    }
    final id = _uuid.v7();
    final now = _now;
    final loggedAt = (at ?? DateTime.now()).toUtc().millisecondsSinceEpoch;
    final timezone = await getPreference('timezone') ?? 'UTC';
    final normalizedDelta = task.goalType == TaskGoalType.check.name
        ? 1.0
        : deltaValue;
    await db.transaction(() async {
      await db
          .into(db.taskProgressEntries)
          .insert(
            TaskProgressEntriesCompanion.insert(
              id: id,
              taskId: taskId,
              dateKey: dateKey,
              deltaValue: normalizedDelta,
              goalSnapshot: task.targetValue,
              unitSnapshot: task.unit,
              loggedAtUtcMs: loggedAt,
              timezoneName: Value(timezone),
              updatedAtUtcMs: now,
            ),
          );
      await _enqueue('task_progress_entry', id, 'upsert', 0, {
        'id': id,
        'taskId': taskId,
        'dateKey': dateKey,
        'deltaValue': normalizedDelta,
        'goalSnapshot': task.targetValue,
        'unitSnapshot': task.unit,
        'loggedAtUtcMs': loggedAt,
        'timezone': timezone,
        'revision': 1,
        'updatedAtUtcMs': now,
      });
    });
    return (await (db.select(
      db.taskProgressEntries,
    )..where((row) => row.id.equals(id))).getSingle());
  }

  Future<bool> undoLatestTaskProgress({
    required String taskId,
    required String dateKey,
  }) async {
    final latest = await db.latestTaskProgress(taskId, dateKey);
    if (latest == null) return false;
    final now = _now;
    await db.transaction(() async {
      await (db.update(
        db.taskProgressEntries,
      )..where((row) => row.id.equals(latest.id))).write(
        TaskProgressEntriesCompanion(
          revision: Value(latest.revision + 1),
          updatedAtUtcMs: Value(now),
          deletedAtUtcMs: Value(now),
          syncStatus: const Value('pending'),
        ),
      );
      await _enqueue(
        'task_progress_entry',
        latest.id,
        'delete',
        latest.revision,
        {
          'id': latest.id,
          'revision': latest.revision + 1,
          'deletedAtUtcMs': now,
          'updatedAtUtcMs': now,
        },
      );
    });
    return true;
  }

  void _validateTask({
    required String title,
    required double targetValue,
    required double quickIncrement,
    required int weekdaysMask,
    required int? reminderMinute,
  }) {
    if (title.trim().isEmpty || title.trim().length > 30) {
      throw const FormatException('Task names must be 1 to 30 characters.');
    }
    if (!targetValue.isFinite || targetValue <= 0 || targetValue > 100000) {
      throw const FormatException('Please enter a realistic task target.');
    }
    if (!quickIncrement.isFinite ||
        quickIncrement <= 0 ||
        quickIncrement > 100000) {
      throw const FormatException('Please enter a realistic quick amount.');
    }
    if (weekdaysMask < 1 || weekdaysMask > TaskSchedule.everyDay) {
      throw const FormatException('Choose at least one weekday.');
    }
    if (reminderMinute != null &&
        (reminderMinute < 0 || reminderMinute >= 1440)) {
      throw const FormatException('Reminder time is invalid.');
    }
  }

  Future<StepReadResult> syncTodaySteps({
    bool requestPermission = false,
  }) async {
    final alreadyRequested =
        await getPreference('healthStepsPermissionRequested') == 'true';
    if (!requestPermission && !alreadyRequested) {
      return const StepReadResult(status: HealthReadStatus.permissionRequired);
    }
    if (requestPermission) {
      await setPreference('healthStepsPermissionRequested', 'true');
    }
    final result = await healthDataSource.readTodaySteps(
      requestAuthorization: requestPermission,
    );
    if (result.status == HealthReadStatus.ready && result.steps != null) {
      final synchronizedAt = result.synchronizedAt ?? DateTime.now().toUtc();
      final now = DateTime.now();
      final dateKey =
          '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';
      await setDailyHealth(
        dateKey: dateKey,
        steps: result.steps,
        stepSource: 'healthkit',
        stepsSyncedAtUtcMs: synchronizedAt.millisecondsSinceEpoch,
      );
    }
    return result;
  }

  Future<void> saveOnboarding({
    required int currentStep,
    required bool completed,
    required Map<String, Object?> answers,
  }) async {
    await db
        .into(db.onboardingProfiles)
        .insertOnConflictUpdate(
          OnboardingProfilesCompanion.insert(
            id: 'local',
            currentStep: Value(currentStep),
            completed: Value(completed),
            answersJson: Value(jsonEncode(answers)),
            updatedAtUtcMs: _now,
          ),
        );
  }

  Future<OnboardingProfile?> loadOnboarding() => (db.select(
    db.onboardingProfiles,
  )..where((row) => row.id.equals('local'))).getSingleOrNull();

  Future<void> setPreference(String key, String value) =>
      db.putSetting(key, value);
  Future<String?> getPreference(String key) => db.getSetting(key);
  Future<Map<String, Object?>> exportSnapshot() => db.exportSnapshot();
  Future<void> clearLocalData() => db.clearUserData(now: _now);

  Future<void> _enqueue(
    String entityType,
    String entityId,
    String operation,
    int baseRevision,
    Map<String, Object?> payload,
  ) {
    final opId = _uuid.v7();
    return db.enqueue(
      id: opId,
      idempotencyKey:
          '$entityType:$entityId:$operation:${payload['revision'] ?? baseRevision + 1}:${payload['updatedAtUtcMs']}',
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      baseRevision: baseRevision,
      payload: payload,
      now: _now,
    );
  }

  int get _now => DateTime.now().toUtc().millisecondsSinceEpoch;
}

class _SystemTaskSeed {
  const _SystemTaskSeed({
    required this.kind,
    required this.title,
    required this.iconKey,
    required this.colorKey,
    required this.goalType,
    required this.targetValue,
    required this.unit,
    required this.quickIncrement,
  });

  final DailyTaskKind kind;
  final String title;
  final String iconKey;
  final String colorKey;
  final TaskGoalType goalType;
  final double targetValue;
  final String unit;
  final double quickIncrement;
}

const _systemTaskSeeds = <_SystemTaskSeed>[
  _SystemTaskSeed(
    kind: DailyTaskKind.water,
    title: 'Water',
    iconKey: 'water',
    colorKey: 'blue',
    goalType: TaskGoalType.count,
    targetValue: 2000,
    unit: 'ml',
    quickIncrement: 250,
  ),
  _SystemTaskSeed(
    kind: DailyTaskKind.calories,
    title: 'Calories',
    iconKey: 'calories',
    colorKey: 'emerald',
    goalType: TaskGoalType.count,
    targetValue: 1,
    unit: 'kcal',
    quickIncrement: 100,
  ),
  _SystemTaskSeed(
    kind: DailyTaskKind.weight,
    title: 'Weight',
    iconKey: 'weight',
    colorKey: 'teal',
    goalType: TaskGoalType.check,
    targetValue: 1,
    unit: 'done',
    quickIncrement: 1,
  ),
  _SystemTaskSeed(
    kind: DailyTaskKind.steps,
    title: 'Steps',
    iconKey: 'steps',
    colorKey: 'amber',
    goalType: TaskGoalType.count,
    targetValue: 8000,
    unit: 'steps',
    quickIncrement: 1000,
  ),
];
