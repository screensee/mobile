import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:screensee/chat/message.dart';
import 'package:screensee/cookie.dart';
import 'package:screensee/mqtt_manager.dart';
import 'package:screensee/room.dart';

import 'package:screensee/user.dart';

class ChatPresenter {
  final CookieStorage cookieStorage;
  final UserProvider userProvider;
  final MqttManager mqttManager;

  ChatView view;

  Room room;
  String streamTopic;

  ChatPresenter(this.cookieStorage, this.userProvider, this.mqttManager);

  void initRoom(Room room) async {
    this.room = room;
    this.streamTopic = "room/${room.id}/message";

    view?.showProgress();
    try {
      final response = await http.get(
          "http://185.143.145.119/b/mess/${room.id}",
          headers: {"Cookie": await cookieStorage.readCookies()});

      final messageJson = json.decode(response.body);
      view?.showChat(
          await userProvider.getUser(), readArrayFromJson(messageJson["data"]));

      _listenMqtt();
    } catch (e) {
      view?.showError();
    }
  }

  _listenMqtt() {
    try {
      mqttManager.subscribeToTopic(streamTopic);

      mqttManager.stream.listen((payload) {
        if (payload.topic == streamTopic) {
          final messageJson = json.decode(payload.message);
          view?.addMessage(readFromJson(messageJson));
        }
      });
    } catch (e) {
      print(e);
    }
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
