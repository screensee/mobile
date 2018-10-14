import 'package:screensee/mqtt_manager.dart';
import 'package:screensee/room.dart';

class PlayerPresenter {

  final MqttManager mqttManager;
  PlayerView view;

  String currentTimeTopic;
  String seekTopic;
  String playTopic;
  String pauseTopic;

  PlayerPresenter(this.mqttManager);

  void init(Room room) {
    currentTimeTopic = "room/${room.id}/currentTime";
    seekTopic = "room/${room.id}/seek";
    playTopic = "room/${room.id}/play";
    pauseTopic = "room/${room.id}/pause";

    mqttManager.stream.listen((payload) {
      if (payload.topic == currentTimeTopic) {
        view?.seekTo(0);
      }
      if (payload.topic == seekTopic) {
        view?.seekTo(0);
      }
      if (payload.topic == playTopic) {
        view?.showPlay();
      }
      if (payload.topic == pauseTopic) {
        view?.showPause();
      }
    });
  }

  void play() {
    mqttManager.publish(playTopic, message: "play");
  }

  void pause() {
    mqttManager.publish(pauseTopic, message: "pause");
  }

  void seekTo(int millis) {
    mqttManager.publish(seekTopic, message: millis.toString());
  }

  void updateTime(int newTimeMillis) {
    mqttManager.publish(currentTimeTopic, message: newTimeMillis.toString());
  }
}

abstract class PlayerView {

  void showPlay();
  void showPause();
  void seekTo(int millis);
}