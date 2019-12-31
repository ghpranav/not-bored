import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:location/location.dart';

var currentLocation = LocationData;
var location = new Location();

Map<String, dynamic> friendTest = new Map<String, dynamic>();

var finalList = [];

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
