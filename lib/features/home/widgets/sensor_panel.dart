import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/models/sensor_reading.dart';
import '../../../di/app_dependencies.dart';
import 'sensor_tile.dart';

class SensorPanel extends StatefulWidget {
  const SensorPanel({super.key});

  @override
  State<SensorPanel> createState() => _SensorPanelState();
}

class _SensorPanelState extends State<SensorPanel> {
  static const _configs = [
    TopicConfig(
      topic: 'smartcoffee/temperature',
      label: 'Temperature',
      unit: '°C',
      icon: Icons.thermostat,
    ),
    TopicConfig(
      topic: 'smartcoffee/pressure',
      label: 'Pressure',
      unit: 'bar',
      icon: Icons.speed,
    ),
    TopicConfig(
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
                  child: SensorTile(config: c, value: _values[c.topic]),
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
