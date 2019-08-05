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

    DocumentReference _refMerec = _firestore
        .collection('users')
        .document(widget.userId)
        .collection('req_rec:' + widget.userId)
        .document(data['userid']);

    _refMe.updateData({
      'req_rec': FieldValue.arrayRemove([data['userid']]),
    });
    _refU.updateData({
      'req_sent': FieldValue.arrayRemove([widget.userId]),
    });
    _refMeF.setData(<String, dynamic>{
      'userid': data['userid'],
      'isBlocked': false,
    });
    _refUF.setData(<String, dynamic>{
      'userid': widget.userId,
      'isBlocked': false,
    });
    _refMerec.delete();
  }

  void rejectReq(data) async {
    DocumentReference _refMe =
        _firestore.collection('users').document(widget.userId);
    DocumentReference _refU =
        _firestore.collection('users').document(data['userid']);
    DocumentReference _refMerec = _firestore
        .collection('users')
        .document(widget.userId)
        .collection('req_rec:' + widget.userId)
        .document(data['userid']);
    _refMe.updateData({
      'req_rec': FieldValue.arrayRemove([data['userid']]),
    });
    _refU.updateData({
      'req_sent': FieldValue.arrayRemove([widget.userId]),
    });
    _refMerec.delete();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collectionGroup('req_rec:' + widget.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot1) {
          if (snapshot1.connectionState == ConnectionState.waiting) {
            return new Splash();
          }
          var reqRec = [];
          snapshot1.data.documents.forEach((index) {
            if (index.data['userid'] != null) {
              reqRec.add(index.data['userid']);
            }
          });
          print(reqRec);
          return Scaffold(
              body:
                  new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: reqRec.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new StreamBuilder(
                          stream: Firestore.instance
                              .collection('users')
                              .document(reqRec[index])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return new Splash();
                            }
                            var userDocument = snapshot.data;

                            return new Dismissible(
                              key: Key(reqRec[index]),
                              onDismissed: (direction) {
                                setState(() {
                                  rejectReq(userDocument);
                                });
                              },
                              background: Container(color: PrimaryColor),
                              child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userDocument['imageURL']),
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                        text: userDocument['name'],
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
                                                acceptReq(userDocument),
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15.0),
                                              ),
                                              onPressed: () =>
                                                  rejectReq(userDocument),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0)),
                                              color: Colors.deepOrange[900],
                                            ))
                                      ])),
                            );
                          });
                    }))
          ]));
        });
  }
}
