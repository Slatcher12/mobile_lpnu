import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_lpnu/core/models/sensor_reading.dart';
import 'package:mobile_lpnu/core/models/user.dart';
import 'package:mobile_lpnu/core/repositories/local/local_auth_repository.dart';
import 'package:mobile_lpnu/core/repositories/local/local_machine_repository.dart';
import 'package:mobile_lpnu/core/repositories/local/local_user_repository.dart';
import 'package:mobile_lpnu/core/repositories/local/user_store.dart';
import 'package:mobile_lpnu/core/services/connectivity_service.dart';
import 'package:mobile_lpnu/core/services/mqtt_service.dart';
import 'package:mobile_lpnu/di/app_dependencies.dart';
import 'package:mobile_lpnu/main.dart';

class _FakeMqttService implements MqttService {
  @override
  final connected = ValueNotifier<bool>(false);
  @override
  Stream<SensorReading> get readings => const Stream.empty();
  @override
  Future<void> connect() async {}
  @override
  Future<void> disconnect() async {}
}

class _FakeConnectivityService implements ConnectivityService {
  @override
  Future<bool> hasConnection() async => true;
  @override
  Stream<bool> get statusStream => const Stream.empty();
}

Future<Widget> _buildApp({User? user}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final store = UserStore(prefs);
  return AppDependencies(
    authRepo: LocalAuthRepository(prefs, store),
    userRepo: LocalUserRepository(store),
    machineRepo: LocalMachineRepository(prefs),
    mqttService: _FakeMqttService(),
    connectivityService: _FakeConnectivityService(),
    session: ValueNotifier<User?>(user),
    isOnline: ValueNotifier<bool>(true),
    child: const CoffeeApp(startRoute: '/login'),
  );
}

void main() {
  testWidgets('login screen renders app name', (tester) async {
    await tester.pumpWidget(await _buildApp());
    expect(find.text('Smart Coffee'), findsWidgets);
  });

  testWidgets('login screen has sign in button', (tester) async {
    await tester.pumpWidget(await _buildApp());
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('login screen has sign up link', (tester) async {
    await tester.pumpWidget(await _buildApp());
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
