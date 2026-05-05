import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../auth_repository.dart';
import '../local/user_store.dart';
import 'api_client.dart';

class RemoteAuthRepository implements AuthRepository {
  final ApiClient _client;
  final SharedPreferences _prefs;
  final UserStore _store;

  static const _tokenKey = 'auth_token';
  static const _currentKey = 'current_user_id';

  const RemoteAuthRepository(this._client, this._prefs, this._store);

  void initToken() {
    final t = _prefs.getString(_tokenKey);
    if (t != null) _client.setToken(t);
  }

  @override
  Future<User?> getCurrentUser() async {
    initToken();
    final id = _prefs.getString(_currentKey);
    if (id == null) return null;
    try {
      return _store.getAll().firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final data = await _client.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });
      return await _handleResponse(data, password);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<User?> login({required String email, required String password}) async {
    try {
      final data = await _client.post('/auth/login', {
        'email': email,
        'password': password,
      });
      return await _handleResponse(data, password);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_currentKey);
    _client.setToken(null);
  }

  Future<User> _handleResponse(dynamic data, String password) async {
    final raw = data['user'] as Map<String, dynamic>;
    final user = User(
      id: raw['id'] as String,
      name: raw['name'] as String,
      email: raw['email'] as String,
      password: password,
    );
    _client.setToken(data['token'] as String);
    await _prefs.setString(_tokenKey, data['token'] as String);
    final users = _store.getAll();
    final idx = users.indexWhere((u) => u.id == user.id);
    if (idx >= 0) {
      users[idx] = user;
    } else {
      users.add(user);
    }
    await _store.saveAll(users);
    await _prefs.setString(_currentKey, user.id);
    return user;
  }
}
