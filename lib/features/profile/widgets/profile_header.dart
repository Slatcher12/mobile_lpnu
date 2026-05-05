import 'package:flutter/material.dart';

import '../../../core/validators/validators.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/stat_card.dart';

class ProfileHeader extends StatelessWidget {
  final bool editing;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final String? error;

  const ProfileHeader({
    super.key,
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
        const SizedBox(height: 24),
        const Row(
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
        ),
      ],
    );
  }
}

class ProfileActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;

  const ProfileActionItem({
    super.key,
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
