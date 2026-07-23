import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lighter/data/database/app_database.dart';
import 'package:lighter/data/repositories/app_repository.dart';

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
}
