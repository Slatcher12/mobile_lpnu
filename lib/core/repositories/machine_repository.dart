import '../models/coffee_machine.dart';

abstract class MachineRepository {
  Future<List<CoffeeMachine>> getByUserId(String userId);

  Future<void> add(CoffeeMachine machine);

  Future<void> update(CoffeeMachine machine);

  Future<void> delete(String id);

  Future<void> deleteByUserId(String userId);
}
