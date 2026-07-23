import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lighter/data/database/app_database.dart';

void main() {
  test('schema v4 upgrades by creating unified daily task tables', () async {
    final database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (raw) => raw.execute('PRAGMA user_version = 4'),
      ),
    );
    addTearDown(database.close);

    expect(database.schemaVersion, 6);
    expect(await database.getDailyTasks(), isEmpty);
    expect(await database.taskProgressForDay('2026-07-23'), isEmpty);
  });

  test(
    'schema v5 migrates custom tasks and pending outbox contracts',
    () async {
      final database = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (raw) {
            raw.execute('''
            CREATE TABLE custom_tasks (
              id TEXT NOT NULL PRIMARY KEY,
              title TEXT NOT NULL,
              icon_key TEXT NOT NULL,
              color_key TEXT NOT NULL,
              goal_type TEXT NOT NULL,
              target_value REAL NOT NULL,
              unit TEXT NOT NULL,
              quick_increment REAL NOT NULL,
              weekdays_mask INTEGER NOT NULL DEFAULT 127,
              reminder_minute INTEGER,
              sort_order INTEGER NOT NULL DEFAULT 0,
              enabled INTEGER NOT NULL DEFAULT 1,
              created_at_utc_ms INTEGER NOT NULL,
              revision INTEGER NOT NULL DEFAULT 1,
              updated_at_utc_ms INTEGER NOT NULL,
              deleted_at_utc_ms INTEGER,
              sync_status TEXT NOT NULL DEFAULT 'pending'
            )
          ''');
            raw.execute('''
            INSERT INTO custom_tasks (
              id, title, icon_key, color_key, goal_type, target_value, unit,
              quick_increment, created_at_utc_ms, updated_at_utc_ms
            ) VALUES (
              'task-1', 'Running', 'run', 'emerald', 'duration', 20, 'min',
              5, 100, 100
            )
          ''');
            raw.execute('''
            CREATE TABLE sync_operations (
              id TEXT NOT NULL PRIMARY KEY,
              idempotency_key TEXT NOT NULL UNIQUE,
              entity_type TEXT NOT NULL,
              entity_id TEXT NOT NULL,
              operation TEXT NOT NULL,
              base_revision INTEGER NOT NULL DEFAULT 0,
              payload_json TEXT NOT NULL,
              status TEXT NOT NULL DEFAULT 'pending',
              attempts INTEGER NOT NULL DEFAULT 0,
              created_at_utc_ms INTEGER NOT NULL,
              next_attempt_at_utc_ms INTEGER
            )
          ''');
            raw.execute('''
            INSERT INTO sync_operations (
              id, idempotency_key, entity_type, entity_id, operation,
              payload_json, created_at_utc_ms
            ) VALUES (
              'op-1', 'custom_task:task-1:upsert:100', 'custom_task',
              'task-1', 'upsert', '{"id":"task-1"}', 100
            )
          ''');
            raw.execute('PRAGMA user_version = 5');
          },
        ),
      );
      addTearDown(database.close);

      final task = (await database.getDailyTasks()).single;
      final operation =
          (await database.select(database.syncOperations).get()).single;
      expect(task.kind, 'custom');
      expect(operation.entityType, 'daily_task');
      expect(operation.payloadJson, contains('"kind":"custom"'));
    },
  );
}
