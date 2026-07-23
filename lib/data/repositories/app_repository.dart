import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class AppRepository {
  AppRepository(this.db, [this._uuid = const Uuid()]);

  final AppDatabase db;
  final Uuid _uuid;

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
  }) async {
    if (calories != null && (calories < 0 || calories > 20000)) {
      throw const FormatException('Please enter realistic calories.');
    }
    if (steps != null && (steps < 0 || steps > 200000)) {
      throw const FormatException('Please enter realistic steps.');
    }
    final existing = await db.dailyHealth(dateKey);
    final now = _now;
    final timezone = await getPreference('timezone') ?? 'UTC';
    if (existing == null) {
      final id = _uuid.v7();
      await db.transaction(() async {
        await db
            .into(db.dailyHealthLogs)
            .insert(
              DailyHealthLogsCompanion.insert(
                id: id,
                dateKey: dateKey,
                timezoneName: Value(timezone),
                calories: Value(calories ?? 0),
                steps: Value(steps ?? 0),
                updatedAtUtcMs: now,
              ),
            );
        await _enqueue('daily_health_log', id, 'upsert', 0, {
          'id': id,
          'dateKey': dateKey,
          'timezone': timezone,
          'calories': calories ?? 0,
          'steps': steps ?? 0,
          'revision': 1,
          'updatedAtUtcMs': now,
        });
      });
      return;
    }
    final nextRevision = existing.revision + 1;
    final nextCalories = calories ?? existing.calories;
    final nextSteps = steps ?? existing.steps;
    await db.transaction(() async {
      await (db.update(
        db.dailyHealthLogs,
      )..where((row) => row.id.equals(existing.id))).write(
        DailyHealthLogsCompanion(
          calories: Value(nextCalories),
          steps: Value(nextSteps),
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
          'revision': nextRevision,
          'updatedAtUtcMs': now,
        },
      );
    });
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
          '$entityType:$entityId:$operation:${payload['updatedAtUtcMs']}',
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
