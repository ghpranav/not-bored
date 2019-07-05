import 'package:flutter/material.dart';

//PAGES
import 'package:not_bored/pages/home.dart';
import 'package:not_bored/pages/login.dart';
import 'package:not_bored/pages/reg.dart';
import 'package:not_bored/pages/my_friends.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    LandingPage.tag: (context) => LandingPage(),
    RegPage.tag: (context) => RegPage(),
    MyFriendsPage.tag: (context) => MyFriendsPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
      routes: routes,
    );
  }
}
