import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/repositories/user_repository.dart';
import '../../core/validators/validators.dart';
import '../../cubits/auth_cubit.dart';
import '../../cubits/profile_cubit.dart';
import '../../widgets/section_header.dart';
import 'widgets/profile_dialogs.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;
    return BlocProvider(
      create: (ctx) => ProfileCubit(ctx.read<UserRepository>(), user),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  bool _editing = false;
  String? _validationError;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    final user = (context.read<ProfileCubit>().state as ProfileReady).user;
    _nameCtrl = TextEditingController(text: user.name);
    _emailCtrl = TextEditingController(text: user.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final err =
        Validators.name(_nameCtrl.text) ?? Validators.email(_emailCtrl.text);
    if (err != null) {
      setState(() => _validationError = err);
      return;
    }
    setState(() => _validationError = null);
    context.read<ProfileCubit>().save(_nameCtrl.text, _emailCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) =>
          prev is ProfileReady &&
          prev.saving &&
          curr is ProfileReady &&
          !curr.saving,
      listener: (_, state) {
        final ready = state as ProfileReady;
        if (ready.error == null) {
          context.read<AuthCubit>().updateUser(ready.user);
          setState(() {
            _editing = false;
            _nameCtrl.text = ready.user.name;
            _emailCtrl.text = ready.user.email;
          });
        }
      },
      builder: (_, state) {
        final ready = state as ProfileReady;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF3E2723),
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            leading: const BackButton(color: Colors.white),
            actions: [
              if (_editing)
                ProfileSaveAction(saving: ready.saving, onSave: _save)
              else
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () => setState(() => _editing = true),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width > 600 ? width * 0.2 : 16,
              vertical: 16,
            ),
            child: Column(
              children: [
                ProfileHeader(
                  editing: _editing,
                  nameCtrl: _nameCtrl,
                  emailCtrl: _emailCtrl,
                  error: _validationError ?? ready.error,
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Account'),
                const SizedBox(height: 12),
                ProfileActionItem(
                  icon: Icons.logout,
                  label: 'Sign Out',
                  onTap: () => signOutUser(context),
                ),
                ProfileActionItem(
                  icon: Icons.delete_outline,
                  label: 'Delete Account',
                  onTap: () => deleteUserAccount(context),
                  isDanger: true,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
