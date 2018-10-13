import 'package:flutter/material.dart';
import 'package:screensee/chat/chat.dart';
import 'package:screensee/player/player.dart';
import 'package:screensee/room.dart';
import 'package:screensee/screenshare/resolver.dart';
import 'package:screensee/screenshare/screenshare_presenter.dart';

class ScreenShare extends StatefulWidget {
  final Room room;

  const ScreenShare({Key key, this.room}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenShareState();
}

class _ScreenShareState extends State<ScreenShare> implements ScreenShareView {
  final YoutubeUrlResolver urlResolver = YoutubeUrlResolver();

  ScreensharePresenter presenter;
  WidgetBuilder currentBuilder;

  @override
  void initState() {
    presenter = ScreensharePresenter(urlResolver);
    currentBuilder = (context) {
      return Center(child: CircularProgressIndicator());
    };

    presenter.view = this;

    presenter.initRoom(widget.room);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: Text(widget.room.pseudonym),
      ),
      body: currentBuilder(context),
    );
  }

  @override
  void showError() {
    setState(() {
      currentBuilder = (context) {
        return Text("error");
      };
    });
  }

  @override
  void showPlayer(String url) {
    setState(() {
      currentBuilder = (context) {
        return Column(
          children: <Widget>[
            Player(url),
            Expanded(
              child: Chat(room: widget.room),
            ),
          ],
        );
      };
    });
  }

  @override
  void showWithoutPlayer() {
    setState(() {
      currentBuilder = (context) {
        return Chat(room: widget.room);
      };
    });
  }

  @override
  void showProgress() {
    setState(() {
      currentBuilder = (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      };
    });
  }
}
