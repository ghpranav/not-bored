import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:not_bored/pages/home.dart';
import 'package:not_bored/pages/about.dart';
import 'package:not_bored/pages/info.dart';
import 'package:not_bored/pages/searchbar.dart';
import 'package:not_bored/pages/my_friends.dart';
import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/pages/notify_page.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _signOutClose() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
    Navigator.of(context).pop();
  }

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    DocumentReference _ref =
        Firestore.instance.collection('users').document(widget.userId);
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    } else {
      _ref.updateData(<String, dynamic>{
        'isMailVerified': true,
      });
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resend link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: _signOutClose,
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: _signOutClose,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LandingPageProvider>(context);
    var currentTab = [
      HomePage(),
      MyFriendsPage(
          userId: widget.userId, auth: widget.auth, user: widget.userId),
    ];

    return new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Splash();
          }
          var userDocument = snapshot.data;
          return new Scaffold(
            appBar: AppBar(
                backgroundColor: const Color(0xFFf96327),
                title: Text("Not Bored"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    tooltip: 'Air it',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => NotifPage(
                                    auth: widget.auth,
                                    userId: widget.userId,
                                  )));
                    },
                  )
                ]),
            drawer: Theme(
              data: Theme.of(context).copyWith(
                backgroundColor: const Color(0xFFf96327),
              ),
              child: Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(userDocument['name']),
                      accountEmail: Text(userDocument['email']),
                      decoration: BoxDecoration(color: const Color(0xFFf96327)),
                      currentAccountPicture: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => MyInfo(
                                        userId: widget.userId,
                                        auth: widget.auth,
                                      )));
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userDocument['imageURL']),
                        ),
                      ),
                      onDetailsPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => MyInfo(
                                      userId: widget.userId,
                                      auth: widget.auth,
                                    )));
                      },
                    ),
                    ListTile(
                      title: Text('About'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AboutPage()));
                      },
                    ),
                    ListTile(
                      title: Text('Log Out'),
                      onTap: _signOut,
                    )
                  ],
                ),
              ),
            ),
            body: currentTab[provider.currentIndex],
            floatingActionButton: FloatingActionButton(
              heroTag: 'SearchBtn',
              elevation: 4.0,
              backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DataSearch(
                              auth: widget.auth,
                              userId: widget.userId,
                            )));
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              color: const Color(0xFFf96327),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white),
                    onPressed: () => provider.currentIndex = 0,
                  ),
                  IconButton(
                    icon: Icon(Icons.people, color: Colors.white),
                    onPressed: () => provider.currentIndex = 1,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class LandingPageProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
