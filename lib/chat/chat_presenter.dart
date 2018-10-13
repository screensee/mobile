import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:screensee/chat/message.dart';
import 'package:screensee/cookie.dart';
import 'package:screensee/room.dart';

class ChatPresenter {
  final CookieStorage cookieStorage;
  ChatView view;

  Room room;

  ChatPresenter(this.cookieStorage);

  void initRoom(Room room) async {
    this.room = room;

    view?.showProgress();
    try {
      final response = await http.get(
          "http://185.143.145.119/b/mess/${room.id}",
          headers: {"Cookie": await cookieStorage.readCookies()});

      final messageJson = json.decode(response.body);
      view?.showChat(readArrayFromJson(messageJson["data"]));
    } catch (e) {
      view?.showError();
    }
  }

  void sendMessage(String message) async {
    view?.showMessageProgress();

    try {
      final response = await http.post("http://185.143.145.119/b/mess/post",
          headers: {"Cookie": await cookieStorage.readCookies()},
          body: {"roomId": room.id, "text": message});

      final messageJson = json.decode(response.body);
      view?.addMessage(readFromJson(messageJson["data"]));
    } catch (e) { 
      print(e);
    } finally {
      view?.hideMessageProgress();
    }
  }
}

abstract class ChatView {
  void showChat(List<Message> messages);
  void addMessage(Message message);

  void showMessageProgress();
  void hideMessageProgress();

  void showProgress();
  void showError();
}
