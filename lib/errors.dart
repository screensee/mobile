import 'package:flutter/material.dart';

class ApiException implements Exception {}

class ErrorView extends StatelessWidget {

  final VoidCallback onRetry;
  const ErrorView({Key key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.error_outline,
          size: 48.0,
          color: Colors.red
        ),
        SizedBox(height: 8.0),
        Text("Something went wrong!",
        style: TextStyle(fontSize: 18.0),),
        SizedBox(height: 8.0),
        RaisedButton(
          child: Text("RETRY"),
          onPressed: onRetry,
        )
      ],
    );
  }
}