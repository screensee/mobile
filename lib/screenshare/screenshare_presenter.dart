import 'dart:convert';

import 'package:screensee/cookie.dart';
import 'package:screensee/room.dart';
import 'package:screensee/screenshare/resolver.dart';
import 'package:http/http.dart' as http;

class ScreensharePresenter {
  final UrlResolver resolver;
  final CookieStorage cookieStorage;

  ScreenShareView view;
  Room room;

  ScreensharePresenter(this.resolver, this.cookieStorage);

  void initRoom(Room room) async {
    this.room = room;

    view?.showProgress();

    try {
      await _resolveUrl();
    } catch (e) {
      view?.showError();
    }
  }

  void updateLink(String link) {
    room = Room(room.id, room.participants, link, room.pseudonym);

    _resolveUrl();
  }

  _resolveUrl() async {
    view?.showPlayerProgress();
    if (hasLink) {
      final url = await resolver.resolve(room.videoLink);
      view?.showPlayer(url);
    } else {
      view?.showWithoutPlayer();
    }
  }

  void refresh() async {
    view?.showPlayerProgress();
    try {
      final response = await http.get(
        "http://185.143.145.119/b/rooms/id/${room.id}",
        headers: {
          "Cookie": await cookieStorage.readCookies()
        }
      );

      final roomJson = json.decode(response.body);
      room = parseFromJson(roomJson);
      await _resolveUrl();
    } catch (e) {
      view?.showWithoutPlayer();
    }
  }

  bool get hasLink => room?.videoLink?.isNotEmpty ?? false;
}

abstract class ScreenShareView {
  void showProgress();
  void showError();

  void showPlayerProgress();
  void showWithoutPlayer();
  void showPlayer(String url);
}
