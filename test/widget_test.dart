import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_lpnu/core/models/user.dart';
import 'package:mobile_lpnu/core/repositories/local/local_auth_repository.dart';
import 'package:mobile_lpnu/core/repositories/local/local_machine_repository.dart';
import 'package:mobile_lpnu/core/repositories/local/local_user_repository.dart';
import 'package:mobile_lpnu/core/repositories/local/user_store.dart';
import 'package:mobile_lpnu/di/app_dependencies.dart';
import 'package:mobile_lpnu/main.dart';

Future<Widget> _buildApp({User? user}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final store = UserStore(prefs);
  return AppDependencies(
    authRepo: LocalAuthRepository(prefs, store),
    userRepo: LocalUserRepository(store),
    machineRepo: LocalMachineRepository(prefs),
    session: ValueNotifier<User?>(user),
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
