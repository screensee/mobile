import 'package:flutter/material.dart';
import 'package:screensee/chat/chat.dart';
import 'package:screensee/cookie.dart';
import 'package:screensee/inject/inject.dart';
import 'package:screensee/mqtt_manager.dart';
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
  final UrlResolver urlResolver = Injector.instance.urlResolver;
  final CookieStorage cookieStorage = Injector.instance.cookieStorage;
  final MqttManager mqttManager = Injector.instance.mqttManager;

  ScreensharePresenter presenter;
  ScreenShareState state;

  TextEditingController youtubeLinkController;

  @override
  void initState() {
    presenter = ScreensharePresenter(urlResolver, cookieStorage, mqttManager);
    youtubeLinkController = TextEditingController();

    presenter.view = this;

    presenter.initRoom(widget.room);

    super.initState();
  }

  @override
    void dispose() {
      presenter.dispose();
      super.dispose();
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

  _buildBody() {
    if (state is LoadingState) {
      return _buildProgress();
    }
    if (state is DataState) {
      final dataState = state as DataState;
      return _buildPlayer(dataState.room, dataState.url);
    }
    if (state is NoPlayerState) {
      return _buildNoPlayer((state as NoPlayerState).error);
    }
    if (state is PlayerLoadingState) {
      return _buildPlayerProgress();
    }

    return Text("error");
  }

  _buildProgress() {
    return Center(child: CircularProgressIndicator());
  }

  _buildPlayer(Room room, String url) {
    return Column(
      children: <Widget>[
        Player(room, url),
        Expanded(
          child: Chat(room: widget.room),
        ),
      ],
    );
  }

  _buildNoPlayer(String error) {
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
                          hintStyle: TextStyle(color: Colors.white54),
                          errorText: error),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    color: Colors.white,
                    onPressed: () {
                      presenter.updateLink(youtubeLinkController.value.text);
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
  }

  _buildPlayerProgress() {
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
  }

  @override
  void showPlayer(Room room, String url) {
    setState(() {
      state = DataState(room, url);
    });
  }

  @override
  void showWithoutPlayer() {
    setState(() {
      state = NoPlayerState();
    });
  }

  @override
  void showProgress() {
    setState(() {
      state = LoadingState();
    });
  }

  @override
  void showPlayerProgress() {
    setState(() {
      state = PlayerLoadingState();
    });
  }

  @override
  void showUrlUpdateError() {
    setState(() {
      state = NoPlayerState(error: "Invalid url");
    });
  }
}

abstract class ScreenShareState {}

class LoadingState implements ScreenShareState {
  const LoadingState();
}

class DataState implements ScreenShareState {
  final Room room;
  final String url;
  const DataState(this.room, this.url);
}

class PlayerLoadingState implements ScreenShareState {
  const PlayerLoadingState();
}

class NoPlayerState implements ScreenShareState {
  final String error;
  const NoPlayerState({this.error});
}
