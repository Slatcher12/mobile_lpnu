import 'package:flutter/material.dart';

class CoffeeCard extends StatelessWidget {
  final String name;
  final String model;
  final String status;
  final bool isOnline;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CoffeeCard({
    super.key,
    required this.name,
    required this.model,
    required this.status,
    required this.isOnline,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _MachineIcon(isOnline: isOnline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        model,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _StatusBadge(status: status, isOnline: isOnline),
                  ],
                ),
              ],
            ),
          ),
          if (onEdit != null || onDelete != null)
            _ActionMenu(onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }
}

class _MachineIcon extends StatelessWidget {
  final bool isOnline;
  const _MachineIcon({required this.isOnline});

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

class _StatusBadge extends StatelessWidget {
  final String status;
  final bool isOnline;
  const _StatusBadge({required this.status, required this.isOnline});

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

class _ActionMenu extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const _ActionMenu({this.onEdit, this.onDelete});

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
