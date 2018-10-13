import 'package:flutter/material.dart';

class ActionsPage extends StatelessWidget {
  
  final VoidCallback joinRoom;
  final VoidCallback createRoom;

  const ActionsPage({Key key, this.joinRoom, this.createRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Container(
                width: 200.0,
                child: Text("Join Room", textAlign: TextAlign.center),
              ),
              onPressed: joinRoom,
            ),
            RaisedButton(
              child: Container(
                width: 200.0,
                child: Text("Create Room", textAlign: TextAlign.center,),
              ),
              onPressed: createRoom,
            ),
          ],
        ),
      ),
    );
  }
}
