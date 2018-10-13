import 'package:screensee/room.dart';
import 'package:screensee/screenshare/resolver.dart';

class ScreensharePresenter {
  final UrlResolver resolver;

  ScreenShareView view;
  Room room;

  ScreensharePresenter(this.resolver);

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
    if (hasLink) {
      final url = await resolver.resolve(room.videoLink);
      view?.showPlayer(url);
    } else {
      view?.showWithoutPlayer();
    }
  }

  bool get hasLink => room?.videoLink?.isNotEmpty ?? false;
}

abstract class ScreenShareView {
  void showProgress();
  void showError();

  void showWithoutPlayer();
  void showPlayer(String url);
}
