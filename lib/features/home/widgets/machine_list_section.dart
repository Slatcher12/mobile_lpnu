import 'package:flutter/material.dart';

import '../../../core/models/coffee_machine.dart';
import '../../../widgets/coffee_card.dart';

class MachineListSection extends StatelessWidget {
  final List<CoffeeMachine> machines;
  final void Function(CoffeeMachine) onEdit;
  final void Function(String) onDelete;

  const MachineListSection({
    super.key,
    required this.machines,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (machines.isEmpty) return const MachineEmptyState();
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

class MachineEmptyState extends StatelessWidget {
  const MachineEmptyState({super.key});

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
