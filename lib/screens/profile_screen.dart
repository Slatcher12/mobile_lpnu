import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width > 600 ? width * 0.2 : 16,
        ),
        child: Column(
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 24),
            const _StatsSection(),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Preferences'),
            const SizedBox(height: 12),
            const _PreferenceItem(
              icon: Icons.coffee,
              label: 'Favorite Drink',
              value: 'Espresso',
            ),
            const _PreferenceItem(
              icon: Icons.speed,
              label: 'Default Strength',
              value: 'Strong',
            ),
            const _PreferenceItem(
              icon: Icons.notifications_outlined,
              label: 'Brew Alerts',
              value: 'On',
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Account'),
            const SizedBox(height: 12),
            const _PreferenceItem(
              icon: Icons.edit_outlined,
              label: 'Edit Profile',
              value: '',
            ),
            const _PreferenceItem(
              icon: Icons.lock_outline,
              label: 'Change Password',
              value: '',
            ),
            const _PreferenceItem(
              icon: Icons.logout,
              label: 'Sign Out',
              value: '',
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
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFF3E2723),
            child: Icon(Icons.person, size: 48, color: Color(0xFFFF8F00)),
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'john.doe@example.com',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: StatCard(
            value: '142',
            label: 'Total Brews',
            icon: Icons.local_cafe,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(
            value: '28',
            label: 'Day Streak',
            icon: Icons.local_fire_department,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(
            value: '3',
            label: 'Machines',
            icon: Icons.coffee_maker,
          ),
        ),
      ],
    );
  }
}

class _PreferenceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDanger;

  const _PreferenceItem({
    required this.icon,
    required this.label,
    required this.value,
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
        trailing: value.isNotEmpty
            ? Text(value, style: const TextStyle(color: Colors.grey))
            : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
