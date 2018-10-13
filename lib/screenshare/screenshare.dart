import 'package:flutter/material.dart';
import 'package:screensee/player/player.dart';
import 'package:screensee/room.dart';
import 'package:screensee/screenshare/chat.dart';
import 'package:screensee/screenshare/resolver.dart';

class ScreenShare extends StatefulWidget {
  final Room room;

  const ScreenShare({Key key, this.room}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenShareState();
}

class _ScreenShareState extends State<ScreenShare> {
  final YoutubeUrlResolver urlResolver = YoutubeUrlResolver();

  String url;
  dynamic error;

  @override
  void initState() {
    _loadUrl();

    super.initState();
  }

  _loadUrl() async {
    if (widget.room.videoLink == "") return;

    try {
      url = await urlResolver.resolve(widget.room.videoLink);
    } catch (e) {
      error = e;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: Text(widget.room.pseudonym),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (error != null) {
      return _buildError();
    }

    if (widget.room.videoLink == "" || url != null) {
      return _buildScreenShare(url);
    }
    return Center(child: CircularProgressIndicator());
  }

  _buildScreenShare(String data) {
    return Column(
      children: <Widget>[
        widget.room.videoLink == "" ? SizedBox() : Player(data),
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
