import 'package:flutter/material.dart';

class rippleEffect extends StatefulWidget {
  @override
  _rippleEffectState createState() => _rippleEffectState();
}

class _rippleEffectState extends State<rippleEffect> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Tap'),
        ));
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Text('Flat Button'),
      ),
    );
  }
}
