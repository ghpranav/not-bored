import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
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

  @override
  Widget build(BuildContext context) {
    final  TextEditingController _controller = new TextEditingController();
    return Scaffold(
        body: new ListView(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          onChanged: (val) {
            initiateSearch(val);
          },
          controller: _controller,
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
                icon: Icon(Icons.clear),
                iconSize: 20.0,
                onPressed: () {
                  _controller.clear();
                },
              ),
              contentPadding: EdgeInsets.only(left: 25.0),
              hintText: 'Search by name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
        ),
      ),
      SizedBox(height: 10.0),
      GridView.count(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          primary: false,
          shrinkWrap: true,
          children: tempSearchStore.map((element) {
            return buildResultCard(element);
          }).toList())
    ]));
  }

  Widget buildResultCard(data) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data['imageURL']),
        ),
        title: Text(data['name']),
        subtitle: Text(data['status']),
        onTap: () {
          Navigator.of(context).pop();
          if (widget.userId == data['userid']) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MyInfo(
                          userId: widget.userId,
                          auth: widget.auth,
                        )));
          } else
            Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Users(
                        auth: widget.auth,
                        userId: widget.userId,
                        data: data,
                      )));
        },
      ),
      itemCount: tempSearchStore.length,
    );
  }
}

class SearchService {
  searchByName(String searchField) {
    return Firestore.instance
        .collection('users')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}
