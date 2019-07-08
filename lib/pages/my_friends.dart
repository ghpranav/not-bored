import 'package:flutter/material.dart';

class MyFriendsPage extends StatefulWidget {
  static String tag = 'MyFriendsPage';
  @override
   MyFriendsPageState createState() =>  MyFriendsPageState();
}

class  MyFriendsPageState extends State <MyFriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getListView(),
    );
  }
}

Widget getListView() {

  var listview=ListView(
    children: <Widget>[

     ListTile(
       leading:Icon(Icons.person),
       title: Text("Balu"),
       subtitle: Text("slaying")
               ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("pranav"),
       subtitle: Text("can u give me some pick up code,oops i mean line")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("Aditya"),
       subtitle: Text("which one to choose")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("Rahul"),
       subtitle: Text("yooooo")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("shusma"),
       subtitle: Text("potterhead")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("Alen"),
       subtitle: Text("8 times a day")
       )
       
       ,ListTile(
       leading:Icon(Icons.person),
       title: Text("chris"),
       subtitle: Text("im worthy")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("arvind"),
       subtitle: Text("maaaal")
       ),
   


    ],

  );

  return listview;
}
