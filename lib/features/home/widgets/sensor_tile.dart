import 'package:flutter/material.dart';

class TopicConfig {
  final String topic;
  final String label;
  final String unit;
  final IconData icon;

  const TopicConfig({
    required this.topic,
    required this.label,
    required this.unit,
    required this.icon,
  });
}

class SensorTile extends StatelessWidget {
  final TopicConfig config;
  final String? value;

  const SensorTile({super.key, required this.config, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Icon(config.icon, color: const Color(0xFF3E2723), size: 22),
          const SizedBox(height: 6),
          Text(
            value != null ? '${value!} ${config.unit}' : '—',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF3E2723),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            config.label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
