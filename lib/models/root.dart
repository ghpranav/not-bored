import 'package:flutter/material.dart';
import 'package:not_bored/pages/maintenance.dart';
import 'package:provider/provider.dart';

import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:not_bored/pages/welcome.dart';

import 'package:not_bored/pages/landing.dart';
import 'package:not_bored/pages/splash.dart';

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
  bool ded;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() async {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
        await _redirect();
      });
    });
  }

  void _onLoggedIn() async {
    await _redirect();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() async {
    await _redirect();
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Future<void> _redirect() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection("server_maint")
        .document("killswitch")
        .get();
    setState(() {
      ded = querySnapshot.data["shut"];
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return Splash();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return ded
            ? MaintainPage()
            : new WelcomePage(
                auth: widget.auth,
                onSignedIn: _onLoggedIn,
              );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return ded
              ? MaintainPage()
              : new ChangeNotifierProvider<LandingPageProvider>(
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
