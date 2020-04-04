import 'package:flutter/material.dart';
import 'package:not_bored/pages/privacyPolicy.dart';
import 'package:not_bored/pages/welcome.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 0, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              "Here's an app unlike any other socio-friendly apps out there, not only let's you connect and chat with your buddies but provides a feature to actually get you to meet up with your friends. Late night hangouts, after party chilling or just assignment meet ups, you can set up a meet with your friends with just a hit of a button! A new, more personalized app for all ages that's main agenda is to drive away boredom and bring people closer",
              style: TextStyle(
                  color: Colors.white /*Color(0xFFf96327)*/, fontSize: 17),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Widget _label1() {
    return Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Text(
                "Contact Us:NOT BORED",
                style: TextStyle(
                    color: BlueColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              onTap: () => launch("mailto:notbored.india@gmail.com"),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Widget _insta() {
    return InkWell(
      child: Text(
        'Click to follow us on Instagram',
        style: TextStyle(color: BlueColor),
      ),
      onTap: () => launch("https://www.instagram.com/notbored.india/"),
    );
  }

  // Widget _sendEmail() {
  //   return InkWell(
  //     child: Text(
  //       'Click To Contact Us at NB',
  //       style: TextStyle(color: BlueColor),
  //     ),
  //     onTap: () => launch("mailto:notbored.india@gmail.com"),
  //   );
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
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
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.5, 0.8],
                colors: [
                  Colors.orange[700],
                  Color(0xFFf96327),
                ],
              )),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Image.asset('lib/assests/meetPeople.png'),
                SizedBox(
                  height: 20,
                ),
                _label(),
                SizedBox(
                  height: 10,
                ),
                _privacyPolicy(),
                SizedBox(
                  height: 20,
                ),
                _insta(),
                SizedBox(
                  height: 40,
                ),
                new GestureDetector(
                  child: Image.asset(
                    'lib/assests/logo.png',
                    fit: BoxFit.cover,
                  ),
                  onTap: () =>
                      launch("https://www.instagram.com/notbored.india/"),
                ),
                _label1(),
              ]),
        ),
      ),
    );
  }
}
