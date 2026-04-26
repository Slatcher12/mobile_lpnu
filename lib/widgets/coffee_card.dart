import 'package:flutter/material.dart';

class CoffeeCard extends StatelessWidget {
  final String name;
  final String model;
  final String status;
  final bool isOnline;

  const CoffeeCard({
    super.key,
    required this.name,
    required this.model,
    required this.status,
    required this.isOnline,
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
                Text(
                  model,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          _StatusBadge(status: status, isOnline: isOnline),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
