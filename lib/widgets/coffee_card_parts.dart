import 'package:flutter/material.dart';

class CoffeeMachineIcon extends StatelessWidget {
  final bool isOnline;
  const CoffeeMachineIcon({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isOnline ? const Color(0xFFFFF3E0) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.coffee_maker,
        color: isOnline ? const Color(0xFF3E2723) : Colors.grey,
      ),
    );
  }
}

class CoffeeStatusBadge extends StatelessWidget {
  final String status;
  final bool isOnline;
  const CoffeeStatusBadge({
    super.key,
    required this.status,
    required this.isOnline,
  });

  Color get _color {
    if (!isOnline) return Colors.grey;
    if (status == 'Brewing') return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CoffeeActionMenu extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const CoffeeActionMenu({super.key, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (v) {
        if (v == 'edit') onEdit?.call();
        if (v == 'delete') onDelete?.call();
      },
      itemBuilder: (_) => [
        if (onEdit != null)
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
        if (onDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}
