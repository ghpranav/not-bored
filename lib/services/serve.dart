import 'dart:async';

// import 'package:not_bored/pages/splash.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:location/location.dart';

var currentLocation = LocationData;
var location = new Location();

Map<String, dynamic> friendTest = new Map<String, dynamic>();

var finalList = [];

Future pause(Duration d) => new Future.delayed(d);

Future<void> updateLocation() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  DocumentReference _ref =
      Firestore.instance.collection('users').document(user.uid);
  Geoflutterfire geo = Geoflutterfire();
  var pos = await location.getLocation();
  GeoFirePoint point =
      geo.point(latitude: pos.latitude, longitude: pos.longitude);

  return _ref.updateData(<String, dynamic>{
    'position': point.data,
  });
}

void search() async {
  QuerySnapshot querySnapshot =
      await Firestore.instance.collection("users").getDocuments();
  finalList = querySnapshot.documents;
}

Future<void> sendNBmsg() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot querySnapshot = await Firestore.instance
      .collection("users")
      .document(user.uid)
      .collection(user.uid)
      .getDocuments();

  var frndList = querySnapshot.documents;

  frndList.forEach((doc) {
    if (doc['userid'] == null) return null;
    var frndId = doc.data['userid'];

    Firestore.instance
        .collection("users")
        .document(frndId)
        .collection("nb_msg")
        .document(user.uid)
        .setData({
      'userid': user.uid,
    });
  });
}

getNBmsg() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot querySnapshot = await Firestore.instance
      .collection("users")
      .document(user.uid)
      .collection("nb_msg")
      .getDocuments();

  var frndList = querySnapshot.documents;
  var connectedTo;

  frndList.forEach((doc) {
    if (doc.data["userid"] != null) connectedTo = doc.data["userid"];
  });
  return connectedTo;
}

Future<void> acceptNBmsg(userid, frndid) async {
  await Firestore.instance.collection('users').document(userid).updateData({
    'connectedTo': frndid,
  });
  await Firestore.instance.collection('users').document(frndid).updateData({
    'connectedTo': userid,
  });
}

Future<void> rejectNBmsg(userid, frndid) async {
  await Firestore.instance
      .collection("users")
      .document(userid)
      .collection("nb_msg")
      .document(frndid)
      .delete();
}

Future<String> waitNBmsg() async {
  int counter = 0;

  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String connectedTo;

  while (counter < 30) {
    DocumentSnapshot querySnapshot =
        await Firestore.instance.collection("users").document(user.uid).get();
    connectedTo = querySnapshot.data['connectedTo'];

    if (connectedTo != "null") break;

    await pause(const Duration(seconds: 1));
    counter++;
  }

  await deleteNBmsg();
  return connectedTo;
}

Future<void> deleteNBmsg() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot querySnapshot = await Firestore.instance
      .collection("users")
      .document(user.uid)
      .collection(user.uid)
      .getDocuments();

  var frndList = querySnapshot.documents;

  frndList.forEach((doc) async {
    if (doc['userid'] == null) return null;
    var frndId = doc.data['userid'];

    Firestore.instance
        .collection("users")
        .document(frndId)
        .collection("nb_msg")
        .document(user.uid)
        .delete();
  });
}
