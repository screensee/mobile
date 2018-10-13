import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

const VIDEO_URL =
    "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4";

class Player extends StatefulWidget {
  final String videoUrl;

  const Player({Key key, this.videoUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(VIDEO_URL)
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
    return Center(child: _createVideoWidget());
  }

  _createVideoWidget() => _controller.value.initialized
      ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
      : SizedBox();
}
