import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/pages/users.dart';

class MyFriendsPage extends StatefulWidget {
  MyFriendsPage({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  MyFriendsPageState createState() => MyFriendsPageState();
}

class MyFriendsPageState extends State<MyFriendsPage> {
  var myFriends = [];
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collectionGroup(widget.userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot1) {
          if (snapshot1.connectionState == ConnectionState.waiting)
            return new Splash();
          snapshot1.data.documents.forEach((index) {
            myFriends.add(index.data['userid']);
            print(myFriends);
          });
          for (int i = 0; i < myFriends.length; i++) {
            return new StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(myFriends[i])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Splash();
                  }
                  var userDocument = snapshot.data;
                  return Scaffold(
                      body: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userDocument['imageURL']),
                        ),
                        title: Text(userDocument['name']),
                        subtitle: Text(userDocument['status']),
                        onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Users(
                                          auth: widget.auth,
                                          userId: widget.userId,
                                          data: userDocument,
                                        )));
                        },
                      )
                    ],
                  ));
                });
          }
        });
  }
}
