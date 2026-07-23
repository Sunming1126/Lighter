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
