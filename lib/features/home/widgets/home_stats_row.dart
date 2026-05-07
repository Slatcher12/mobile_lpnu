import 'package:flutter/material.dart';

import '../../../core/models/user.dart';
import '../../../widgets/stat_card.dart';

class HomeStatsRow extends StatelessWidget {
  final int machineCount;
  const HomeStatsRow({super.key, required this.machineCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            value: '$machineCount',
            label: 'Machines',
            icon: Icons.coffee_maker,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: StatCard(value: '0', label: "Today's", icon: Icons.local_cafe),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: StatCard(
            value: '0',
            label: 'All Time',
            icon: Icons.star_outline,
          ),
        ),
      ],
    );
  }
}

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFF3E2723),
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (_) {},
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_cafe_outlined),
          label: 'Machines',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User? user;
  final VoidCallback onProfileTap;
  final VoidCallback onTorchToggle;

  const HomeAppBar({
    super.key,
    required this.user,
    required this.onProfileTap,
    required this.onTorchToggle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3E2723),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${user?.name ?? ''} ☕',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          _SecretTitle(onActivate: onTorchToggle),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: onProfileTap,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFFF8F00),
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _SecretTitle extends StatefulWidget {
  final VoidCallback onActivate;
  const _SecretTitle({required this.onActivate});

  @override
  State<_SecretTitle> createState() => _SecretTitleState();
}

class _SecretTitleState extends State<_SecretTitle> {
  int _taps = 0;

  void _onTap() {
    _taps++;
    if (_taps >= 5) {
      _taps = 0;
      widget.onActivate();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _onTap,
    child: const Text(
      'Smart Coffee',
      style: TextStyle(color: Colors.white70, fontSize: 12),
    ),
  );
}
