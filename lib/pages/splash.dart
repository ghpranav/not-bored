import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: Stack(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("Not Bored Loading")
        ],
      )),
    );
  }
}
