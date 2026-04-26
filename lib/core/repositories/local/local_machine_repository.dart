import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/coffee_machine.dart';
import '../machine_repository.dart';

class LocalMachineRepository implements MachineRepository {
  final SharedPreferences _prefs;
  static const _key = 'machines';

  const LocalMachineRepository(this._prefs);

  List<CoffeeMachine> _getAll() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    return CoffeeMachine.listFromJson(raw);
  }

  Future<void> _saveAll(List<CoffeeMachine> machines) async {
    await _prefs.setString(
      _key,
      jsonEncode(machines.map((m) => m.toJson()).toList()),
    );
  }

  @override
  Future<List<CoffeeMachine>> getByUserId(String userId) async =>
      _getAll().where((m) => m.userId == userId).toList();

  @override
  Future<void> add(CoffeeMachine machine) async =>
      _saveAll([..._getAll(), machine]);

  @override
  Future<void> update(CoffeeMachine machine) async {
    final all = _getAll();
    final index = all.indexWhere((m) => m.id == machine.id);
    if (index == -1) return;
    await _saveAll(List<CoffeeMachine>.from(all)..[index] = machine);
  }

  @override
  Future<void> delete(String id) async =>
      _saveAll(_getAll().where((m) => m.id != id).toList());

  @override
  Future<void> deleteByUserId(String userId) async =>
      _saveAll(_getAll().where((m) => m.userId != userId).toList());
}
