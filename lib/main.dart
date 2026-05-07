import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/repositories/local/user_store.dart';
import 'core/repositories/machine_repository.dart';
import 'core/repositories/remote/api_client.dart';
import 'core/repositories/remote/remote_auth_repository.dart';
import 'core/repositories/remote/remote_machine_repository.dart';
import 'core/repositories/remote/remote_user_repository.dart';
import 'core/repositories/user_repository.dart';
import 'core/services/impl/connectivity_service_impl.dart';
import 'core/services/impl/hivemq_service.dart';
import 'cubits/auth_cubit.dart';
import 'cubits/sensor_cubit.dart';
import 'di/app_dependencies.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final store = UserStore(prefs);
  final client = ApiClient();

  final authRepo = RemoteAuthRepository(client, prefs, store);
  final userRepo = RemoteUserRepository(client, store);
  final machineRepo = RemoteMachineRepository(client, prefs);
  final mqttService = HiveMqService();
  final connectivity = ConnectivityServiceImpl();

  final currentUser = await authRepo.getCurrentUser();
  final isOnline = ValueNotifier<bool>(await connectivity.hasConnection());
  connectivity.statusStream.listen((v) => isOnline.value = v);

  final sensorCubit = SensorCubit(mqttService);
  if (currentUser != null) sensorCubit.connect();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(value: userRepo),
        RepositoryProvider<MachineRepository>.value(value: machineRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                AuthCubit(authRepo, userRepo, machineRepo, mqttService)
                  ..init(currentUser),
          ),
          BlocProvider.value(value: sensorCubit),
        ],
        child: AppDependencies(
          isOnline: isOnline,
          child: CoffeeApp(
            startRoute: currentUser != null ? '/home' : '/login',
          ),
        ),
      ),
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
