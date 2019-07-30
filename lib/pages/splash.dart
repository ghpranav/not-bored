import 'dart:math';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController rotationController;

  @override
  void initState() {
    rotationController = AnimationController(
        vsync: this, duration: Duration(seconds: 5), upperBound: pi * 2);
    rotationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
            child: RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
      child: Text(
        'N B',
        style: TextStyle(
          color: Colors.deepOrange,
          fontSize: 30,
          fontFamily: "Horizon",
          fontWeight: FontWeight.bold,
        ),
      ),
    )));
  }
}
