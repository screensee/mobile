import 'package:flutter/material.dart';
import 'package:screensee/create/create_presenter.dart';
import 'package:screensee/inject/inject.dart';
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
    presenter = CreatePresenter(Injector.instance.cookieStorage);

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              model.pseudonym = value;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Room name (optional)"),
          ),
          SizedBox(height: 8.0),
          model.state == CreateState.ERROR
              ? Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.red),
                )
              : SizedBox(),
          SizedBox(height: 8.0),
          Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              RaisedButton(
                child: Container(
                    width: 300.0,
                    child: Stack(
                      children: <Widget>[
                        Center(child: Text("CREATE")),
                      ],
                    )),
                onPressed: model.state != CreateState.LOADING
                    ? () {
                        presenter.createRoom(
                            link: model.link, pseudonym: model.pseudonym);
                      }
                    : null,
              ),
              model.state == CreateState.LOADING
                  ? Positioned(
                      right: 15.0,
                      child: SizedBox(
                          width: 15.0,
                          height: 15.0,
                          child: CircularProgressIndicator()))
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void openRoom(Room room) {
    setState(() {
      model.state = CreateState.CONTENT;
    });

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ScreenShare(room: room)));
  }

  @override
  void showError() {
    setState(() {
      model.state = CreateState.ERROR;
    });
  }

  @override
  void showProgress() {
    setState(() {
      model.state = CreateState.LOADING;
    });
  }
}

enum CreateState { CONTENT, LOADING, ERROR }

class ViewModel {
  String link;
  String pseudonym;

  CreateState state = CreateState.CONTENT;
}
