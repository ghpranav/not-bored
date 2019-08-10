import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:not_bored/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:not_bored/pages/splash.dart';

class Notifications extends StatefulWidget {
  Notifications({this.auth});

  final BaseAuth auth;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    void configLocalNotification() {
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('app_icon');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
    }

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

    _fcm.getToken().then((token) {
      print("token=");
      print(token);
      configLocalNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Splash();
  }

  _saveDeviceToken() async {
    FirebaseUser user = await widget.auth.getCurrentUser();
    String uid = user.uid;
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
      });
    }
  }
}
