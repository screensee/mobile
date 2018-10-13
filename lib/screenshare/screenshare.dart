import 'package:flutter/material.dart';
import 'package:screensee/player/player.dart';
import 'package:screensee/room.dart';
import 'package:screensee/screenshare/chat.dart';
import 'package:screensee/screenshare/resolver.dart';

const VIDEO_URL = "https://www.youtube.com/watch?v=6O8eH-J6DHY";

class ScreenShare extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenShareState();
}

class _ScreenShareState extends State<ScreenShare> {
  final YoutubeUrlResolver urlResolver = YoutubeUrlResolver();

  Room room;

  String url;
  dynamic error;

  @override
  void initState() {
    _loadUrl();

    super.initState();
  }

  _loadUrl() async {
    try {
      url = await urlResolver.resolve(VIDEO_URL);
    } catch (e) {
      error = e;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black38,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (error != null) {
      return _buildError();
    }

    if (url != null) {
      return _buildScreenShare(url);
    }
    return Center(child: CircularProgressIndicator());
  }

  _buildScreenShare(String data) {
    return Column(
      children: <Widget>[
        Player(data),
        Expanded(
          child: Chat(),
        ),
      ],
    );
  }

  _buildError() {
    return Text("error");
  }
}
