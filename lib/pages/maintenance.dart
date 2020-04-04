import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class MaintainPage extends StatefulWidget {
  @override
  _MaintainPageState createState() => _MaintainPageState();
}

class _MaintainPageState extends State<MaintainPage> {
  String msg = '';
  @override
  void initState() {
    super.initState();
    _reason();
  }

  _reason() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection("server_maint")
        .document("killswitch")
        .get();

    setState(() {
      msg = querySnapshot.data['message'];
    });
    print(msg);
  }

  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => true,
      child: new Scaffold(
        backgroundColor: Color(0xFFf96327),
        appBar: AppBar(
            title: Center(
              child: Text('Maintenance'),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFf96327)),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Image.asset('lib/assests/serverMaintenance.jpg'),
              SizedBox(
                height: 40,
              ),
              Text(
                msg,
                style: GoogleFonts.abel(
                    textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ])),
      ),
    );
  }
}
