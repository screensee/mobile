import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final String videoUrl;

  const Player(this.videoUrl, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {})
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _createVideoWidget();
  }

  _createVideoWidget() => _controller.value.initialized
      ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
      : SizedBox();
}
