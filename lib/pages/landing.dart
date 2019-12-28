import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'package:not_bored/services/friends.dart';
import 'package:not_bored/services/auth.dart';

import 'package:not_bored/pages/home.dart';
import 'package:not_bored/pages/about.dart';
import 'package:not_bored/pages/info.dart';
//import 'package:not_bored/pages/searchbar.dart';
import 'package:not_bored/pages/searchbarTest.dart';
import 'package:not_bored/pages/my_friends.dart';
import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/pages/notifications.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _LandingPageState createState() => _LandingPageState();
}

const PrimaryColor = const Color(0xFFf96327);
var list;
Map<String, dynamic> friendTest = new Map<String, dynamic>();

var finalList=[];

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
  StreamSubscription iosSubscription;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    addFriend();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {});

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

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

  void addFriend() async {
   
   
    list = Firestore.instance.collection('users').snapshots();
    list.forEach((index) {
     // print(index);
      if (index != null) {
        index.documents.forEach((index1) {
         // print(index1.data);
          if (index1.documentID != null) {
            friendTest[index1.documentID] = index1.data;
            finalList.add(index1.data);
           // print(finalList);
          }
        });
      }
    });

    //print(friendTest);

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
                                    request: new Friends(),
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
              backgroundColor: PrimaryColor,
              child: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
          
                 
                //  Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => SearchBar(
                //               auth: widget.auth,
                //               userId: widget.userId,
                //             )));
                
                // if(finalList.length!=0){
                //  showSearch(context: context, delegate: DataSearch(
                //   widget.auth,
                //   widget.userId,
                //  friendTest,
                //   finalList,
                //  ));
                // }
              //  for(var i=0;i<finalList.length;i++){
              //    print(finalList[i]['name']);
              //  }
                if(finalList.length!=0)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SearchBar(
                              auth: widget.auth,
                              userId: widget.userId,
                            map:friendTest,
                             list: finalList,
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
}

class LandingPageProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
