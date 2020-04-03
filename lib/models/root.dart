import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:not_bored/services/auth.dart';

import 'package:not_bored/pages/welcome.dart';

import 'package:not_bored/pages/landing.dart';
import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/pages/maintenance.dart';

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
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
   // _redirect();
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      _redirect();
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      _redirect();
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  _redirect() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection("server_maint")
        .document("killswitch")
        .get();

    ded = querySnapshot.data["shut"];
   // print(ded);
    /*if (ded == true) {
        Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MaintainPage()));
   }*/
    
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return Splash();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        if (ded == true) {
          return new MaintainPage();
        } else {
          return new WelcomePage(
            auth: widget.auth,
            onSignedIn: _onLoggedIn,
          );
        }
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          if (ded == true) {
            return new MaintainPage();
          } else {
            return new ChangeNotifierProvider<LandingPageProvider>(
              child: LandingPage(
                userId: _userId,
                auth: widget.auth,
                onSignedOut: _onSignedOut,
              ),
              builder: (BuildContext context) => LandingPageProvider(),
            );
          }
        } else
          return Splash();
        break;
      default:
        return Splash();
    }
  }
}
