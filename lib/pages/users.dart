import 'package:flutter/material.dart';
import 'package:not_bored/models/root.dart';
import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:not_bored/pages/my_friends.dart';
import 'package:not_bored/services/friends.dart';

class Users extends StatefulWidget {
  Users({Key key, this.auth, this.userId, this.data, this.request})
      : super(key: key);
  final FriendRequest request;
  final BaseAuth auth;
  final String userId;
  final data;
  @override
  _UsersState createState() => _UsersState();
}

const PrimaryColor = const Color(0xFFf96327);

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: PrimaryColor,
            automaticallyImplyLeading: true,
            title: Text(widget.data['username']),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                tooltip: 'Home',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RootPage(auth: widget.auth)),
                      (Route<dynamic> route) => false);
                },
              )
            ]),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.data['status'],
                    style: TextStyle(
                        fontSize: 22.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ),
                ],
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
                          onPressed: () {
                            widget.request.removeFrnd(
                                widget.userId, widget.data['userid']);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          color: PrimaryColor,
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
                          color: PrimaryColor,
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
                                onPressed: ()=>
                                  widget.request.cancelReq(
                                      widget.userId, widget.data['userid']),
                              
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                color: PrimaryColor,
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
                                    onPressed: () =>
                                      widget.request.acceptReq(
                                          widget.userId, widget.data['userid']),
                                  
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0)),
                                    color: PrimaryColor,
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
                                    onPressed: () {
                                      widget.request.rejectReq(
                                          widget.userId, widget.data['userid']);
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0)),
                                    color: PrimaryColor,
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
                                onPressed: () {
                                  widget.request.sendReq(
                                      widget.userId, widget.data['userid']);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                color: PrimaryColor,
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
