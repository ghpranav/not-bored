import 'package:flutter/material.dart';
import 'package:not_bored/pages/landing.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:not_bored/services/auth.dart';
import 'package:not_bored/pages/info.dart';
import 'package:not_bored/pages/users.dart';
import 'package:not_bored/services/friends.dart';

class SearchBar extends StatefulWidget {
  SearchBar(
      {Key key, this.auth, this.userId, this.onSignedOut, this.map, this.list})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  final map;
  final list;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
 var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
  
      setState(() {
        tempSearchStore = [];
      });
      
      
        widget.list.forEach((element) {
        if (element['name'].toString().toLowerCase().replaceAll(new RegExp(r"\s+\b|\b\s"), "").contains(value.toString().replaceAll(new RegExp(r"\s+\b|\b\s"), "").toLowerCase())&& !tempSearchStore.contains(element)) {
          setState(() {
            tempSearchStore.add(element);
           // print(tempSearchStore);
          });
        }
      });
               print(value);
               print(tempSearchStore);
    // if (value.length == 0) {
    //   setState(() {
    //     queryResultSet = [];
    //     tempSearchStore = [];
    //   });
    // }

    // var capitalizedValue =
    //     value.substring(0, 1).toUpperCase() + value.substring(1);

    // if (queryResultSet.length == 0 && value.length == 1) {
    //         for(var i=0;i<widget.list.length;i++){
    //           if(widget.list[i]['name'][0]==value){
    //              queryResultSet.add(widget.list[i]);
    //              print(queryResultSet);
    //           }
                     

    //         }
    // } else {
    //   tempSearchStore = [];
    //   queryResultSet.forEach((element) {
    //     if (element['name'].startsWith(capitalizedValue)) {
    //       setState(() {
    //         tempSearchStore.add(element);
    //         print(tempSearchStore);
    //       });
    //     }
    //   });
    // }
    
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
                    Navigator.of(context).maybePop();
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
            itemCount: (tempSearchStore.length)~/2,
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

// class DataSearch extends SearchDelegate<String> {
//   DataSearch(this.auth, this.userId, this.map, this.list) {
//     final BaseAuth auth = this.auth;

//     final String userId = this.userId;

//     final map = this.map;
//     final list = this.list;
//   }
//   final BaseAuth auth;

//   final String userId;

//   final map;
//   final list;
//   final friends = [
//     "Pranav Bedre",
//     "Balachandra D.S",
//     "Ananya Prakash",
//     "Ruthik Raj N",
//     "Raj Shetty",
//     "Snigdha S",
//     "Keerthana Bhat",
//     "Suraksh N.S",
//     "Nanditha Suspharsha",
//     "Rishabh Jain",
//     "Alen Peter",
//     "Ann Frieda",
//     "Sthav Prakash"
//   ];
//   final recentfriends = [
//     "Pranav Bedre",
//     "Balachandra D.S",
//     "Ananya Prakash",
//     "Ruthik Raj N"
//   ];

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             query = "";
//           })
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     //return Container();
//     return IconButton(
//         icon: AnimatedIcon(
//           icon: AnimatedIcons.menu_arrow,
//           progress: transitionAnimation,
//         ),
//         onPressed: () {
//           close(context, null);
//         });
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     //return Container();
//      return Text(query);
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // final suggestionList = list
//     //      .where((p) { p['name'].toLowerCase().contains(query);})
//     //      .toList();
//     var suggestionList;
//      for(var i=0;i<list.length;i++){
//           if(list[i]['name'].contains(query))
//             suggestionList=list[i]['name'];
//       }
      

    
     
      
//    //return Container();
//     return ListView.builder(
//       itemBuilder: (context, index) => ListTile(
//           onTap: () {
//             showResults(context);
//           },
//           leading: Icon(Icons.person),
//           title: Text(suggestionList[index]['name'])),
//       itemCount: suggestionList.length,
//     );
//   }
// }
