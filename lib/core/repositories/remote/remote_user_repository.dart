import '../../../core/repositories/local/user_store.dart';
import '../../models/user.dart';
import '../user_repository.dart';
import 'api_client.dart';

class RemoteUserRepository implements UserRepository {
  final ApiClient _client;
  final UserStore _store;

  const RemoteUserRepository(this._client, this._store);

  @override
  Future<User?> getById(String id) async {
    try {
      final data = await _client.get('/users/$id');
      final raw = data as Map<String, dynamic>;
      final user = User(
        id: raw['id'] as String,
        name: raw['name'] as String,
        email: raw['email'] as String,
        password: _localPassword(id),
      );
      await _syncLocal(user);
      return user;
    } catch (_) {
      try {
        return _store.getAll().firstWhere((u) => u.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<void> update(User user) async {
    try {
      await _client.put('/users/${user.id}', {
        'name': user.name,
        'email': user.email,
      });
      await _syncLocal(user);
    } catch (_) {
      await _syncLocal(user);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _client.delete('/users/$id');
    } catch (_) {}
    final users = _store.getAll()..removeWhere((u) => u.id == id);
    await _store.saveAll(users);
  }

  String _localPassword(String id) {
    try {
      return _store.getAll().firstWhere((u) => u.id == id).password;
    } catch (_) {
      return '';
    }
  }

  Future<void> _syncLocal(User user) async {
    final users = _store.getAll();
    final idx = users.indexWhere((u) => u.id == user.id);
    if (idx >= 0) {
      users[idx] = user;
    } else {
      users.add(user);
    }
    await _store.saveAll(users);
  }
}
