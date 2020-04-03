import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:not_bored/services/auth.dart';

import 'package:not_bored/pages/welcome.dart';

import 'package:not_bored/pages/landing.dart';
import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/pages/privacyPolicy.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  method() => _RootPageState()._onLoggedIn();
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
        _privacypolicy1();
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  _privacypolicy1() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            title: Center(child: Text("User Agreement and Privacy Policy")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(privacy),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Accept User Agreement and Privacy Policy'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return Splash();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new WelcomePage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new ChangeNotifierProvider<LandingPageProvider>(
            child: LandingPage(
              userId: _userId,
              auth: widget.auth,
              onSignedOut: _onSignedOut,
            ),
            builder: (BuildContext context) => LandingPageProvider(),
          );
        } else
          return Splash();
        break;
      default:
        return Splash();
    }
  }
}
