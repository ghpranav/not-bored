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
      appBar: AppBar(
        title: Text('My Friends'),
        backgroundColor: const Color(0xFFf96327)
      ),
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
       subtitle: Text("balu@lala.com")
               ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("pranav"),
       subtitle: Text("bedrepranav@lala.com")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("Aditya"),
       subtitle: Text("Adityaas@lala.com")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("Rahul"),
       subtitle: Text("Rahul@gmail.com")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("shusma"),
       subtitle: Text("sushma@yahoo.com")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("Alen"),
       subtitle: Text("Alen@shag.com")
       )
       
       ,ListTile(
       leading:Icon(Icons.person),
       title: Text("chris"),
       subtitle: Text("chris@df.com")
       ),

       ListTile(
       leading:Icon(Icons.person),
       title: Text("arvind"),
       subtitle: Text("arvind@ndcm.com")
       ),
   


    ],

  );

  return listview;
}
