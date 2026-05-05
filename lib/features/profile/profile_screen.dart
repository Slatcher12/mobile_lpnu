import 'package:flutter/material.dart';

import '../../core/validators/validators.dart';
import '../../di/app_dependencies.dart';
import '../../widgets/section_header.dart';
import 'widgets/profile_dialogs.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  bool _saving = false;
  bool _initialized = false;
  String? _error;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final user = AppDependencies.of(context).session.value!;
    _nameCtrl = TextEditingController(text: user.name);
    _emailCtrl = TextEditingController(text: user.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nameErr = Validators.name(_nameCtrl.text);
    final emailErr = Validators.email(_emailCtrl.text);
    if (nameErr != null || emailErr != null) {
      setState(() => _error = nameErr ?? emailErr);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final deps = AppDependencies.of(context);
    final updated = deps.session.value!.copyWith(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
    );
    await deps.userRepo.update(updated);
    deps.session.value = updated;
    if (!mounted) return;
    setState(() {
      _saving = false;
      _editing = false;
    });
  }

  Future<void> _signOut() async {
    final ok = await showConfirmDialog(
      context, 'Sign Out', 'Are you sure you want to sign out?', 'Sign Out',
    );
    if (ok != true || !mounted) return;
    final deps = AppDependencies.of(context);
    await deps.mqttService.disconnect();
    await deps.authRepo.logout();
    deps.session.value = null;
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  Future<void> _deleteAccount() async {
    final ok = await showConfirmDialog(
      context, 'Delete Account',
      'All your data will be removed. This cannot be undone.',
      'Delete', danger: true,
    );
    if (ok != true || !mounted) return;
    final deps = AppDependencies.of(context);
    final id = deps.session.value!.id;
    await deps.mqttService.disconnect();
    await deps.machineRepo.deleteByUserId(id);
    await deps.userRepo.delete(id);
    await deps.authRepo.logout();
    deps.session.value = null;
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
        actions: [
          if (_editing)
            ProfileSaveAction(saving: _saving, onSave: _save)
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
              error: _error,
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Account'),
            const SizedBox(height: 12),
            ProfileActionItem(
              icon: Icons.logout,
              label: 'Sign Out',
              onTap: _signOut,
            ),
            ProfileActionItem(
              icon: Icons.delete_outline,
              label: 'Delete Account',
              onTap: _deleteAccount,
              isDanger: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
