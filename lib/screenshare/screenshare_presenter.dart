import 'package:screensee/room.dart';
import 'package:screensee/screenshare/resolver.dart';

class ScreensharePresenter {
  final UrlResolver resolver;
  ScreenShareView view;
  Room room;

  ScreensharePresenter(this.resolver);

  void initRoom(Room room) {
    this.room = room;

    view?.showProgress();
    _resolveUrl();
  }

  void updateLink(String link) {
    room = Room(room.id, room.participants, link, room.pseudonym);

    _resolveUrl();
  }

  _resolveUrl() async {
    try {
      if (hasLink) {
        final url = await resolver.resolve(room.videoLink);
        view?.showPlayer(url);
      } else {
        view?.showWithoutPlayer();
      }
    } catch (e) {
      view?.showError();
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
