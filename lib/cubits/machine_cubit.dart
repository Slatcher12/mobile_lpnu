import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/models/coffee_machine.dart';
import '../core/repositories/machine_repository.dart';

sealed class MachineState {}

class MachineInitial extends MachineState {}

class MachineLoading extends MachineState {}

class MachineLoaded extends MachineState {
  final List<CoffeeMachine> machines;
  MachineLoaded(this.machines);
}

class MachineError extends MachineState {
  final String message;
  MachineError(this.message);
}

class MachineCubit extends Cubit<MachineState> {
  final MachineRepository _repo;
  String _userId = '';

  MachineCubit(this._repo) : super(MachineInitial());

  Future<void> load(String userId) async {
    _userId = userId;
    emit(MachineLoading());
    try {
      emit(MachineLoaded(await _repo.getByUserId(userId)));
    } catch (_) {
      emit(MachineError('Failed to load machines'));
    }
  }

  Future<void> add(CoffeeMachine machine) async {
    await _repo.add(machine);
    await load(_userId);
  }

  Future<void> update(CoffeeMachine machine) async {
    await _repo.update(machine);
    await load(_userId);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    await load(_userId);
  }
}
