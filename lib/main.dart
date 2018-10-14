import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screensee/create/create.dart';
import 'package:screensee/errors.dart';
import 'package:screensee/inject/inject.dart';
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
        primaryColor: Color(0xff0000ff),
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

class _MyHomePageState extends State<MyHomePage> implements HomeView {
  HomePresenter presenter;
  HomeState state = HomeState.LOADING;

  @override
  void initState() {
    presenter = HomePresenter(Injector.instance.userProvider);
    presenter.view = this;

    presenter.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case HomeState.DONE:
        return _buildActions();
      case HomeState.LOADING:
        return _buildLoading();
      default:
        return _buildError();
    }
  }

  _buildLoading() {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
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

  _buildError() {
    return Scaffold(body: Center(child: ErrorView(
      onRetry: () {
        presenter.retry();
      },
    )));
  }

  @override
  void showActions() {
    setState(() {
      state = HomeState.DONE;
    });
  }

  @override
  void showError() {
    setState(() {
      state = HomeState.ERROR;
    });
  }

  @override
  void showLoading() {
    setState(() {
      state = HomeState.LOADING;
    });
  }
}

enum HomeState { LOADING, DONE, ERROR }

class HomePresenter {
  final UserProvider userProvider;

  HomeView view;

  HomePresenter(this.userProvider);

  init() {
    _loadData();
  }

  retry() {
    _loadData();
  }

  _loadData() async {
    view?.showLoading();
    try {
      await userProvider.getUser();
      view?.showActions();
    } catch (e) {
      view?.showError();
    }
  }
}

abstract class HomeView {
  void showLoading();
  void showActions();
  void showError();
}
