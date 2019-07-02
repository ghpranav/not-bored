import 'package:flutter/material.dart';

class MyFriendsPage extends StatefulWidget {
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
    );
  }
}
