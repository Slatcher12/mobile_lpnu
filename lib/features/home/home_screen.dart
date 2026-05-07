import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/coffee_machine.dart';
import '../../core/repositories/machine_repository.dart';
import '../../cubits/auth_cubit.dart';
import '../../cubits/machine_cubit.dart';
import '../../widgets/section_header.dart';
import 'widgets/connectivity_banner.dart';
import 'widgets/home_stats_row.dart';
import 'widgets/machine_dialog.dart';
import 'widgets/machine_list_section.dart';
import 'widgets/sensor_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = switch (context.read<AuthCubit>().state) {
      AuthAuthenticated(:final user) => user.id,
      _ => '',
    };
    return BlocProvider(
      create: (ctx) =>
          MachineCubit(ctx.read<MachineRepository>())..load(userId),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    return Scaffold(
      appBar: HomeAppBar(
        user: user,
        onProfileTap: () => Navigator.pushNamed(context, '/profile'),
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: BlocBuilder<MachineCubit, MachineState>(
              builder: (_, state) {
                if (state is MachineLoading || state is MachineInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3E2723)),
                  );
                }
                final machines = state is MachineLoaded
                    ? state.machines
                    : <CoffeeMachine>[];
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
                        onEdit: (m) => _edit(context, m),
                        onDelete: (id) =>
                            context.read<MachineCubit>().delete(id),
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
        onPressed: () => _add(context),
        backgroundColor: const Color(0xFF3E2723),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }

  Future<void> _add(BuildContext context) async {
    final r = await showDialog<MachineFormResult>(
      context: context,
      builder: (_) => const MachineDialog(),
    );
    if (r == null || !context.mounted) return;
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return;
    await context.read<MachineCubit>().add(
      CoffeeMachine(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: authState.user.id,
        name: r.name,
        model: r.model,
        isOnline: true,
      ),
    );
  }

  Future<void> _edit(BuildContext context, CoffeeMachine m) async {
    final r = await showDialog<MachineFormResult>(
      context: context,
      builder: (_) => MachineDialog(machine: m),
    );
    if (r == null || !context.mounted) return;
    await context.read<MachineCubit>().update(
      m.copyWith(name: r.name, model: r.model),
    );
  }
}
