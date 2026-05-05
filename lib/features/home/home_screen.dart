import 'package:flutter/material.dart';

import '../../core/models/coffee_machine.dart';
import '../../di/app_dependencies.dart';
import '../../widgets/section_header.dart';
import 'widgets/connectivity_banner.dart';
import 'widgets/home_stats_row.dart';
import 'widgets/machine_dialog.dart';
import 'widgets/machine_list_section.dart';
import 'widgets/sensor_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CoffeeMachine>> _machinesFuture;
  late final AppDependencies _deps;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _deps = AppDependencies.of(context);
    _deps.isOnline.addListener(_onConnectivity);
    _deps.mqttService.connect();
    _reload();
  }

  @override
  void dispose() {
    _deps.isOnline.removeListener(_onConnectivity);
    super.dispose();
  }

  void _onConnectivity() {
    if (_deps.isOnline.value && !_deps.mqttService.connected.value) {
      _deps.mqttService.connect();
    }
  }

  void _reload() => setState(() {
    _machinesFuture = _deps.machineRepo.getByUserId(
      _deps.session.value?.id ?? '',
    );
  });

  Future<void> _add() async {
    final r = await showDialog<MachineFormResult>(
      context: context,
      builder: (_) => const MachineDialog(),
    );
    if (r == null || !mounted) return;
    await _deps.machineRepo.add(CoffeeMachine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _deps.session.value!.id,
      name: r.name,
      model: r.model,
      isOnline: true,
    ));
    _reload();
  }

  Future<void> _edit(CoffeeMachine m) async {
    final r = await showDialog<MachineFormResult>(
      context: context,
      builder: (_) => MachineDialog(machine: m),
    );
    if (r == null || !mounted) return;
    await _deps.machineRepo.update(m.copyWith(name: r.name, model: r.model));
    _reload();
  }

  Future<void> _delete(String id) async {
    await _deps.machineRepo.delete(id);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: HomeAppBar(
        session: _deps.session,
        onProfileTap: () => Navigator.pushNamed(context, '/profile'),
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: FutureBuilder<List<CoffeeMachine>>(
              future: _machinesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3E2723)),
                  );
                }
                final machines = snapshot.data ?? [];
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: width > 600 ? width * 0.1 : 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeStatsRow(machineCount: machines.length),
                      const SizedBox(height: 24),
                      const SectionHeader(title: 'Live Sensors'),
                      const SizedBox(height: 8),
                      const SensorPanel(),
                      const SizedBox(height: 24),
                      SectionHeader(
                        title: 'My Machines',
                        action: machines.isNotEmpty
                            ? 'Total: ${machines.length}'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      MachineListSection(
                        machines: machines,
                        onEdit: _edit,
                        onDelete: _delete,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        backgroundColor: const Color(0xFF3E2723),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
