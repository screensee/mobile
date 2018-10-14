import 'package:screensee/mqtt_manager.dart';
import 'package:screensee/room.dart';

class PlayerPresenter {
  final MqttManager mqttManager;
  PlayerView view;

  Room room;
  int currentTimeSeconds = 0;

  String currentTimeTopic;
  String seekTopic;
  String playTopic;
  String pauseTopic;

  PlayerPresenter(this.mqttManager);

  void init(Room room) {
    this.room = room;

    currentTimeTopic = "room/${room.id}/currentTime";
    seekTopic = "room/${room.id}/seek";
    playTopic = "room/${room.id}/play";
    pauseTopic = "room/${room.id}/pause";

    mqttManager.stream.listen((payload) {
      if (payload.topic == currentTimeTopic) {
        final newTime = int.parse(payload.message);
        if (!room.isMaster && (currentTimeSeconds - newTime).abs() >= 5) {
          currentTimeSeconds = newTime;
          view?.seekTo(newTime);
        }
      }
      if (payload.topic == seekTopic) {
        view?.seekTo(int.parse(payload.message));
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

  void seekTo(int seconds) {
    mqttManager.publish(seekTopic, message: seconds.toString());
  }

  void updateTime(int seconds) {
    currentTimeSeconds = seconds;
    if (room.isMaster) {
      mqttManager.publish(currentTimeTopic, message: seconds.toString());
    }
  }
}

abstract class PlayerView {
  void showPlay();
  void showPause();
  void seekTo(int seconds);
}
