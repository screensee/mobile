import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:screensee/cookie.dart';
import 'package:screensee/errors.dart';
import 'package:screensee/room.dart';

class CreatePresenter {
  final CookieStorage cookieStorage;

  CreateView view;

  CreatePresenter(this.cookieStorage);

  void createRoom({String link, String pseudonym}) async {
    view?.showProgress();
    try {
      final cookie = await cookieStorage.readCookies();
      Map<String, String> body = Map();
      if (link != null) {
        body["videoLink"] = link;
      }
      if (pseudonym != null) {
        body["pseudonym"] = pseudonym;
      }

      final response = await http.post("http://185.143.145.119/b/rooms/create",
          headers: {"Cookie": cookie}, body: body);

      final roomJson = json.decode(response.body);
      if (roomJson["result"] != "ok") {
        throw ApiException();
      }

      final room = parseFromJson(roomJson);

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
