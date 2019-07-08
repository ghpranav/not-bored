import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:not_bored/pages/splash.dart';

class MyInfo extends StatefulWidget {
  MyInfo({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;
  @override
  _MyInfoState createState() => _MyInfoState();
}

const PrimaryColor = const Color(0xFFf96327);

class _MyInfoState extends State<MyInfo> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Splash();
          }
          var userDocument = snapshot.data;
          return new Scaffold(
              appBar: AppBar(
                  backgroundColor: PrimaryColor,
                  automaticallyImplyLeading: true,
                  title: Text('Profile Page'),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context, false),
                  )),
              body: new Stack(
                children: <Widget>[
                  ClipPath(
                    child: Container(color: Colors.black.withOpacity(0.8)),
                    clipper: GetClipper(),
                  ),
                  Positioned(
                      width: 350.0,
                      top: MediaQuery.of(context).size.height / 5,
                      child: Column(
                        children: <Widget>[
                          Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://scontent.fmaa2-1.fna.fbcdn.net/v/t1.0-1/p160x160/48361415_1012165775652855_7154124804449107968_n.jpg?_nc_cat=104&_nc_oc=AQl4O3XXsZFkYkHk5uIHXNgu8Ex_HAo3ni61Hrg0hfvBENWc_e_h24erbqVxafXJqPM&_nc_ht=scontent.fmaa2-1.fna&oh=46259f95a10b2a262147b3ef656499b6&oe=5DB3898F'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 7.0, color: Colors.black)
                                  ])),
                          SizedBox(height: 40.0),
                          Text(
                            userDocument['fname'] + ' ' + userDocument['lname'],
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            'Slaying!!!!',
                            style: TextStyle(
                                fontSize: 17.0,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Montserrat'),
                          ),
                          SizedBox(height: 25.0),
                          Container(
                              height: 35.0,
                              width: 200.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.orangeAccent,
                                color: Colors.deepOrange,
                                elevation: 7.0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Text(
                                      userDocument['userid'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(height: 25.0),
                          Container(
                              height: 35.0,
                              width: 200.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.orangeAccent,
                                color: Colors.deepOrange,
                                elevation: 7.0,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Text(
                                      userDocument['email'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(height: 25.0),
                          Container(
                              height: 35.0,
                              width: 200.0,
                              child: Align(
                                  alignment: Alignment(-3.20, -1.40),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(30.0),
                                    shadowColor: Colors.orangeAccent[700],
                                    color: Colors.deepOrange,
                                    elevation: 7.0,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Center(
                                        child: Text(
                                          userDocument['phone'].toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ),
                                    ),
                                  )))
                        ],
                      ))
                ],
              ));
        });
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
