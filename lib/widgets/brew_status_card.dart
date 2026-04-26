import 'package:flutter/material.dart';

class BrewStatusCard extends StatelessWidget {
  final String machineName;
  final String remaining;
  final double progress;

  const BrewStatusCard({
    super.key,
    required this.machineName,
    required this.remaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3E2723), Color(0xFF6D4C41)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.coffee_maker, color: Color(0xFFFF8F00), size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: _BrewInfo(
              name: machineName,
              remaining: remaining,
              progress: progress,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrewInfo extends StatelessWidget {
  final String name;
  final String remaining;
  final double progress;

  const _BrewInfo({
    required this.name,
    required this.remaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Brewing Now',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation(Color(0xFFFF8F00)),
        ),
        const SizedBox(height: 4),
        Text(
          remaining,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
