import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:not_bored/pages/splash.dart';

class NotifPage extends StatefulWidget {
  NotifPage({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;
  @override
  _NotifPageState createState() => _NotifPageState();
}

const PrimaryColor = const Color(0xFFf96327);

class _NotifPageState extends State<NotifPage> {
  final Firestore _firestore = Firestore.instance;
  void acceptReq(data) async {
    DocumentReference _refMe =
        _firestore.collection('users').document(widget.userId);
    DocumentReference _refU =
        _firestore.collection('users').document(data['userid']);
    DocumentReference _refMeF = _firestore
        .collection('users')
        .document(widget.userId)
        .collection(widget.userId)
        .document(data['userid']);

    DocumentReference _refUF = _firestore
        .collection('users')
        .document(data['userid'])
        .collection(data['userid'])
        .document(widget.userId);

    _refMe.updateData({
      'req_rec': FieldValue.arrayRemove([data['userid']]),
    });
    _refU.updateData({
      'req_sent': FieldValue.arrayRemove([widget.userId]),
    });
    _refMe.collection('req_rec').document(data['userid']).delete();
    _refMeF.setData(<String, dynamic>{
      'userid': data['userid'],
      'isBlocked': false,
    });
    _refUF.setData(<String, dynamic>{
      'userid': widget.userId,
      'isBlocked': false,
    });
  }

  void rejectReq(data) async {
    DocumentReference _refMe =
        _firestore.collection('users').document(widget.userId);
    DocumentReference _refU =
        _firestore.collection('users').document(data['userid']);
    _refMe.updateData({
      'req_rec': FieldValue.arrayRemove([data['userid']]),
    });
    _refU.updateData({
      'req_sent': FieldValue.arrayRemove([widget.userId]),
    });
    _refMe.collection('req_rec').document(data['userid']).delete();
  }

  @override
  Widget build(BuildContext context) {
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
        if (userDocument['req_rec'].length == 0) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Notifications'),
              ),
              body: Center(
                child: TyperAnimatedTextKit(
                  duration: const Duration(seconds: 3),
                  text: ['You have no pending requests'],
                  textStyle: TextStyle(
                    fontSize: 25.0,
                    color: PrimaryColor,
                  ),
                  textAlign: TextAlign.start,
                  alignment: AlignmentDirectional.topStart,
                ),
              ));
        } else
          return Scaffold(
            appBar: AppBar(
              title: Text('Notifications'),
            ),
            body: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: userDocument['req_rec'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return new StreamBuilder(
                            stream: Firestore.instance
                                .collection('users')
                                .document(userDocument['req_rec'][index])
                                .snapshots(),
                            builder: (context, snapshot1) {
                              if (!snapshot1.hasData) {
                                return new Splash();
                              }
                              var friendDocument = snapshot1.data;
                              return Dismissible(
                                key: Key(userDocument['req_rec'][index]),
                                onDismissed: (direction) {
                                  setState(() async {
                                    rejectReq(friendDocument);
                                  });
                                },
                                background: Container(color: PrimaryColor),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        friendDocument['imageURL']),
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                        text: friendDocument['name'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text:
                                                  ' has sent you friend request',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ]),
                                  ),
                                  subtitle: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0.0, 0.0, 1.0, 0.0),
                                        child: MaterialButton(
                                          child: Text(
                                            "Accept",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15.0),
                                          ),
                                          onPressed: () =>
                                              acceptReq(friendDocument),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)),
                                          color: PrimaryColor,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            3.0, 0.0, 0.0, 0.0),
                                        child: MaterialButton(
                                          child: Text(
                                            "Reject",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15.0),
                                          ),
                                          onPressed: () =>
                                              rejectReq(friendDocument),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)),
                                          color: Colors.deepOrange[900],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }),
                ),
              ],
            ),
          );
      },
    );
  }
}
