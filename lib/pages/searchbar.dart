import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:not_bored/services/auth.dart';
import 'package:not_bored/services/friends.dart';

import 'package:not_bored/pages/info.dart';
import 'package:not_bored/pages/users.dart';

class DataSearch extends StatefulWidget {
  DataSearch({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _DataSearchState createState() => _DataSearchState();
}

class _DataSearchState extends State<DataSearch> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) async {
        for (int i = 0; i < docs.documents.length; ++i) {
          DocumentSnapshot user = await Firestore.instance
              .collection('users')
              .document(docs.documents[i].data['userid'])
              .get();
          if (user['isMailVerified']) {
            queryResultSet.add(user);
          }
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  String clear(value) {
    value = "";
    return value;
  }

  final TextEditingController eCtrl = new TextEditingController();
  _onClear() {
    setState(() {
      eCtrl.text = "";
      tempSearchStore = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(children: <Widget>[
        SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: eCtrl,
            onSubmitted: (text) {
              eCtrl.clear();
              setState(() {});
            },
            onChanged: (val) {
              initiateSearch(val);
            },
            decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  iconSize: 20.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                suffixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.close),
                  iconSize: 20.0,
                  onPressed: () {
                    _onClear();
                  },
                ),
                hintText: 'Search by name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0))),
          ),
        ),
        new Expanded(
          child: ListView.builder(
            itemCount: tempSearchStore.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(tempSearchStore[index]['imageURL']),
                ),
                title: Text(tempSearchStore[index]['name']),
                subtitle: Text(tempSearchStore[index]['status']),
                onTap: () {
                  if (widget.userId == tempSearchStore[index]['userid']) {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MyInfo(
                                  userId: widget.userId,
                                  auth: widget.auth,
                                )));
                  } else {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Users(
                                  request: new Friends(),
                                  auth: widget.auth,
                                  userId: widget.userId,
                                  data: tempSearchStore[index],
                                )));
                  }
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class SearchService {
  searchByName(String searchField) {
    return Firestore.instance
        .collectionGroup(searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}
