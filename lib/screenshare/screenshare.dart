import 'package:flutter/material.dart';
import 'package:screensee/screenshare/player.dart';
import 'package:screensee/screenshare/resolver.dart';

const VIDEO_URL = "https://www.youtube.com/watch?v=6O8eH-J6DHY";

class ScreenShare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: YoutubeUrlResolver().resolve(VIDEO_URL),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return _buildError();
              }
              return _buildScreen(snapshot.data);
            default:
              return SizedBox();
          }
        },
      ),
    );
  }

  _buildScreen(String data) {
    return Column(
      children: <Widget>[
        Player(data),
      ],
    );
  }

  _buildError() {
    return Text("error");
  }
}
