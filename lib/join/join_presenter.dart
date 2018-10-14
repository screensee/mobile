import 'dart:convert';

import 'package:screensee/cookie.dart';
import 'package:screensee/errors.dart';
import 'package:screensee/room.dart';
import 'package:http/http.dart' as http;

class JoinPresenter {
  final CookieStorage cookieStorage;

  JoinView view;

  JoinPresenter(this.cookieStorage);

  void joinRoom(String roomName) async {
    view?.showProgress();
    try {
      final response = await http.post(
          "http://185.143.145.119/b/rooms/join/$roomName",
          headers: {"Cookie": await cookieStorage.readCookies()});

      final resultJson = json.decode(response.body);
      if (resultJson["result"] != "ok") {
        throw ApiException();
      }
      view?.openRoom(parseFromJson(resultJson));
    } catch (e) {
      view?.showError();
    }
  }
}

abstract class JoinView {
  void showProgress();
  void showError();
  void openRoom(Room room);
}
