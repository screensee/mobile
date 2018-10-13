import 'package:flutter/material.dart';

class CreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: screenSize.width / 2),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (!value.startsWith("https://www.youtube.com/")) {
                      return "Please enter valid youtube url";
                    }
                  },
                ),
                RaisedButton(
                  child: Text("Proceed"),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
