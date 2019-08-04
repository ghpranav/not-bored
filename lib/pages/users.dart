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
    DocumentReference _refUrec = _firestore
        .collection('users')
        .document(widget.data['userid'])
        .collection('req_rec')
        .document(widget.userId);
    _refMe.updateData({
      'req_sent': FieldValue.arrayUnion([widget.data['userid']]),
    });
    _refU.updateData({
      'req_rec': FieldValue.arrayUnion([widget.userId]),
    });
    _refUrec.setData(<String, dynamic>{
      'userid': widget.userId,
      
    });
  }

  void cancelReq() async {
    DocumentReference _refMe =
        _firestore.collection('users').document(widget.userId);
    DocumentReference _refU =
        _firestore.collection('users').document(widget.data['userid']);
    DocumentReference _refUrec = _firestore
        .collection('users')
        .document(widget.data['userid'])
        .collection('req_rec')
        .document(widget.userId);
    _refMe.updateData({
      'req_sent': FieldValue.arrayRemove([widget.data['userid']]),
    });
    _refU.updateData({
      'req_rec': FieldValue.arrayRemove([widget.userId]),
    });
    _refUrec.delete();
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

    DocumentReference _refMerec = _firestore
        .collection('users')
        .document(widget.userId)
        .collection('req_rec')
        .document(widget.data['userid']);

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
    _refMerec.delete();
  }

  void rejectReq() async {
    DocumentReference _refMe =
        _firestore.collection('users').document(widget.userId);
    DocumentReference _refU =
        _firestore.collection('users').document(widget.data['userid']);
    DocumentReference _refMerec = _firestore
        .collection('users')
        .document(widget.userId)
        .collection('req_rec')
        .document(widget.data['userid']);
    _refMe.updateData({
      'req_rec': FieldValue.arrayRemove([widget.data['userid']]),
    });
    _refU.updateData({
      'req_sent': FieldValue.arrayRemove([widget.userId]),
    });
    _refMerec.delete();
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
            ClipPath(
              child: Container(color: Colors.black.withOpacity(0.8)),
              clipper: GetClipper(),
            ),
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height / 7,
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
              bottom: MediaQuery.of(context).size.height / 3,
              left: MediaQuery.of(context).size.width / 10,
              child: Text(
                widget.data['name'],
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 4,
              left: MediaQuery.of(context).size.width / 10,
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
                      child: Stack(children: <Widget>[
                    Positioned(
                        bottom: 30.0,
                        left: 20.0,
                        height: 55.0,
                        width: 150.0,
                        child: MaterialButton(
                          child: Text(
                            "Unfriend",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0),
                          ),
                          onPressed: removeFrnd,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          color: Colors.deepOrange,
                          elevation: 7.0,
                        )),
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
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return Scaffold(
                                  appBar: AppBar(
                                    title: Text('Friends'),
                                  ),
                                  body: MyFriendsPage(
                                    userId: widget.userId,
                                    auth: widget.auth,
                                    user: widget.data['userid'],
                                  ),
                                );
                              }));
                            },
                            child: Center(
                              child: Text(
                                "Friends",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20.0),
                              ),
                            ),
                          ),
                        )),
                  ]));
                } else {
                  return new StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(widget.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return new Splash();
                        }
                        var myDocument = snapshot.data;
                        if (myDocument['req_sent']
                            .contains(widget.data['userid'])) {
                          return new Positioned(
                              bottom: 30.0,
                              left: MediaQuery.of(context).size.width / 22,
                              height: 55.0,
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: MaterialButton(
                                child: Text(
                                  "Cancel Request",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.0),
                                ),
                                onPressed: cancelReq,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                color: Colors.deepOrange,
                                elevation: 7.0,
                              ));
                        } else if (myDocument['req_rec']
                            .contains(widget.data['userid'])) {
                          return new Positioned(
                              child: Stack(
                            children: <Widget>[
                              Positioned(
                                  bottom: 30.0,
                                  left: 20.0,
                                  height: 55.0,
                                  width: 150.0,
                                  child: MaterialButton(
                                    child: Text(
                                      "Accept",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20.0),
                                    ),
                                    onPressed: acceptReq,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0)),
                                    color: Colors.deepOrange,
                                    elevation: 7.0,
                                  )),
                              Positioned(
                                  bottom: 30.0,
                                  right: 20.0,
                                  height: 55.0,
                                  width: 150.0,
                                  child: MaterialButton(
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20.0),
                                    ),
                                    onPressed: rejectReq,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0)),
                                    color: Colors.deepOrange,
                                    elevation: 7.0,
                                  ))
                            ],
                          ));
                        } else {
                          return new Positioned(
                              bottom: 30.0,
                              left: MediaQuery.of(context).size.width / 22,
                              height: 55.0,
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: MaterialButton(
                                child: Text(
                                  "Send Request",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.0),
                                ),
                                onPressed: sendReq,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                color: Colors.deepOrange,
                                elevation: 7.0,
                              ));
                        }
                      });
                }
              },
            ),
          ],
        ));
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
