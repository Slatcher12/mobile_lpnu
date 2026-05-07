import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

MqttClient createMqttClient(
  String host,
  String id,
  int tcpPort,
  int wsPort,
) =>
    MqttBrowserClient.withPort('ws://$host', id, wsPort);
