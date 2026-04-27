import 'package:flutter/foundation.dart';

import '../models/sensor_reading.dart';

abstract class MqttService {
  ValueNotifier<bool> get connected;
  Stream<SensorReading> get readings;
  Future<void> connect();
  Future<void> disconnect();
}
