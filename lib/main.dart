import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screensee/create/create.dart';
import 'package:screensee/join/join.dart';
import 'package:screensee/welcome/actions.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Screen See',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ActionsPage(
      joinRoom: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => JoinPage()));
      },
      createRoom: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePage()));
      },
    );
  }
}
