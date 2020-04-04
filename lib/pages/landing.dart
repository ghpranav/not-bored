import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:not_bored/services/friends.dart';
import 'package:not_bored/services/auth.dart';
import 'package:not_bored/services/serve.dart';
import 'package:not_bored/services/notif.dart';
import 'package:not_bored/services/nbLoc.dart';

import 'package:not_bored/pages/home.dart';
import 'package:not_bored/pages/about.dart';
import 'package:not_bored/pages/info.dart';
import 'package:not_bored/pages/chat.dart';
import 'package:not_bored/pages/try.dart';

import 'package:not_bored/pages/searchbar.dart';
import 'package:not_bored/pages/my_friends.dart';
import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/pages/notifications.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  static String tag = 'landing-page';
  final BaseAuth auth;
  final FriendRequest request = new Friends();
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _LandingPageState createState() => _LandingPageState();
}

const PrimaryColor = const Color(0xFFf96327);

class _LandingPageState extends State<LandingPage> {
  bool show;
  hasNbMsg() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot querySnapshot =
        await Firestore.instance.collection("users").document(user.uid).get();
    var connectedTo = querySnapshot.data['connectedTo'];
    return connectedTo;
  }

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
  bool showNotification = false;
  StreamSubscription iosSubscription;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    search();
    var notif = new Notif();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {});

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      //when app is running
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if (message['data']['id'] == '2') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Reject'),
                  onPressed: () => {
                    widget.request
                        .rejectReq(widget.userId, message['data']['frndid']),
                    Navigator.of(context).pop(),
                  },
                ),
                FlatButton(
                  child: Text('Accept'),
                  onPressed: () => {
                    widget.request
                        .acceptReq(widget.userId, message['data']['frndid']),
                    Navigator.of(context).pop(),
                  },
                ),
              ],
            ),
          );
        } else if (message['data']['is'] == '1') {
          notif.notif1(message, context, widget);
        } else if (message['data']['id'] == '3') {
          var frndid = await getNBmsg();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                content: ListTile(
                  title: Text("Bored?"),
                  subtitle: Text("Wanna Chat?"),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Reject'),
                    onPressed: () => {
                      rejectNBmsg(widget.userId, frndid.toString()),
                      Navigator.of(context).pop(),
                    },
                  ),
                  FlatButton(
                    child: Text('Accept'),
                    onPressed: () => {
                      acceptNBmsg(widget.userId, frndid.toString()),
                      Navigator.of(context).pop(),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Chat(
                                    peerId: frndid.toString(),
                                    userId: widget.userId,
                                  ))),
                    },
                  ),
                ],
              );
            },
          );

          await pause(const Duration(seconds: 15));
          if (await hasNbMsg() == "null") Navigator.of(context).pop();
        } else if (message['data']['id'] == '4') {
          var frndid = message['data']['frndid'];
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                content: ListTile(
                  title: Text("Bored?"),
                  subtitle: Text("Wanna Meet?"),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Reject'),
                    onPressed: () => {
                      rejectNBLoc(widget.userId, frndid.toString()),
                      Navigator.of(context).pop(),
                    },
                  ),
                  FlatButton(
                    child: Text('Accept'),
                    onPressed: () async => {
                      acceptNBLoc(widget.userId, frndid.toString()),
                      Navigator.of(context).pop(),
                      // Splash(),
                      show = await showNBLoc(widget.userId, frndid.toString()),
                      if (show)
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Try())),
                        }
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      //when app is not running
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        if (message['data']['id'] == '2') {
          notif.notif2(message, context, widget);
        } else if (message['data']['id'] == '1') {
          notif.notif1(message, context, widget);
        } else if (message['data']['id'] == '3') {
          notif.notif3(message, context, widget);
        }
      },
      //when app is in background
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        if (message['data']['id'] == '2') {
          notif.notif2(message, context, widget);
        } else if (message['data']['id'] == '1') {
          notif.notif1(message, context, widget);
        } else if (message['data']['id'] == '3') {
          notif.notif3(message, context, widget);
        }
      },
    );

    _checkEmailVerification();

    // _resetConnected();
    _checkConnectedTo();
  }

  void _checkConnectedTo() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .document(widget.userId)
        .get();
    var connectedTo = querySnapshot.data['connectedTo'];
    if (connectedTo != 'null') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Chat(
                    userId: widget.userId,
                    peerId: connectedTo.toString(),
                  )));
    }
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
      HomePage(userId: widget.userId, auth: widget.auth, user: widget.userId),
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
                                    request: widget.request,
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
                      title: Text('About Us'),
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
                      title: Text('Surprise'),
                      onTap: _surprise,
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
              heroTag: null,
              elevation: 4.0,
              backgroundColor: PrimaryColor,
              child: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                provider._currentIndex = 0;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SearchBar(
                              auth: widget.auth,
                              userId: widget.userId,
                              list: finalList,
                              onSignedOut: widget.onSignedOut,
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

  @override
  void dispose() {
    iosSubscription.cancel();
    super.dispose();
  }

  _surprise() async {
    var rng = new Random();
    int a = rng.nextInt(11) + 1;

    String ab;
    ab = a.toString();

    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection("randomsites")
        .document("link")
        .get();

    var url = querySnapshot.data[ab];

    launch(url);
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
