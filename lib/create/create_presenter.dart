import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:screensee/cookie.dart';
import 'package:screensee/errors.dart';
import 'package:screensee/room.dart';
import 'package:screensee/user.dart';

class CreatePresenter {
  final CookieStorage cookieStorage;

  CreateView view;

  CreatePresenter(this.cookieStorage);

  void createRoom({String link, String password}) async {
    view?.showProgress();
    try {
      final cookie = await cookieStorage.readCookies();
      Map<String, String> body = Map();
      if (link != null) {
        body["videoLink"] = link;
      }
      if (password != null) {
        body["password"] = password;
      }

      final response = await http.post("http://185.143.145.119/b/rooms/create",
          headers: {"Cookie": cookie}, body: body);

      final roomJson = json.decode(response.body);
      if (roomJson["result"] != "ok") {
        throw ApiException();
      }

      final room = Room(
        roomJson["data"]["id"],
        (roomJson["data"]["participants"] as List).map((item) => User(item)).toList(),
        roomJson["data"]["videoLink"],
        roomJson["data"]["pseudonym"],
      );

      view?.openRoom(room);
    } catch (e) {
      view?.showError();
    }
  }
}

abstract class CreateView {
  void showProgress();
  void showError();
  void openRoom(Room room);
}
