import 'package:flutter/material.dart';
import '../widgets/brew_status_card.dart';
import '../widgets/coffee_card.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? size.width * 0.1 : 16,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _StatsRow(),
            const SizedBox(height: 24),
            const BrewStatusCard(
              machineName: 'Espresso Shot',
              remaining: '1m 20s remaining',
              progress: 0.65,
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'My Machines', action: 'See all'),
            const SizedBox(height: 12),
            if (isTablet) const _MachinesGrid() else const _MachinesList(),
          ],
        ),
      ),
      bottomNavigationBar: const _HomeBottomNav(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3E2723),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning ☕',
            style: TextStyle(fontSize: 12, color: Colors.brown.shade200),
          ),
          const Text(
            'Smart Coffee',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/profile'),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFFFF8F00),
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: StatCard(
            value: '3',
            label: 'Machines',
            icon: Icons.coffee_maker,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(value: '7', label: "Today's", icon: Icons.local_cafe),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(
            value: '142',
            label: 'All Time',
            icon: Icons.star_outline,
          ),
        ),
      ],
    );
  }
}

class _MachinesList extends StatelessWidget {
  const _MachinesList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CoffeeCard(
          name: 'Kitchen Pro',
          model: 'Jura E8',
          status: 'Ready',
          isOnline: true,
        ),
        SizedBox(height: 12),
        CoffeeCard(
          name: 'Office Brew',
          model: 'DeLonghi EC',
          status: 'Brewing',
          isOnline: true,
        ),
        SizedBox(height: 12),
        CoffeeCard(
          name: 'Bedroom Mini',
          model: 'Nespresso',
          status: 'Offline',
          isOnline: false,
        ),
      ],
    );
  }
}

class _MachinesGrid extends StatelessWidget {
  const _MachinesGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.4,
      children: const [
        CoffeeCard(
          name: 'Kitchen Pro',
          model: 'Jura E8',
          status: 'Ready',
          isOnline: true,
        ),
        CoffeeCard(
          name: 'Office Brew',
          model: 'DeLonghi EC',
          status: 'Brewing',
          isOnline: true,
        ),
        CoffeeCard(
          name: 'Bedroom Mini',
          model: 'Nespresso',
          status: 'Offline',
          isOnline: false,
        ),
      ],
    );
  }
}

class _HomeBottomNav extends StatelessWidget {
  const _HomeBottomNav();

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
