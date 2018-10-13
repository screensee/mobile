import 'package:flutter/material.dart';
import 'package:screensee/cookie.dart';
import 'package:screensee/create/create_presenter.dart';
import 'package:screensee/room.dart';
import 'package:screensee/screenshare/screenshare.dart';

class CreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> implements CreateView {
  CreatePresenter presenter;
  ViewModel model;

  @override
  void initState() {
    model = ViewModel();
    presenter = CreatePresenter(CookieStorage());

    presenter.view = this;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _buildForm(),
        ),
      ),
    );
  }

  _buildForm() {
    return Container(
      padding: EdgeInsets.only(top: 32.0),
      constraints: BoxConstraints(maxWidth: 300.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              model.link = value;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "YouTube link"),
          ),
          SizedBox(height: 24.0),
          TextField(
            onChanged: (value) {
              model.password = value;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Password (optional)"),
          ),
          SizedBox(height: 24.0),
          RaisedButton(
            child: Container(
                width: 300.0,
                child: Stack(
                  children: <Widget>[
                    Center(child: Text("CREATE")),
                    model.isProgress
                        ? Positioned(
                            right: 15.0,
                            child: SizedBox(
                                width: 15.0,
                                height: 15.0,
                                child: CircularProgressIndicator()),
                          )
                        : SizedBox()
                  ],
                )),
            onPressed: !model.isProgress
                ? () {
                    model.isProgress = false;
                    model.isError = false;
                    presenter.createRoom(
                        link: model.link, password: model.password);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  @override
  void openRoom(Room room) {
    setState(() {
      model.isProgress = false;
      model.isError = false;
    });

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ScreenShare(room: room)));
  }

  @override
  void showError() {
    setState(() {
      model.isError = true;
      model.isProgress = false;
    });
  }

  @override
  void showProgress() {
    setState(() {
      model.isError = false;
      model.isProgress = true;
    });
  }
}

class ViewModel {
  String link;
  String password;

  bool isError = false;
  bool isProgress = false;
}
