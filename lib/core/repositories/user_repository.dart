import '../models/user.dart';

abstract class UserRepository {
  Future<User?> getById(String id);

  Future<void> update(User user);

  Future<void> delete(String id);
}
