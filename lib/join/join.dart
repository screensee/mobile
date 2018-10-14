import 'package:flutter/material.dart';
import 'package:screensee/inject/inject.dart';
import 'package:screensee/join/join_presenter.dart';
import 'package:screensee/room.dart';
import 'package:screensee/screenshare/screenshare.dart';

class JoinPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> implements JoinView {
  JoinPresenter presenter;

  ViewModel model;

  @override
  void initState() {
    presenter = JoinPresenter(Injector.instance.cookieStorage);
    model = ViewModel();

    presenter.view = this;

    super.initState();
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Join Room",
                      style: TextStyle(
                          fontSize: 24.0),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Room Name",
                        errorText: model.state == JoinState.ERROR
                            ? "Something went wrong"
                            : null),
                    onChanged: (value) {
                      setState(() {
                        model.roomId = value;
                      });
                    },
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        borderSide: BorderSide(color: Colors.black),
                        child: Container(
                            width: 300.0, child: Center(child: Text("JOIN"))),
                        onPressed: model.roomId.isNotEmpty &&
                                model.state != JoinState.LOADING
                            ? () {
                                presenter.joinRoom(model.roomId);
                              }
                            : null,
                      ),
                      model.state == JoinState.LOADING
                          ? Positioned(
                              right: 15.0,
                              child: SizedBox(
                                  width: 15.0,
                                  height: 15.0,
                                  child: CircularProgressIndicator()))
                          : SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void openRoom(Room room) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ScreenShare(room: room)));
  }

  @override
  void showError() {
    setState(() {
      model.state = JoinState.ERROR;
    });
  }

  @override
  void showProgress() {
    setState(() {
      model.state = JoinState.LOADING;
    });
  }
}

enum JoinState { LOADING, ERROR, CONTENT }

class ViewModel {
  String roomId = "";

  JoinState state = JoinState.CONTENT;
}
