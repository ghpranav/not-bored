

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:not_bored/models/root.dart';
import 'package:not_bored/pages/landing.dart';

import 'package:not_bored/services/auth.dart';

import 'package:not_bored/pages/home.dart';
import 'package:not_bored/pages/login.dart';
import 'package:not_bored/pages/reg.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

const PrimaryColor = const Color(0xFFf96327);

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    RegPage.tag: (context) => RegPage(),
    LandingPage.tag:(context)=>LandingPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        primaryColor: PrimaryColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
      ),
      home: RootPage(auth: new Auth()),
      routes: routes,
    );
  }
}
