import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt_client_factory_web.dart'
    if (dart.library.io) 'mqtt_client_factory_io.dart';

import '../../models/sensor_reading.dart';
import '../mqtt_service.dart';

class HiveMqService implements MqttService {
  static const _host = 'localhost';
  static const _tcpPort = 1883;
  static const _wsPort = 9001;
  static const _kTopics = [
    'smartcoffee/temperature',
    'smartcoffee/pressure',
    'smartcoffee/humidity',
  ];

  late final MqttClient _client;
  final _controller = StreamController<SensorReading>.broadcast();
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _updatesSub;

  @override
  final connected = ValueNotifier<bool>(false);

  HiveMqService() {
    final id = 'sc_${DateTime.now().millisecondsSinceEpoch}';
    _client = createMqttClient(_host, id, _tcpPort, _wsPort);
    _client.logging(on: false);
    _client.keepAlivePeriod = 30;
    if (!kIsWeb) _client.autoReconnect = true;
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    if (!kIsWeb) _client.onAutoReconnected = _resubscribe;
  }

  void _onConnected() {
    connected.value = true;
    _resubscribe();
    _updatesSub ??= _client.updates?.listen(_onMessage);
  }

  void _onDisconnected() => connected.value = false;

  void _resubscribe() {
    for (final topic in _kTopics) {
      _client.subscribe(topic, MqttQos.atMostOnce);
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> events) {
    for (final event in events) {
      final pub = event.payload as MqttPublishMessage;
      final value = MqttPublishPayload.bytesToStringAsString(
        pub.payload.message,
      );
      _controller.add(
        SensorReading(
          topic: event.topic,
          value: value,
          receivedAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Stream<SensorReading> get readings => _controller.stream;

  @override
  Future<void> connect() async {
    if (connected.value) return;
    _client.connectionMessage = MqttConnectMessage()
        .withProtocolName('MQTT')
        .withProtocolVersion(4)
        .withClientIdentifier(_client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    try {
      await _client.connect();
    } catch (_) {
      _client.disconnect();
    }
  }

  @override
  Future<void> disconnect() async {
    _updatesSub?.cancel();
    _updatesSub = null;
    _client.disconnect();
  }
}
