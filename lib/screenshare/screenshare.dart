import 'package:flutter/material.dart';
import 'package:screensee/chat/chat.dart';
import 'package:screensee/cookie.dart';
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
  final CookieStorage cookieStorage = CookieStorage();

  ScreensharePresenter presenter;
  WidgetBuilder currentBuilder;

  TextEditingController youtubeLinkController;

  @override
  void initState() {
    presenter = ScreensharePresenter(urlResolver, cookieStorage);
    youtubeLinkController = TextEditingController();

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
        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Color(0xff333333),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: youtubeLinkController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Set a valid YouTube url",
                              hintStyle: TextStyle(color: Colors.white54)),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        color: Colors.white,
                        onPressed: () {
                          presenter
                              .updateLink(youtubeLinkController.value.text);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        color: Colors.white,
                        onPressed: () {
                          presenter.refresh();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Chat(room: widget.room)),
          ],
        );
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

  @override
  void showPlayerProgress() {
    currentBuilder = (context) {
      return Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Color(0xff333333),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          Expanded(child: Chat(room: widget.room)),
        ],
      );
    };
  }
}
