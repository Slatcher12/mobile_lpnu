import 'package:flutter/material.dart';

import '../../core/validators/validators.dart';
import '../../di/app_dependencies.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';

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
    final deps = AppDependencies.of(context);
    await deps.authRepo.logout();
    deps.session.value = null;
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteAccount() async {
    final ok = await _showDeleteDialog();
    if (ok != true || !mounted) return;
    final deps = AppDependencies.of(context);
    final id = deps.session.value!.id;
    await deps.machineRepo.deleteByUserId(id);
    await deps.userRepo.delete(id);
    await deps.authRepo.logout();
    deps.session.value = null;
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<bool?> _showDeleteDialog() => showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Account'),
      content: const Text(
        'All your data will be removed. This cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

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
            _saving
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.check, color: Colors.white),
                    onPressed: _save,
                  )
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
            _ProfileHeader(
              editing: _editing,
              nameCtrl: _nameCtrl,
              emailCtrl: _emailCtrl,
              error: _error,
            ),
            const SizedBox(height: 24),
            _StatsRow(),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Account'),
            const SizedBox(height: 12),
            _ActionItem(icon: Icons.logout, label: 'Sign Out', onTap: _signOut),
            _ActionItem(
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

class _ProfileHeader extends StatelessWidget {
  final bool editing;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final String? error;

  const _ProfileHeader({
    required this.editing,
    required this.nameCtrl,
    required this.emailCtrl,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFF3E2723),
            child: Icon(Icons.person, size: 48, color: Color(0xFFFF8F00)),
          ),
        ),
        if (editing) ...[
          AppTextField(
            label: 'Full Name',
            hint: 'John Doe',
            icon: Icons.person_outline,
            controller: nameCtrl,
            validator: Validators.name,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Email',
            hint: 'you@example.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            controller: emailCtrl,
            validator: Validators.email,
          ),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
        ] else ...[
          Text(
            nameCtrl.text,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            emailCtrl.text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: StatCard(
            value: '0',
            label: 'Total Brews',
            icon: Icons.local_cafe,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(
            value: '0',
            label: 'Day Streak',
            icon: Icons.local_fire_department,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(
            value: '—',
            label: 'Machines',
            icon: Icons.coffee_maker,
          ),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Colors.red : const Color(0xFF3E2723);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label, style: TextStyle(color: color)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
