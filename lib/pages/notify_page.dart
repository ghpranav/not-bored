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

class _NotifPageState extends State<NotifPage> {
   final Firestore _firestore = Firestore.instance;
  
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
              body: new Column(
                mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                                  reqRec.removeAt(index);
                                });
                              },
                              background:
                                  Container(color: Colors.orangeAccent[900]),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userDocument['imageURL']),
                                ),
                                title: Text(userDocument['name']),
                              ),
                            );
                          });
                    }))
          ]));
        });
  }
}
