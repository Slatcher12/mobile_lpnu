import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/auth_cubit.dart';

Future<bool?> showConfirmDialog(
  BuildContext context,
  String title,
  String body,
  String action, {
  bool danger = false,
}) => showDialog<bool>(
  context: context,
  builder: (_) => AlertDialog(
    title: Text(title),
    content: Text(body),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text(
          action,
          style: TextStyle(
            color: danger ? Colors.red : const Color(0xFF3E2723),
          ),
        ),
      ),
    ],
  ),
);

Future<void> signOutUser(BuildContext context) async {
  final ok = await showConfirmDialog(
    context,
    'Sign Out',
    'Are you sure you want to sign out?',
    'Sign Out',
  );
  if (ok != true || !context.mounted) return;
  await context.read<AuthCubit>().signOut();
  if (!context.mounted) return;
  Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
}

Future<void> deleteUserAccount(BuildContext context) async {
  final ok = await showConfirmDialog(
    context,
    'Delete Account',
    'All your data will be removed. This cannot be undone.',
    'Delete',
    danger: true,
  );
  if (ok != true || !context.mounted) return;
  final id = (context.read<AuthCubit>().state as AuthAuthenticated).user.id;
  await context.read<AuthCubit>().deleteAccount(id);
  if (!context.mounted) return;
  Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
}

class ProfileSaveAction extends StatelessWidget {
  final bool saving;
  final VoidCallback onSave;

  const ProfileSaveAction({
    super.key,
    required this.saving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (saving) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      );
    }
    return IconButton(
      icon: const Icon(Icons.check, color: Colors.white),
      onPressed: onSave,
    );
  }
}
