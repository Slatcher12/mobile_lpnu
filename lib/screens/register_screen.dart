import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF3E2723)),
      ),
      body: SafeArea(
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
              const AppTextField(
                label: 'Full Name',
                hint: 'John Doe',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: 'Email',
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: 'Password',
                hint: '••••••••',
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: 'Confirm Password',
                hint: '••••••••',
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Create Account',
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/home'),
              ),
              const SizedBox(height: 24),
              _LoginLink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? '),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            'Sign In',
            style: TextStyle(
              color: Color(0xFF3E2723),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
