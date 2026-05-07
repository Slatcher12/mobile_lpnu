import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/validators/validators.dart';
import '../../cubits/auth_cubit.dart';
import '../../cubits/sensor_cubit.dart';
import '../../di/app_dependencies.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import 'widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!AppDependencies.of(context).isOnline.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet — live sensor data will be unavailable'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
    context.read<AuthCubit>().login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<SensorCubit>().connect();
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        final loading = state is AuthLoading;
        final error = state is AuthError ? state.message : null;
        return Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: width > 600 ? width * 0.2 : 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const LoginLogo(),
                    const SizedBox(height: 48),
                    AppTextField(
                      label: 'Email',
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailCtrl,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscure: true,
                      controller: _passwordCtrl,
                      validator: Validators.password,
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 12),
                      Text(error, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 28),
                    loading
                        ? const CircularProgressIndicator(
                            color: Color(0xFF3E2723),
                          )
                        : AppButton(label: 'Sign In', onPressed: _submit),
                    const SizedBox(height: 24),
                    const RegisterLink(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
