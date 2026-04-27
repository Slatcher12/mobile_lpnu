import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/models/sensor_reading.dart';
import '../../../di/app_dependencies.dart';

class SensorPanel extends StatefulWidget {
  const SensorPanel({super.key});

  @override
  State<SensorPanel> createState() => _SensorPanelState();
}

class _SensorPanelState extends State<SensorPanel> {
  static const _configs = [
    _TopicConfig(
      topic: 'smartcoffee/temperature',
      label: 'Temperature',
      unit: '°C',
      icon: Icons.thermostat,
    ),
    _TopicConfig(
      topic: 'smartcoffee/pressure',
      label: 'Pressure',
      unit: 'bar',
      icon: Icons.speed,
    ),
    _TopicConfig(
      topic: 'smartcoffee/humidity',
      label: 'Humidity',
      unit: '%',
      icon: Icons.water_drop_outlined,
    ),
  ];

  final Map<String, String> _values = {};
  StreamSubscription<SensorReading>? _sub;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _sub = AppDependencies.of(context).mqttService.readings.listen((r) {
      if (mounted) setState(() => _values[r.topic] = r.value);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppDependencies.of(context).mqttService.connected,
      builder: (_, connected, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MqttStatusChip(connected: connected),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final c in _configs) ...[
                Expanded(
                  child: _SensorTile(config: c, value: _values[c.topic]),
                ),
                if (c != _configs.last) const SizedBox(width: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MqttStatusChip extends StatelessWidget {
  final bool connected;
  const _MqttStatusChip({required this.connected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: connected ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          connected ? 'Broker connected' : 'Connecting to broker…',
          style: TextStyle(
            fontSize: 12,
            color: connected ? Colors.green.shade700 : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _SensorTile extends StatelessWidget {
  final _TopicConfig config;
  final String? value;
  const _SensorTile({required this.config, required this.value});

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

class _TopicConfig {
  final String topic;
  final String label;
  final String unit;
  final IconData icon;

  const _TopicConfig({
    required this.topic,
    required this.label,
    required this.unit,
    required this.icon,
  });
}
