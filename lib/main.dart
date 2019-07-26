import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:not_bored/models/root.dart';

import 'package:not_bored/pages/home.dart';
import 'package:not_bored/pages/login.dart';
import 'package:not_bored/pages/reg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    RegPage.tag: (context) => RegPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: RootPage(auth: new Auth()),
      routes: routes,
    );
  }
}
