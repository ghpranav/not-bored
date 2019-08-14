import 'package:flutter/material.dart';

import 'package:not_bored/services/auth.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Home Page"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 180.0,
        width: 140.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: 'MainBtn',
            child: new Icon(
              Icons.sentiment_dissatisfied,
              size: 50.0,
              color: Colors.white54,
            ),
            backgroundColor: const Color(0xFFf96327),
            foregroundColor: Colors.white54,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
