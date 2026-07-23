class AuthSession {
  const AuthSession({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.isMock,
  });

  final String userId;
  final String displayName;
  final String email;
  final bool isMock;
}

abstract interface class AuthService {
  Future<AuthSession?> restore();
  Future<AuthSession> register({
    required String email,
    required String displayName,
    required String password,
  });
  Future<AuthSession> login({required String email, required String password});
  Future<void> logout();
}

class SyncEnvelope {
  const SyncEnvelope({required this.cursor, required this.changes});
  final String? cursor;
  final List<Map<String, Object?>> changes;
}

abstract interface class RemoteDataSource {
  Future<SyncEnvelope> pull({String? cursor});
  Future<void> push(List<Map<String, Object?>> operations);
}

abstract interface class SyncCoordinator {
  Future<void> synchronize();
}

enum HealthReadStatus { ready, permissionRequired, unavailable, error }

class StepReadResult {
  const StepReadResult({
    required this.status,
    this.steps,
    this.synchronizedAt,
    this.debugMessage,
  });

  final HealthReadStatus status;
  final int? steps;
  final DateTime? synchronizedAt;
  final String? debugMessage;
}

abstract interface class HealthDataSource {
  Future<StepReadResult> readTodaySteps({required bool requestAuthorization});
}

enum TaskGoalType { check, count, duration, distance }

enum DailyTaskKind { water, calories, weight, steps, custom }

DailyTaskKind dailyTaskKindFromWire(String value) =>
    DailyTaskKind.values.where((kind) => kind.name == value).firstOrNull ??
    DailyTaskKind.custom;

TaskGoalType taskGoalTypeFromWire(String value) =>
    TaskGoalType.values.where((type) => type.name == value).firstOrNull ??
    TaskGoalType.check;

class TaskSchedule {
  const TaskSchedule._();

  static const everyDay = 0x7F;
  static const workdays = 0x1F;
  static const weekend = 0x60;

  static bool includesWeekday(int mask, int weekday) {
    if (weekday < DateTime.monday || weekday > DateTime.sunday) return false;
    return mask & (1 << (weekday - 1)) != 0;
  }

  static int toggleWeekday(int mask, int weekday) =>
      mask ^ (1 << (weekday - 1));
}

class MockRemoteDataSource implements RemoteDataSource {
  const MockRemoteDataSource();

  @override
  Future<SyncEnvelope> pull({String? cursor}) async =>
      SyncEnvelope(cursor: cursor, changes: const []);

  @override
  Future<void> push(List<Map<String, Object?>> operations) async {}
}

class DeferredSyncCoordinator implements SyncCoordinator {
  const DeferredSyncCoordinator();

  @override
  Future<void> synchronize() async {
    // Network synchronization is intentionally disabled in the local MVP.
  }
}
