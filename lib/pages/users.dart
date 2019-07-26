import 'package:flutter/material.dart';
import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:not_bored/pages/my_friends.dart';

class Users extends StatefulWidget {
  Users({Key key, this.auth, this.userId, this.data}) : super(key: key);

  final BaseAuth auth;
  final String userId;
  final data;
  @override
  _UsersState createState() => _UsersState();
}

const PrimaryColor = const Color(0xFFf96327);

class _UsersState extends State<Users> {
  final Firestore _firestore = Firestore.instance;

  void sendReq() async {
    DocumentReference _refMe =
        _firestore.collection('users').document(widget.userId);
    DocumentReference _refU =
        _firestore.collection('users').document(widget.data['userid']);
    _refMe.updateData({
      'req_sent': FieldValue.arrayUnion([widget.data['userid']]),
    });
    _refU.updateData({
      'req_rec': FieldValue.arrayUnion([widget.userId]),
    });
  }

  void cancelReq() async {
    DocumentReference _refMe =
        _firestore.collection('users').document(widget.userId);
    DocumentReference _refU =
        _firestore.collection('users').document(widget.data['userid']);
    _refMe.updateData({
      'req_sent': FieldValue.arrayRemove([widget.data['userid']]),
    });
    _refU.updateData({
      'req_rec': FieldValue.arrayRemove([widget.userId]),
    });
  }

  void acceptReq() async {
    DocumentReference _refMe =
        _firestore.collection('users').document(widget.userId);
    DocumentReference _refU =
        _firestore.collection('users').document(widget.data['userid']);
    DocumentReference _refMeF = _firestore
        .collection('users')
        .document(widget.userId)
        .collection(widget.userId)
        .document(widget.data['userid']);
    DocumentReference _refUF = _firestore
        .collection('users')
        .document(widget.data['userid'])
        .collection(widget.data['userid'])
        .document(widget.userId);
    _refMe.updateData({
      'req_rec': FieldValue.arrayRemove([widget.data['userid']]),
    });
    _refU.updateData({
      'req_sent': FieldValue.arrayRemove([widget.userId]),
    });
    _refMeF.setData(<String, dynamic>{
      'userid': widget.data['userid'],
      'isBlocked': false,
    });
    _refUF.setData(<String, dynamic>{
      'userid': widget.userId,
      'isBlocked': false,
    });
  }

  void rejectReq() async {
    DocumentReference _refMe =
        _firestore.collection('users').document(widget.userId);
    DocumentReference _refU =
        _firestore.collection('users').document(widget.data['userid']);
    _refMe.updateData({
      'req_rec': FieldValue.arrayRemove([widget.data['userid']]),
    });
    _refU.updateData({
      'req_sent': FieldValue.arrayRemove([widget.userId]),
    });
  }

  void removeFrnd() async {
    DocumentReference _refMeF = _firestore
        .collection('users')
        .document(widget.userId)
        .collection(widget.userId)
        .document(widget.data['userid']);
    DocumentReference _refUF = _firestore
        .collection('users')
        .document(widget.data['userid'])
        .collection(widget.data['userid'])
        .document(widget.userId);
    _refMeF.delete();
    _refUF.delete();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          automaticallyImplyLeading: true,
          title: Text(widget.data['username']),
        ),
        body: new Stack(
          children: <Widget>[
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height / 9,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 180.0,
                        height: 180.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                              image: NetworkImage(widget.data['imageURL']),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                        ))
                  ],
                )),
            Positioned(
              bottom: 270.0,
              left: 70.0,
              child: Text(
                widget.data['name'],
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
            Positioned(
              bottom: 215.0,
              left: 100.0,
              child: Text(
                widget.data['status'],
                style: TextStyle(
                    fontSize: 22.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat'),
              ),
            ),
            StreamBuilder(
              stream:
                  Firestore.instance.collectionGroup(widget.userId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot1) {
                if (snapshot1.connectionState == ConnectionState.waiting)
                  return new Splash();
                bool flag = false;
                snapshot1.data.documents.forEach((index) {
                  if (index.data['userid'] == widget.data['userid']) {
                    flag = true;
                  }
                });
                if (flag) {
                  return new Positioned(
                      bottom: 30.0,
                      left: 20.0,
                      height: 55.0,
                      width: 150.0,
                      child: RaisedButton(
                        child: Text("Unfriend"),
                        onPressed: removeFrnd,
                      ));
                } else {
                  return new StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(widget.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return new Text('Loading...');
                        }
                        var myDocument = snapshot.data;
                        if (myDocument['req_sent']
                            .contains(widget.data['userid'])) {
                          return new Positioned(
                              bottom: 30.0,
                              left: 20.0,
                              height: 55.0,
                              width: 150.0,
                              child: RaisedButton(
                                child: Text("Cancel Request"),
                                onPressed: cancelReq,
                              ));
                        } else if (myDocument['req_rec']
                            .contains(widget.data['userid'])) {
                          return new Positioned(
                              child: Stack(
                            children: <Widget>[
                              Positioned(
                                  bottom: 100.0,
                                  left: 20.0,
                                  height: 55.0,
                                  width: 150.0,
                                  child: RaisedButton(
                                    child: Text("Accept"),
                                    onPressed: acceptReq,
                                  )),
                              Positioned(
                                  bottom: 30.0,
                                  left: 20.0,
                                  height: 55.0,
                                  width: 150.0,
                                  child: RaisedButton(
                                    onPressed: rejectReq,
                                    child: Text('Reject'),
                                  ))
                            ],
                          ));
                        } else {
                          return new Positioned(
                              bottom: 30.0,
                              left: 20.0,
                              height: 55.0,
                              width: 150.0,
                              child: RaisedButton(
                                child: Text("Send Request"),
                                onPressed: sendReq,
                              ));
                        }
                      });
                }
              },
            ),
            Positioned(
                bottom: 30.0,
                right: 20.0,
                height: 55.0,
                width: 150.0,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.orangeAccent,
                  color: Colors.deepOrange,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MyFriendsPage(
                                    userId: widget.data['userid'],
                                    auth: widget.auth,
                                  )));
                    },
                    child: Center(
                      child: Text(
                        "Friends",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }
}
