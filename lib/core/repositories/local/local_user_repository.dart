import '../../models/user.dart';
import '../user_repository.dart';
import 'user_store.dart';

class LocalUserRepository implements UserRepository {
  final UserStore _store;

  const LocalUserRepository(this._store);

  @override
  Future<User?> getById(String id) async {
    try {
      return _store.getAll().firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> update(User user) async {
    final users = _store.getAll();
    final index = users.indexWhere((u) => u.id == user.id);
    if (index == -1) return;
    await _store.saveAll(List<User>.from(users)..[index] = user);
  }

  @override
  Future<void> delete(String id) async {
    await _store.saveAll(_store.getAll().where((u) => u.id != id).toList());
  }
}
