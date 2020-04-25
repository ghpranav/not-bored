import 'package:flutter/material.dart';
import 'package:not_bored/pages/newlogin.dart';
import 'package:not_bored/pages/newreg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:not_bored/services/auth.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:not_bored/pages/privacyPolicy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class WelcomePage extends StatefulWidget {
  WelcomePage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  //final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

const BlueColor = const Color(0xFF00245A);

class _WelcomePageState extends State<WelcomePage> {
  Location _locationService = new Location();
  geo.Position position;
  @override
  void initState() {
    super.initState();
    initialLocation();
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
    } else {
      _privacypolicy1();
    }
  }

  Future itsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('seen', true);
    Navigator.of(context).pop();
  }

  _privacypolicy1() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            title: Center(child: Text("User Agreement and Privacy Policy")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(privacy),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: itsSeen,
                  child: Text('Accept User Agreement and Privacy Policy'))
            ],
          );
        });
  }

  void initialLocation() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);
    position = await geo.Geolocator()
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      auth: widget.auth,
                      onsignedIn: widget.onSignedIn,
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RegPage(auth: widget.auth)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _privacyPolicy() {
    return InkWell(
      child: Text(
        'User Agreement and Privacy Policy',
        style: TextStyle(color: BlueColor),
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PrivacyPolicy())),
    );
  }

  Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              "You ain't bored anymore",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            SizedBox(
              height: 20,
            ),
            new Image.asset(
              'lib/assests/logo.png',
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 20,
            ),

            /* Text(
              'Touch ID',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),*/
          ],
        ));
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'N',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'ot',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            TextSpan(
              text: ' B',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            TextSpan(
              text: 'ored',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFf96327), Color(0xFFf96327)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title(),
              SizedBox(
                height: 80,
              ),
              _submitButton(),
              SizedBox(
                height: 20,
              ),
              _signUpButton(),
              SizedBox(
                height: 20,
              ),
              _label(),
              _privacyPolicy(),
            ],
          ),
        ),
      ),
    );
  }
}
