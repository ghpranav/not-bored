import 'package:flutter/material.dart';
import 'homepage.dart';

class RegPage extends StatefulWidget {
  static String tag = 'reg-page';
  @override
  _RegPageState createState() => new _RegPageState();
}

class _RegPageState extends State<RegPage> {
  @override
  Widget build(BuildContext context) {
    final logo = Text('NOT BORED',
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: 3.0,
        ),
        textAlign: TextAlign.center);

    final firstName = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'First Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final lastName = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Last Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final userid = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'User ID',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'example@gmail.com',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      //initialValue: 'ExamplePassword',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final phone = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Phone Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final signupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(MyHomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Text('Sign Up', style: TextStyle(color: const Color(0xFFf96327))),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFf96327),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            firstName,
            SizedBox(height: 15.0),
            lastName,
            SizedBox(height: 15.0),
            email,
            SizedBox(height: 15.0),
            password,
            SizedBox(height: 15.0),
            userid,
            SizedBox(height: 15.0),
            phone,
            SizedBox(height: 38.0),
            signupButton,
          ],
        ),
      ),
    );
  }
}
