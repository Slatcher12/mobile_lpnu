class SensorReading {
  final String topic;
  final String value;
  final DateTime receivedAt;

  const SensorReading({
    required this.topic,
    required this.value,
    required this.receivedAt,
  });
}
