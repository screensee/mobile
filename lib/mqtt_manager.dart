import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class MqttManager {
  mqtt.MqttClient _client;
  StreamController<SocketPayload> _eventStream;
  Stream get stream => _eventStream.stream;

  MqttManager() {
    _eventStream = StreamController.broadcast();
  }

  Future connect() async {
    _client = mqtt.MqttClient("185.143.145.119", '');
    _client.logging(true);
    _client.keepAlivePeriod = 30;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .keepAliveFor(30)
          ..withClientIdentifier('Mqtt_MyClientUniqueId2')
              .startClean()
              .keepAliveFor(30)
              .withWillTopic('willtopic')
              .withWillMessage('My Will message')
              .withWillQos(mqtt.MqttQos.atLeastOnce);
    print('MQTT client connecting....');
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
      if (_client.connectionState == mqtt.ConnectionState.connected) {
        _client.updates.listen(_onMessage);
      }
    } catch (e) {
      dispose();
      rethrow;
    }
  }

  void subscribeToTopic(String topic) {
    if (_client.connectionState == mqtt.ConnectionState.connected) {
      print('Subscribing to $topic');
      _client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    } else {
      throw MqttNotConnectedException();
    }
  }

  void publish(String topic, {String message}) {
    final builder = new mqtt.MqttClientPayloadBuilder();
    if (message != null) {
      builder.addString(message);
    }
    _client.publishMessage(topic, mqtt.MqttQos.exactlyOnce, builder.payload);
  }

  void dispose() {
    _client?.disconnect();
    _eventStream?.close();
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    _eventStream?.add(SocketPayload(event[0].topic, message));
  }
}

class SocketPayload {
  final String topic;
  final String message;

  SocketPayload(this.topic, this.message);
}

class MqttNotConnectedException implements Exception {}
