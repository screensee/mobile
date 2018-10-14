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
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Room Name"),
                    onChanged: (value) {
                      setState(() {
                        model.roomId = value;
                      });
                    },
                  ),
                  RaisedButton(
                    child: Container(
                        width: 300.0, child: Center(child: Text("JOIN"))),
                    onPressed: model.roomId.isNotEmpty
                        ? () {
                            presenter.joinRoom(model.roomId);
                          }
                        : null,
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
  void showError() {}

  @override
  void showProgress() {}
}

class ViewModel {
  String roomId = "";
}
