import 'package:flutter/material.dart';

import '../core/models/user.dart';
import '../core/repositories/auth_repository.dart';
import '../core/repositories/machine_repository.dart';
import '../core/repositories/user_repository.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/mqtt_service.dart';

class AppDependencies extends InheritedWidget {
  final AuthRepository authRepo;
  final UserRepository userRepo;
  final MachineRepository machineRepo;
  final MqttService mqttService;
  final ConnectivityService connectivityService;
  final ValueNotifier<User?> session;
  final ValueNotifier<bool> isOnline;

  const AppDependencies({
    super.key,
    required this.authRepo,
    required this.userRepo,
    required this.machineRepo,
    required this.mqttService,
    required this.connectivityService,
    required this.session,
    required this.isOnline,
    required super.child,
  });

  static AppDependencies of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDependencies>()!;

  @override
  bool updateShouldNotify(AppDependencies old) => false;
}
