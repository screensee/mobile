import 'dart:convert';

import 'package:screensee/cookie.dart';
import 'package:screensee/mqtt_manager.dart';
import 'package:screensee/room.dart';
import 'package:screensee/screenshare/resolver.dart';
import 'package:http/http.dart' as http;

class ScreensharePresenter {
  final UrlResolver resolver;
  final CookieStorage cookieStorage;
  final MqttManager mqttManager;

  ScreenShareView view;
  Room room;

  ScreensharePresenter(this.resolver, this.cookieStorage, this.mqttManager);

  void initRoom(Room room) async {
    this.room = room;

    view?.showProgress();

    try {
      await mqttManager.connect();
      await _resolveUrl();
    } catch (e) {
      view?.showWithoutPlayer();
    }
  }

  void updateLink(String link) async {
    try {
      final url = await resolver.resolve(link);
      final result = await http.post("http://185.143.145.119/b/rooms/update",
          headers: {"Cookie": await cookieStorage.readCookies()},
          body: {"roomId": room.id, "videoLink": link});

      final resultJson = json.decode(result.body);
      room = parseFromJson(resultJson);

      view?.showPlayer(url);
    } catch (e) {
      view?.showUrlUpdateError();
    }
  }

  void refresh() async {
    view?.showPlayerProgress();
    try {
      final response = await http.get(
          "http://185.143.145.119/b/rooms/id/${room.id}",
          headers: {"Cookie": await cookieStorage.readCookies()});

      final roomJson = json.decode(response.body);
      room = parseFromJson(roomJson);
      await _resolveUrl();
    } catch (e) {
      view?.showWithoutPlayer();
    }
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

  void dispose() {
    mqttManager.dispose();
  }

  bool get hasLink => room?.videoLink?.isNotEmpty ?? false;
}

abstract class ScreenShareView {
  void showProgress();

  void showUrlUpdateError();

  void showPlayerProgress();
  void showWithoutPlayer();
  void showPlayer(String url);
}
