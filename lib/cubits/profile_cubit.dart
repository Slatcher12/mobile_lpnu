import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/models/user.dart';
import '../core/repositories/user_repository.dart';

sealed class ProfileState {}

class ProfileReady extends ProfileState {
  final User user;
  final bool saving;
  final String? error;
  ProfileReady(this.user, {this.saving = false, this.error});
}

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _repo;

  ProfileCubit(this._repo, User user) : super(ProfileReady(user));

  Future<void> save(String name, String email) async {
    final current = (state as ProfileReady).user;
    emit(ProfileReady(current, saving: true));
    try {
      final updated = current.copyWith(name: name.trim(), email: email.trim());
      await _repo.update(updated);
      emit(ProfileReady(updated));
    } catch (_) {
      emit(ProfileReady(current, error: 'Failed to save'));
    }
  }
}
