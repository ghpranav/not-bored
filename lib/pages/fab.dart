import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_bored/pages/chat.dart';
import 'package:not_bored/pages/home.dart';
import 'package:not_bored/services/serve.dart';
import 'package:not_bored/services/nbLoc.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:geolocator/geolocator.dart' as geo;

bool show1 = false;
bool show2 = true;

class RadialMenu extends StatefulWidget {
  RadialMenu({Key key, this.position, this.nbLocList}) : super(key: key);
  final nbLocList;
  final geo.Position position;
  @override
  createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
    // ..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(
      controller: controller,
      position: widget.position,
      nbLocList: widget.nbLocList,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class RadialAnimation extends StatefulWidget {
  RadialAnimation({Key key, this.controller, this.position, this.nbLocList})
      : translation = Tween<double>(
          begin: 0.0,
          end: 180.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.elasticOut),
        ),
        scale = Tween<double>(
          begin: 2.5,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.7,
              curve: Curves.decelerate,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> rotation;
  final Animation<double> translation;
  final Animation<double> scale;
  final nbLocList;
  final geo.Position position;

  @override
  _RadialAnimationState createState() => _RadialAnimationState();
}

class _RadialAnimationState extends State<RadialAnimation>
    with TickerProviderStateMixin {
  AnimationController fab;
  AnimationController fab1;

  void initState() {
    super.initState();
    fab = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2200));
    fab.repeat();
    fab1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    fab1.forward();
    super.initState();
    show1 = false;
  }

  meetFab() async {
    await _close();
    setState(() {
      isLoadingFAB = true;
    });
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    await sendNBloc(widget.position, widget.nbLocList);
    await pause(const Duration(seconds: 60));
    await deleteNBLoc();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('nb_loc_meet')
        .getDocuments();
    List<DocumentSnapshot> frndList = querySnapshot.documents;
    if (frndList.length > 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ListView.builder(
                itemCount: frndList.length,
                itemBuilder: (BuildContext context, int index) {
                  List text;
                  showDetails(frndList[index].data['userid'])
                      .then((value) async {
                    setState(() {
                      text = value;
                    });
                  });
                  return text == null
                      ? Container()
                      : Container(
                          child: new Card(
                              child: new Container(
                                  child: new Row(
                          children: <Widget>[
                            Text(text[1]),
                            Text(text[0]),
                          ],
                        ))));
                });
          });
    } else {
      Fluttertoast.showToast(
          msg: "Sorry no friends available",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: PrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      isLoadingFAB = false;
    });

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return RichAlertDialog(
    //         alertTitle: richTitle("COVID-19"),
    //         alertSubtitle: richSubtitle(
    //             " Due to the increase in outbreak of COVID-19 in the country this feature is currently diasabled.Stay Home Stay Safe!"),
    //         alertType: RichAlertType.ERROR,
    //       );
    //     });
  }

  chatFab() async {
    await _close();
    setState(() {
      isLoadingFAB = true;
    });
    await sendNBmsg();

    String connectedTo = await waitNBmsg();

    if (connectedTo != "null") {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      FirebaseUser user = await _firebaseAuth.currentUser();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Chat(
                    userId: user.uid,
                    peerId: connectedTo.toString(),
                  )));
    } else {
      Fluttertoast.showToast(
          msg: "Sorry no friends available",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: PrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      isLoadingFAB = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> rotate = widget.rotation;
    Animation<double> scale = widget.scale;

    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, widget) {
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  alignment: Alignment.bottomCenter,
                  child: Transform.scale(
                      scale: 1.5,
                      child: Visibility(
                          visible: show1,
                          child: FloatingActionButton(
                              tooltip: 'Meet Your Friends',
                              heroTag: null,
                              child: Icon(FontAwesomeIcons.handshake),
                              backgroundColor: PrimaryColor,
                              onPressed: () {
                                meetFab();
                              },
                              elevation: 2))),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  alignment: Alignment.bottomCenter,
                  child: Transform.scale(
                      scale: 1.5,
                      child: Visibility(
                          visible: show1,
                          child: FloatingActionButton(
                              tooltip: 'Text with your friends',
                              heroTag: null,
                              child: Icon(FontAwesomeIcons.envelopeOpenText),
                              backgroundColor: PrimaryColor,
                              onPressed: () {
                                chatFab();
                              },
                              elevation: 2))),
                ),
              ],
            ),
            Transform.rotate(
                angle: radians(rotate.value),
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                    _buildButton(
                      225,
                      color: PrimaryColor,
                      icon: FontAwesomeIcons.handshake,
                    ),
                    _buildButton(
                      315,
                      color: PrimaryColor,
                      icon: FontAwesomeIcons.envelopeOpenText,
                    ),
                    Transform.scale(
                      scale: scale.value - 1.5,
                      child: Visibility(
                          visible: show2,
                          child: FloatingActionButton(
                              heroTag: null,
                              child: Icon(FontAwesomeIcons.timesCircle),
                              onPressed: _close,
                              backgroundColor: Colors.red)),
                    ),
                    Transform.scale(
                      scale: scale.value,
                      child: ScaleTransition(
                        scale: isLoadingFAB ? fab : fab1,
                        child: FloatingActionButton(
                            tooltip: 'Click',
                            heroTag: null,
                            child: isLoadingFAB
                                ? new Icon(
                                    Icons.sentiment_very_satisfied,
                                    size: 50.0,
                                    color: Colors.white54,
                                  )
                                : new Icon(
                                    Icons.sentiment_dissatisfied,
                                    size: 50.0,
                                    color: Colors.white54,
                                  ),
                            backgroundColor: const Color(0xFFf96327),
                            foregroundColor: Colors.white54,
                            onPressed: () async {
                              int _len = await getFriends();
                              if (_len == 1) {
                                Fluttertoast.showToast(
                                    msg: "Click on search bar to find friends",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: PrimaryColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                if (isLoadingFAB) {
                                  return null;
                                } else
                                  _open();
                              }
                            }),
                      ),
                    )
                  ]),
                ))
          ]);
        });
  }

  _open() async {
    show2 = true;
    widget.controller.forward();
    await pause(const Duration(milliseconds: 600));
    show1 = true;
  }

  _close() async {
    show1 = false;
    widget.controller.reverse();
    await pause(const Duration(milliseconds: 1000));
    show2 = false;
  }

  _buildButton(double angle, {Color color, IconData icon}) {
    final double rad = radians(angle);
    return Transform(
        transform: Matrix4.identity()
          ..translate((widget.translation.value) * cos(rad),
              (widget.translation.value) * sin(rad)),
        child: Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 4,
            child: Visibility(
                visible: show2,
                child: FloatingActionButton(
                    heroTag: null,
                    child: Icon(icon),
                    backgroundColor: color,
                    onPressed: null,
                    elevation: 2))));
  }
}
