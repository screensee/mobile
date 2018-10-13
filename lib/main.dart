import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screensee/cookie.dart';
import 'package:screensee/create/create.dart';
import 'package:screensee/join/join.dart';
import 'package:screensee/user.dart';
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
        backgroundColor: Colors.white,
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
  ScreenShareUserProvider provider;

  @override
  void initState() {
    provider = ScreenShareUserProvider(
      CookieStorage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: provider.getUser(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _buildActions();
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _buildActions() {
    return ActionsPage(
      joinRoom: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => JoinPage()));
      },
      createRoom: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreatePage()));
      },
    );
  }
}
