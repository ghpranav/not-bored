import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:not_bored/services/auth.dart';
import 'package:not_bored/pages/splash.dart';

class NotifPage extends StatefulWidget {
  NotifPage({this.auth});

  final BaseAuth auth;

  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
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
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );

    _fcm.getToken().then((token) {});
    print('hey');
  }

  @override
  Widget build(BuildContext context) {
    return new Splash();
  }

  _saveDeviceToken() async {
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await widget.auth.getCurrentUser();
    String uid = user.uid;
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      DocumentReference _ref = _firestore.collection('users').document(uid);

      await _ref.updateData(<String, dynamic>{
        'tokens': fcmToken,
      });
    }
  }
}
