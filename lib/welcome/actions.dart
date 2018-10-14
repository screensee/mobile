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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Screen",
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
                Text("See",
                    style: TextStyle(
                        fontSize: 32.0,
                        color: Color(0xff0000ff),
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 24.0),
            OutlineButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              borderSide: BorderSide(color: Colors.black),
              child: Container(
                width: 200.0,
                child: Center(
                    child: Text(
                  "Join Room",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                )),
              ),
              onPressed: joinRoom,
            ),
            SizedBox(height: 16.0),
            OutlineButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              borderSide: BorderSide(color: Colors.black),
              child: Container(
                width: 200.0,
                child: Center(
                    child: Text(
                  "Create Room",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
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
