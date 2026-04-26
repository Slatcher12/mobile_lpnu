import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../auth_repository.dart';
import 'user_store.dart';

class LocalAuthRepository implements AuthRepository {
  final SharedPreferences _prefs;
  final UserStore _store;
  static const _currentKey = 'current_user_id';

  const LocalAuthRepository(this._prefs, this._store);

  @override
  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final users = _store.getAll();
    if (users.any((u) => u.email == email)) return null;
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );
    await _store.saveAll([...users, user]);
    await _prefs.setString(_currentKey, user.id);
    return user;
  }

  @override
  Future<User?> login({required String email, required String password}) async {
    final users = _store.getAll();
    try {
      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      await _prefs.setString(_currentKey, user.id);
      return user;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_currentKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final id = _prefs.getString(_currentKey);
    if (id == null) return null;
    try {
      return _store.getAll().firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }
}
