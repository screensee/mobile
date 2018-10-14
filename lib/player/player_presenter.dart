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

    mqttManager.subscribeToTopic(currentTimeTopic);
    mqttManager.subscribeToTopic(seekTopic);
    mqttManager.subscribeToTopic(playTopic);
    mqttManager.subscribeToTopic(pauseTopic);

    mqttManager.stream.listen((payload) {
      if (payload.topic == "room/${room.id}/currentTime") {
        view?.seekTo(0);
      }
      if (payload.topic == "room/${room.id}/seek") {
        view?.seekTo(0);
      }
      if (payload.topic == "room/${room.id}/play") {
        view?.showPlay();
      }
      if (payload.topic == "room/${room.id}/pause") {
        view?.showPause();
      }
    });
  }

  void play() {
    view?.showPlay();
    mqttManager.publish(playTopic);
  }

  void pause() {
    view?.showPause();
    mqttManager.publish(pauseTopic);
  }

  void seekTo(int millis) {
    view?.seekTo(millis);
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