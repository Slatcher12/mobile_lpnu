import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/validators/validators.dart';
import '../../cubits/auth_cubit.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import 'widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        final loading = state is AuthLoading;
        final error = state is AuthError ? state.message : null;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Color(0xFF3E2723)),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: width > 600 ? width * 0.2 : 24,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3E2723),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join Smart Coffee today',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      label: 'Full Name',
                      hint: 'John Doe',
                      icon: Icons.person_outline,
                      controller: _nameCtrl,
                      validator: Validators.name,
                    ),
                    const SizedBox(height: 16),
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
                      controller: _passCtrl,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Confirm Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscure: true,
                      controller: _confirmCtrl,
                      validator: (_) => Validators.confirmPassword(
                        _passCtrl.text,
                      )(_confirmCtrl.text),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 12),
                      Text(error, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 32),
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF3E2723),
                            ),
                          )
                        : AppButton(
                            label: 'Create Account',
                            onPressed: _submit,
                          ),
                    const SizedBox(height: 24),
                    const LoginLink(),
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
