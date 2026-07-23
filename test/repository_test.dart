import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lighter/core/contracts.dart';
import 'package:lighter/data/database/app_database.dart';
import 'package:lighter/data/repositories/app_repository.dart';
import 'package:lighter/data/services/health_data_service.dart';

void main() {
  late AppDatabase database;
  late AppRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = AppRepository(database);
  });

  tearDown(() => database.close());

  test(
    'starting twice returns one active session and one durable record',
    () async {
      final first = await repository.startFast(
        start: DateTime.utc(2026, 7, 22, 12),
      );
      final second = await repository.startFast(
        start: DateTime.utc(2026, 7, 22, 13),
      );

      expect(second.id, first.id);
      expect(
        await database.select(database.fastingSessions).get(),
        hasLength(1),
      );
      expect(
        await database.select(database.syncOperations).get(),
        hasLength(2),
      );
    },
  );

  test(
    'ending a fast updates the entity and writes an outbox operation atomically',
    () async {
      final session = await repository.startFast(
        start: DateTime.now().subtract(const Duration(hours: 12)),
      );
      await repository.endFast(reason: 'manual');

      final stored = await (database.select(
        database.fastingSessions,
      )..where((row) => row.id.equals(session.id))).getSingle();
      expect(stored.endedAtUtcMs, isNotNull);
      expect(stored.revision, 2);
      expect(stored.syncStatus, 'pending');
      expect(
        await database.select(database.syncOperations).get(),
        hasLength(3),
      );
    },
  );

  test('weight is stored in canonical kilograms', () async {
    await repository.addWeight(kilograms: 70.25);
    final row = await database.select(database.weightEntries).getSingle();
    expect(row.kilograms, closeTo(70.25, .001));
  });

  test('plan and session retain the originating IANA timezone', () async {
    await repository.setPreference('timezone', 'Asia/Shanghai');
    final plan = await repository.ensureDefaultPlan();
    final session = await repository.startFast(
      start: DateTime.utc(2026, 7, 22, 12),
    );

    expect(plan.timezoneName, 'Asia/Shanghai');
    expect(session.timezoneName, 'Asia/Shanghai');
  });

  test(
    'clearing local data creates tombstones instead of hard deletes',
    () async {
      await repository.startFast(start: DateTime.utc(2026, 7, 22, 12));
      await repository.addWater(milliliters: 300);
      await repository.addWeight(kilograms: 68);
      await repository.setDailyHealth(
        dateKey: '2026-07-22',
        calories: 1800,
        steps: 7600,
      );

      await repository.clearLocalData();

      final sessions = await database.select(database.fastingSessions).get();
      final water = await database.select(database.waterEntries).get();
      final weights = await database.select(database.weightEntries).get();
      final health = await database.select(database.dailyHealthLogs).get();
      expect(sessions.single.deletedAtUtcMs, isNotNull);
      expect(water.single.deletedAtUtcMs, isNotNull);
      expect(weights.single.deletedAtUtcMs, isNotNull);
      expect(health.single.deletedAtUtcMs, isNotNull);
      expect(sessions.single.syncStatus, 'pending');
    },
  );

  test('daily health updates one record and writes outbox revisions', () async {
    await repository.setPreference('timezone', 'Asia/Shanghai');
    await repository.setDailyHealth(dateKey: '2026-07-23', calories: 1200);
    await repository.setDailyHealth(dateKey: '2026-07-23', steps: 8000);

    final rows = await database.select(database.dailyHealthLogs).get();
    expect(rows, hasLength(1));
    expect(rows.single.calories, 1200);
    expect(rows.single.steps, 8000);
    expect(rows.single.timezoneName, 'Asia/Shanghai');
    expect(rows.single.revision, 2);
    expect(await database.select(database.syncOperations).get(), hasLength(2));
  });

  test('water undo soft deletes only the latest entry for today', () async {
    await repository.addWater(milliliters: 250);
    await repository.addWater(milliliters: 350);

    expect(await repository.undoLatestWaterForDay(DateTime.now()), isTrue);

    final rows = await database.select(database.waterEntries).get();
    expect(rows, hasLength(2));
    expect(rows.where((row) => row.deletedAtUtcMs == null), hasLength(1));
    expect(
      rows.singleWhere((row) => row.deletedAtUtcMs == null).milliliters,
      250,
    );
  });

  test(
    'calorie entries keep meal detail and refresh the daily total',
    () async {
      await repository.addCalorie(
        dateKey: '2026-07-23',
        mealType: 'breakfast',
        calories: 420,
      );
      await repository.addCalorie(
        dateKey: '2026-07-23',
        mealType: 'lunch',
        calories: 650,
      );

      var entries = await database.caloriesForDay('2026-07-23');
      expect(entries.map((entry) => entry.mealType), ['breakfast', 'lunch']);
      expect((await database.dailyHealth('2026-07-23'))?.calories, 1070);

      await repository.deleteCalorie(entries.first.id);
      entries = await database.caloriesForDay('2026-07-23');
      expect(entries.single.mealType, 'lunch');
      expect((await database.dailyHealth('2026-07-23'))?.calories, 650);
    },
  );

  test(
    'HealthKit step sync replaces manual fallback instead of adding it',
    () async {
      repository = AppRepository(
        database,
        healthDataSource: const MockHealthDataSource(steps: 8123),
      );
      await repository.setDailyHealth(
        dateKey: localTodayKey(),
        steps: 1200,
        stepSource: 'manual',
      );

      await repository.syncTodaySteps(requestPermission: true);

      final health = await database.dailyHealth(localTodayKey());
      expect(health?.steps, 8123);
      expect(health?.stepSource, 'healthkit');
      expect(health?.stepsSyncedAtUtcMs, isNotNull);
    },
  );

  test('daily tasks seed once and enforce a ten-task limit', () async {
    await repository.ensureDefaultDailyTasks();
    await repository.ensureDefaultDailyTasks();
    expect(await database.getDailyTasks(), hasLength(4));

    for (var index = 0; index < 6; index += 1) {
      await createTask(repository, title: 'Task $index');
    }

    expect(
      () => createTask(repository, title: 'Task 10'),
      throwsA(isA<StateError>()),
    );
    expect(await database.getDailyTasks(), hasLength(10));
  });

  test('fixed health tasks cannot be deleted but remain sortable', () async {
    await repository.ensureDefaultDailyTasks();
    final tasks = await database.getDailyTasks();
    final water = tasks.singleWhere(
      (task) => task.kind == DailyTaskKind.water.name,
    );
    final calories = tasks.singleWhere(
      (task) => task.kind == DailyTaskKind.calories.name,
    );

    expect(
      () => repository.deleteDailyTask(water.id),
      throwsA(isA<StateError>()),
    );
    expect(
      () => repository.deleteDailyTask(calories.id),
      throwsA(isA<StateError>()),
    );
    await repository.reorderDailyTasks([
      calories.id,
      water.id,
      ...tasks
          .where((task) => task.id != water.id && task.id != calories.id)
          .map((task) => task.id),
    ]);
    expect((await database.getDailyTasks()).first.id, calories.id);
  });

  test(
    'removing weight only removes its card and it can be restored',
    () async {
      await repository.ensureDefaultDailyTasks();
      await repository.addWeight(kilograms: 67.4);
      final weightTask = (await database.getDailyTasks()).singleWhere(
        (task) => task.kind == DailyTaskKind.weight.name,
      );

      await repository.deleteDailyTask(weightTask.id);
      expect(
        (await database.getDailyTasks()).where(
          (task) => task.kind == DailyTaskKind.weight.name,
        ),
        isEmpty,
      );
      expect(await database.select(database.weightEntries).get(), hasLength(1));

      final restored = await repository.addSystemTask(DailyTaskKind.weight);
      expect(restored.id, weightTask.id);
      expect(restored.deletedAtUtcMs, isNull);
      expect(await database.select(database.weightEntries).get(), hasLength(1));
    },
  );

  test('removing steps does not delete the underlying health data', () async {
    await repository.ensureDefaultDailyTasks();
    await repository.setDailyHealth(
      dateKey: '2026-07-23',
      steps: 8123,
      stepSource: 'healthkit',
    );
    final stepsTask = (await database.getDailyTasks()).singleWhere(
      (task) => task.kind == DailyTaskKind.steps.name,
    );

    await repository.deleteDailyTask(stepsTask.id);

    expect((await database.dailyHealth('2026-07-23'))?.steps, 8123);
    expect((await database.dailyHealth('2026-07-23'))?.stepSource, 'healthkit');
  });

  test('task progress is additive, snapshot-safe, and undoable', () async {
    final task = await createTask(
      repository,
      title: 'Push-ups',
      goalType: TaskGoalType.count,
      target: 30,
      quick: 10,
      unit: 'reps',
    );
    await repository.addTaskProgress(
      taskId: task.id,
      dateKey: '2026-07-23',
      deltaValue: 10,
    );
    await repository.updateCustomTask(
      id: task.id,
      title: task.title,
      iconKey: task.iconKey,
      colorKey: task.colorKey,
      goalType: TaskGoalType.count,
      targetValue: 50,
      unit: task.unit,
      quickIncrement: 10,
      weekdaysMask: task.weekdaysMask,
      reminderMinute: task.reminderMinute,
    );
    await repository.addTaskProgress(
      taskId: task.id,
      dateKey: '2026-07-23',
      deltaValue: 15,
    );

    var entries = await database.taskProgressForDay('2026-07-23');
    expect(entries.map((entry) => entry.goalSnapshot), [30, 50]);
    expect(entries.fold<double>(0, (sum, entry) => sum + entry.deltaValue), 25);

    expect(
      await repository.undoLatestTaskProgress(
        taskId: task.id,
        dateKey: '2026-07-23',
      ),
      isTrue,
    );
    entries = await database.taskProgressForDay('2026-07-23');
    expect(entries.single.deltaValue, 10);
    final allEntries = await database
        .select(database.taskProgressEntries)
        .get();
    expect(
      allEntries.where((entry) => entry.deletedAtUtcMs != null),
      hasLength(1),
    );
  });

  test('check tasks cannot be recorded twice without undo', () async {
    final task = await createTask(repository, title: 'Stretch');
    final first = await repository.addTaskProgress(
      taskId: task.id,
      dateKey: '2026-07-23',
      deltaValue: 1,
    );
    final second = await repository.addTaskProgress(
      taskId: task.id,
      dateKey: '2026-07-23',
      deltaValue: 1,
    );

    expect(first, isNotNull);
    expect(second, isNull);
    expect(await database.taskProgressForDay('2026-07-23'), hasLength(1));
  });

  test('task ordering and local clear keep sync-safe tombstones', () async {
    final first = await createTask(repository, title: 'First');
    final second = await createTask(repository, title: 'Second');
    await repository.reorderDailyTasks([second.id, first.id]);
    expect((await database.getDailyTasks()).first.id, second.id);
    await repository.addTaskProgress(
      taskId: second.id,
      dateKey: '2026-07-23',
      deltaValue: 1,
    );

    await repository.clearLocalData();

    final tasks = await database.select(database.dailyTasks).get();
    final progress = await database.select(database.taskProgressEntries).get();
    expect(tasks.every((task) => task.deletedAtUtcMs != null), isTrue);
    expect(tasks.every((task) => !task.enabled), isTrue);
    expect(progress.single.deletedAtUtcMs, isNotNull);
  });
}

Future<DailyTask> createTask(
  AppRepository repository, {
  required String title,
  TaskGoalType goalType = TaskGoalType.check,
  double target = 1,
  double quick = 1,
  String unit = 'done',
}) => repository.createCustomTask(
  title: title,
  iconKey: 'star',
  colorKey: 'purple',
  goalType: goalType,
  targetValue: target,
  unit: unit,
  quickIncrement: quick,
  weekdaysMask: TaskSchedule.everyDay,
);

String localTodayKey() {
  final now = DateTime.now();
  return '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';
}
