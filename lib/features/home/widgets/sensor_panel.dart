import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/sensor_cubit.dart';
import 'sensor_tile.dart';

class SensorPanel extends StatelessWidget {
  const SensorPanel({super.key});

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensorCubit, SensorState>(
      builder: (_, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MqttStatusChip(connected: state.connected),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final c in _configs) ...[
                Expanded(
                  child: SensorTile(config: c, value: state.values[c.topic]),
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
