import 'package:flutter/material.dart';

//PAGES
import 'homepage.dart';
import 'login_page.dart';
import 'package:not_bored/reg_page.dart';
import 'auth.dart';
import 'root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    MyHomePage.tag: (context) => MyHomePage(),
    RegPage.tag: (context) => RegPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(auth: new Auth()),
      routes: routes,
    );
  }
}