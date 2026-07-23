import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../../core/contracts.dart';

class MockAuthService implements AuthService {
  MockAuthService(this._storage);

  static const _sessionKey = 'lighter.mock.auth.session';
  final FlutterSecureStorage _storage;
  final Uuid _uuid = const Uuid();

  @override
  Future<AuthSession?> restore() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AuthSession(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      isMock: true,
    );
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String displayName,
    required String password,
  }) async {
    _validate(email, password);
    final session = AuthSession(
      userId: _uuid.v7(),
      displayName: displayName.trim().isEmpty
          ? 'Lighter user'
          : displayName.trim(),
      email: email.trim().toLowerCase(),
      isMock: true,
    );
    await _persist(session);
    return session;
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    _validate(email, password);
    final session = AuthSession(
      userId: _uuid.v7(),
      displayName: email.split('@').first,
      email: email.trim().toLowerCase(),
      isMock: true,
    );
    await _persist(session);
    return session;
  }

  @override
  Future<void> logout() => _storage.delete(key: _sessionKey);

  void _validate(String email, String password) {
    if (!email.contains('@') || email.trim().length < 5) {
      throw const FormatException('Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw const FormatException('Password must be at least 6 characters.');
    }
  }

  Future<void> _persist(AuthSession session) => _storage.write(
    key: _sessionKey,
    value: jsonEncode({
      'userId': session.userId,
      'displayName': session.displayName,
      'email': session.email,
      'isMock': true,
    }),
  );
}
