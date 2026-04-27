import 'package:flutter/material.dart';

import '../../core/models/coffee_machine.dart';
import '../../core/models/user.dart';
import '../../di/app_dependencies.dart';
import '../../widgets/coffee_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';
import 'widgets/connectivity_banner.dart';
import 'widgets/machine_dialog.dart';
import 'widgets/sensor_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CoffeeMachine> _machines = [];
  bool _loading = true;
  bool _initialized = false;
  late final AppDependencies _deps;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _deps = AppDependencies.of(context);
    _deps.isOnline.addListener(_onConnectivity);
    _load();
    if (_deps.isOnline.value) _deps.mqttService.connect();
  }

  void _onConnectivity() {
    if (_deps.isOnline.value && !_deps.mqttService.connected.value) {
      _deps.mqttService.connect();
    }
  }

  @override
  void dispose() {
    _deps.isOnline.removeListener(_onConnectivity);
    super.dispose();
  }

  Future<void> _load() async {
    final id = _deps.session.value?.id;
    if (id == null) return;
    final machines = await _deps.machineRepo.getByUserId(id);
    if (!mounted) return;
    setState(() {
      _machines = machines;
      _loading = false;
    });
  }

  Future<void> _add() async {
    final result = await showDialog<MachineFormResult>(
      context: context,
      builder: (_) => const MachineDialog(),
    );
    if (result == null || !mounted) return;
    final machine = CoffeeMachine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _deps.session.value!.id,
      name: result.name,
      model: result.model,
      isOnline: true,
    );
    await _deps.machineRepo.add(machine);
    setState(() => _machines = [..._machines, machine]);
  }

  Future<void> _edit(CoffeeMachine machine) async {
    final result = await showDialog<MachineFormResult>(
      context: context,
      builder: (_) => MachineDialog(machine: machine),
    );
    if (result == null || !mounted) return;
    final updated = machine.copyWith(name: result.name, model: result.model);
    await _deps.machineRepo.update(updated);
    setState(() {
      _machines = [for (final m in _machines) m.id == updated.id ? updated : m];
    });
  }

  Future<void> _delete(String id) async {
    await _deps.machineRepo.delete(id);
    setState(() => _machines = _machines.where((m) => m.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3E2723)),
                  )
                : _buildBody(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        backgroundColor: const Color(0xFF3E2723),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _HomeBottomNav(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3E2723),
      title: ValueListenableBuilder<User?>(
        valueListenable: _deps.session,
        builder: (_, user, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user?.name ?? ''} ☕',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Text(
              'Smart Coffee',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/profile'),
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

  Widget _buildBody() {
    final width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: width > 600 ? width * 0.1 : 16,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatsRow(count: _machines.length),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Live Sensors'),
          const SizedBox(height: 8),
          const SensorPanel(),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'My Machines',
            action: _machines.isNotEmpty ? 'Total: ${_machines.length}' : null,
          ),
          const SizedBox(height: 12),
          if (_machines.isEmpty)
            _EmptyState()
          else
            _MachineList(machines: _machines, onEdit: _edit, onDelete: _delete),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int count;
  const _StatsRow({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            value: '$count',
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(Icons.coffee_maker, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No machines yet',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap + to add your first machine',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _MachineList extends StatelessWidget {
  final List<CoffeeMachine> machines;
  final void Function(CoffeeMachine) onEdit;
  final void Function(String) onDelete;

  const _MachineList({
    required this.machines,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final m in machines) ...[
          CoffeeCard(
            name: m.name,
            model: m.model,
            status: m.isOnline ? 'Ready' : 'Offline',
            isOnline: m.isOnline,
            onEdit: () => onEdit(m),
            onDelete: () => onDelete(m.id),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _HomeBottomNav extends StatelessWidget {
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
