import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/models/user.dart';
import 'core/repositories/local/local_auth_repository.dart';
import 'core/repositories/local/local_machine_repository.dart';
import 'core/repositories/local/local_user_repository.dart';
import 'core/repositories/local/user_store.dart';
import 'di/app_dependencies.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final store = UserStore(prefs);
  final authRepo = LocalAuthRepository(prefs, store);
  final currentUser = await authRepo.getCurrentUser();
  final session = ValueNotifier<User?>(currentUser);

  runApp(
    AppDependencies(
      authRepo: authRepo,
      userRepo: LocalUserRepository(store),
      machineRepo: LocalMachineRepository(prefs),
      session: session,
      child: CoffeeApp(startRoute: currentUser != null ? '/home' : '/login'),
    ),
  );
}

class CoffeeApp extends StatelessWidget {
  final String startRoute;

  const CoffeeApp({super.key, required this.startRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Coffee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3E2723)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3E2723),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      initialRoute: startRoute,
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
