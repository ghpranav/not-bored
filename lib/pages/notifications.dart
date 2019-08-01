import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotifPage extends StatefulWidget {
  @override
  NotifPage({Key key, this.userId}) : super(key: key);
  final String userId;
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  
  final Firestore _db = Firestore.instance;
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
    
    _fcm.getToken().then((token){
      print("token=");
      print(token);
    });
  }

 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: const Color(0xFFf96327)
      ),
    );
  }

   _saveDeviceToken() async {
    String uid = widget.userId;
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