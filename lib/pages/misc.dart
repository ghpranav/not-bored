import 'package:flutter/material.dart';

class MiscPage extends StatefulWidget {
  @override
  _MiscPageState createState() => _MiscPageState();
}

class _MiscPageState extends State<MiscPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Misc'), backgroundColor: const Color(0xFFf96327)),
    );
  }
}
