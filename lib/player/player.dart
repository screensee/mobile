import 'dart:async';

import 'package:screensee/inject/inject.dart';
import 'package:screensee/player/player_presenter.dart';
import 'package:screensee/room.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final Room room;
  final String url;

  const Player(this.room, this.url, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<Player> implements PlayerView {
  PlayerPresenter presenter;

  PlayerState playerState = PlayerState.PAUSE;
  VideoPlayerController _controller;

  Timer timer;

  @override
  void initState() {
    presenter = PlayerPresenter(Injector.instance.mqttManager);
    presenter.init(widget.room);
    presenter.view = this;

    _controller = VideoPlayerController.network(widget.url)
      ..addListener(() {})
      ..initialize().then((_) {
        setState(() {
          playerState = PlayerState.PLAYING;
          presenter.play();
        });

        timer = updatePosition();
      });

    super.initState();
  }

  updatePosition() {
    const oneSec = const Duration(seconds: 1);
    return Timer.periodic(oneSec, (Timer t) => presenter.updateTime(_controller.value.position.inSeconds));
  }

  @override
  void dispose() {
    _controller.dispose();

    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _createVideoWidget();
  }

  _createVideoWidget() => _controller.value.initialized
      ? _buildVideoWidget()
      : AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Color(0xff1a1a1a),
            child: Center(child: CircularProgressIndicator()),
          ),
        );

  _buildVideoWidget() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        playerState == PlayerState.PAUSE
            ? IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 48.0,
                color: Colors.white,
                onPressed: () {
                  presenter.play();
                },
              )
            : IconButton(
                icon: Icon(Icons.pause),
                iconSize: 48.0,
                color: Colors.white,
                onPressed: () {
                  presenter.pause();
                },
              )
      ],
    );
  }

  @override
  void seekTo(int seconds) {
    _controller.seekTo(Duration(seconds: seconds));
  }

  @override
  void showPause() {
    setState(() {
      playerState = PlayerState.PAUSE;
      _controller.pause();
    });
  }

  @override
  void showPlay() {
    setState(() {
      playerState = PlayerState.PLAYING;
      _controller.play();
    });
  }
}

enum PlayerState { PLAYING, PAUSE }
