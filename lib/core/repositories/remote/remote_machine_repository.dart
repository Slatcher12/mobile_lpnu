import 'package:shared_preferences/shared_preferences.dart';

import '../../models/coffee_machine.dart';
import '../local/local_machine_repository.dart';
import '../machine_repository.dart';
import 'api_client.dart';

class RemoteMachineRepository implements MachineRepository {
  final ApiClient _client;
  final LocalMachineRepository _local;

  RemoteMachineRepository(this._client, SharedPreferences prefs)
    : _local = LocalMachineRepository(prefs);

  @override
  Future<List<CoffeeMachine>> getByUserId(String userId) async {
    try {
      final data = await _client.get('/machines', query: {'userId': userId});
      final machines = (data as List)
          .map((e) => CoffeeMachine.fromJson(e as Map<String, dynamic>))
          .toList();
      await _cacheForUser(userId, machines);
      return machines;
    } catch (_) {
      return _local.getByUserId(userId);
    }
  }

  @override
  Future<void> add(CoffeeMachine machine) async {
    try {
      await _client.post('/machines', machine.toJson());
    } catch (_) {
      await _local.add(machine);
    }
  }

  @override
  Future<void> update(CoffeeMachine machine) async {
    try {
      await _client.put('/machines/${machine.id}', machine.toJson());
    } catch (_) {
      await _local.update(machine);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _client.delete('/machines/$id');
    } catch (_) {
      await _local.delete(id);
    }
  }

  @override
  Future<void> deleteByUserId(String userId) async {
    try {
      final machines = await getByUserId(userId);
      await Future.wait(
        machines.map((m) => _client.delete('/machines/${m.id}')),
      );
    } catch (_) {
      await _local.deleteByUserId(userId);
    }
  }

  Future<void> _cacheForUser(
    String userId,
    List<CoffeeMachine> machines,
  ) async {
    await _local.deleteByUserId(userId);
    for (final m in machines) {
      await _local.add(m);
    }
  }
}
