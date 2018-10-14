import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:screensee/chat/message.dart';
import 'package:screensee/cookie.dart';
import 'package:screensee/room.dart';

import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:screensee/user.dart';

class ChatPresenter {
  final CookieStorage cookieStorage;
  final UserProvider userProvider;

  ChatView view;

  Room room;

  mqtt.MqttClient client;

  ChatPresenter(this.cookieStorage, this.userProvider);

  void initRoom(Room room) async {
    this.room = room;

    view?.showProgress();
    try {
      final response = await http.get(
          "http://185.143.145.119/b/mess/${room.id}",
          headers: {"Cookie": await cookieStorage.readCookies()});

      final messageJson = json.decode(response.body);
      view?.showChat(await userProvider.getUser(), readArrayFromJson(messageJson["data"]));

      _listenMqtt();
    } catch (e) {
      view?.showError();
    }
  }

  dispose() {
    client?.disconnect();
  }

  _listenMqtt() async {
    client = mqtt.MqttClient("185.143.145.119", '');
    client.logging(true);
    client.keepAlivePeriod = 30;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .keepAliveFor(30)
          ..withClientIdentifier('Mqtt_MyClientUniqueId2')
              .startClean()
              .keepAliveFor(30)
              .withWillTopic('willtopic')
              .withWillMessage('My Will message')
              .withWillQos(mqtt.MqttQos.atLeastOnce);
    print('MQTT client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();

      client.updates.listen(_onMessage);

      if (client.connectionState == mqtt.ConnectionState.connected) {
        final topic = "room/${room.id}/message";
        print('Subscribing to $topic');
        client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
      }
    } catch (e) {
      print(e);
    }
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    
    final messageJson = json.decode(message);
    view?.addMessage(readFromJson(messageJson));
  }

  void sendMessage(String message) async {
    view?.showMessageProgress();

    try {
      await http.post("http://185.143.145.119/b/mess/post",
          headers: {"Cookie": await cookieStorage.readCookies()},
          body: {"roomId": room.id, "text": message});
    } catch (e) {
      print(e);
    } finally {
      view?.hideMessageProgress();
    }
  }
}

abstract class ChatView {
  void showChat(User user, List<Message> messages);
  void addMessage(Message message);

  void showMessageProgress();
  void hideMessageProgress();

  void showProgress();
  void showError();
}
