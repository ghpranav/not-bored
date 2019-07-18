import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  Users({Key key, this.data}) : super(key: key);

  final Map data;
  @override
  _UsersState createState() => _UsersState();
}

const PrimaryColor = const Color(0xFFf96327);

class _UsersState extends State<Users> {
  String text = "Friend Request";
  void friendrequest() {
    setState(() {
      if (text == "Friend Request") {
        text = "Request Sent";
      } else if (text == "Request Sent") {
        text = "Cancel Request";
      } else if (text == "Cancel Request") {
        text = "Friend Request";
      } else if (text == "Friend") {
        text = "Unfriend";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          automaticallyImplyLeading: true,
          title: Text(widget.data['userid']),
        ),
        body: new Stack(
          children: <Widget>[
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height / 9,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 180.0,
                        height: 180.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                              image: NetworkImage(widget.data['imageURL']),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                        ))
                  ],
                )),
            Positioned(
              bottom: 270.0,
              left: 70.0,
              child: Text(
                widget.data['name'],
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
            Positioned(
              bottom: 215.0,
              left: 100.0,
              child: Text(
                widget.data['status'],
                style: TextStyle(
                    fontSize: 22.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat'),
              ),
            ),
            Positioned(
                bottom: 30.0,
                left: 20.0,
                height: 55.0,
                width: 150.0,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.orangeAccent,
                  color: Colors.deepOrange,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: () {
                      friendrequest();
                    },
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                )),
            Positioned(
                bottom: 30.0,
                right: 20.0,
                height: 55.0,
                width: 150.0,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.orangeAccent,
                  color: Colors.deepOrange,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Text(
                        "Friends",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }
}
