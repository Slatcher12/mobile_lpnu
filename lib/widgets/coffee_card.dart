import 'package:flutter/material.dart';

import 'coffee_card_parts.dart';

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
          CoffeeMachineIcon(isOnline: isOnline),
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
                    CoffeeStatusBadge(status: status, isOnline: isOnline),
                  ],
                ),
              ],
            ),
          ),
          if (onEdit != null || onDelete != null)
            CoffeeActionMenu(onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }
}
