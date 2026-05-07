import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/models/user.dart';
import '../core/repositories/auth_repository.dart';
import '../core/repositories/machine_repository.dart';
import '../core/repositories/user_repository.dart';
import '../core/services/mqtt_service.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _auth;
  final UserRepository _users;
  final MachineRepository _machines;
  final MqttService _mqtt;

  AuthCubit(this._auth, this._users, this._machines, this._mqtt)
    : super(AuthInitial());

  void init(User? user) =>
      emit(user != null ? AuthAuthenticated(user) : AuthUnauthenticated());

  void updateUser(User user) => emit(AuthAuthenticated(user));

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final user = await _auth.login(email: email, password: password);
    emit(
      user != null
          ? AuthAuthenticated(user)
          : AuthError('Invalid email or password'),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final user = await _auth.register(
      name: name,
      email: email,
      password: password,
    );
    emit(
      user != null
          ? AuthAuthenticated(user)
          : AuthError('Registration failed. Check connection or try another email.'),
    );
  }

  Future<void> signOut() async {
    await _mqtt.disconnect();
    await _auth.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> deleteAccount(String userId) async {
    await _mqtt.disconnect();
    await _machines.deleteByUserId(userId);
    await _users.delete(userId);
    await _auth.logout();
    emit(AuthUnauthenticated());
  }
}
