import 'package:flutter/material.dart';

import 'package:not_bored/services/auth.dart';
import 'package:not_bored/pages/info.dart';
import 'package:not_bored/pages/users.dart';
import 'package:not_bored/services/friends.dart';
import 'package:not_bored/pages/landing.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key, this.auth, this.userId, this.onSignedOut, this.list})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  final list;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final routes = <String, WidgetBuilder>{
    LandingPage.tag: (context) => LandingPage(),
  };
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    setState(() {
      tempSearchStore = [];
    });

    widget.list.forEach((element) {
      if ((element['name']
                  .toString()
                  .toLowerCase()
                  .replaceAll(new RegExp(r"\s+\b|\b\s"), "")
                  .contains(value
                      .toString()
                      .replaceAll(new RegExp(r"\s+\b|\b\s"), "")
                      .toLowerCase()) &&
              !tempSearchStore.contains(element)) ||
          (element['email']
                  .toString()
                  .toLowerCase()
                  .replaceAll(new RegExp(r"\s+\b|\b\s"), "")
                  .contains(value
                      .toString()
                      .replaceAll(new RegExp(r"\s+\b|\b\s"), "")
                      .toLowerCase()) &&
              !tempSearchStore.contains(element))) {
        setState(() {
          tempSearchStore.add(element);
        });
      }
    });
  }

  String clear(value) {
    value = "";
    tempSearchStore = [];
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
                hintText: 'Search by name or email id',
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
