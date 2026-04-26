import 'package:flutter/material.dart';

import '../core/models/user.dart';
import '../core/repositories/auth_repository.dart';
import '../core/repositories/machine_repository.dart';
import '../core/repositories/user_repository.dart';

class AppDependencies extends InheritedWidget {
  final AuthRepository authRepo;
  final UserRepository userRepo;
  final MachineRepository machineRepo;
  final ValueNotifier<User?> session;

  const AppDependencies({
    super.key,
    required this.authRepo,
    required this.userRepo,
    required this.machineRepo,
    required this.session,
    required super.child,
  });

  static AppDependencies of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDependencies>()!;

  @override
  bool updateShouldNotify(AppDependencies old) => false;
}
