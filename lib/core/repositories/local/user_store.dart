import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class UserStore {
  final SharedPreferences _prefs;
  static const _key = 'users';

  const UserStore(this._prefs);

  List<User> getAll() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    return User.listFromJson(raw);
  }

  Future<void> saveAll(List<User> users) async {
    await _prefs.setString(
      _key,
      jsonEncode(users.map((u) => u.toJson()).toList()),
    );
  }
}
