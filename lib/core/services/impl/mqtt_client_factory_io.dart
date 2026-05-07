import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient createMqttClient(
  String host,
  String id,
  int tcpPort,
  int wsPort,
) =>
    MqttServerClient.withPort(host, id, tcpPort);
