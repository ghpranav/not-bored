import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/pages/info.dart';
import 'package:not_bored/pages/users.dart';

class MyFriendsPage extends StatefulWidget {
  MyFriendsPage({Key key, this.auth, this.userId, this.user}) : super(key: key);

  final BaseAuth auth;
  final String userId;
  final String user;

  @override
  MyFriendsPageState createState() => MyFriendsPageState();
}

class MyFriendsPageState extends State<MyFriendsPage> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collectionGroup(widget.user).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot1) {
          if (snapshot1.connectionState == ConnectionState.waiting) {
            return new Splash();
          }
          var myFriends = [];
          snapshot1.data.documents.forEach((index) {
            if (index.data['userid'] != null) {
              myFriends.add(index.data['userid']);
            }
          });
          return Scaffold(
              body: new ListView.builder(
            itemCount: myFriends.length,
            itemBuilder: (BuildContext context, int index) {
              return new StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(myFriends[index])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return new Splash();
                    }
                    var userDocument = snapshot.data;
                    return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                              fit: FlexFit.loose,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userDocument['imageURL']),
                                ),
                                title: Text(userDocument['name']),
                                subtitle: Text(userDocument['status']),
                                onTap: () {
                                  if (widget.userId == userDocument['userid']) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MyInfo(
                                                  userId: widget.userId,
                                                  auth: widget.auth,
                                                )));
                                  } else
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Users(
                                                  auth: widget.auth,
                                                  userId: widget.userId,
                                                  data: userDocument,
                                                )));
                                },
                              ))
                        ]);
                  });
            },
          ));
        });
  }
}
