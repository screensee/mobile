import 'package:flutter/material.dart';

class ActionsPage extends StatelessWidget {
  final VoidCallback joinRoom;
  final VoidCallback createRoom;

  const ActionsPage({Key key, this.joinRoom, this.createRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              child: Container(
                width: 200.0,
                height: 200.0,
                child: Center(
                    child: Text(
                  "Join Room",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0),
                )),
              ),
              onPressed: joinRoom,
            ),
            SizedBox(height: 40.0),
            OutlineButton(
              child: Container(
                width: 200.0,
                height: 200.0,
                child: Center(
                    child: Text(
                  "Create Room",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0),
                )),
              ),
              onPressed: createRoom,
            ),
          ],
        ),
      ),
    );
  }
}
