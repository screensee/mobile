import 'package:flutter/material.dart';
import 'package:screensee/screenshare/screenshare.dart';

class JoinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 32.0),
            constraints: BoxConstraints(maxWidth: 300.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Room Id"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the chat room.';
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      child: Text("Proceed"),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => ScreenShare())
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JoinBloc {}
