import 'dart:async';

// import 'package:not_bored/pages/splash.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

//import 'package:location/location.dart';
final Firestore _firestore = Firestore.instance;
Future<void> sendNBloc(
    Position position, Map<String, GeoPoint> nbLocList) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  nbLocList.forEach((String userid, GeoPoint pos) async {
    final distance = await Geolocator().distanceBetween(
        position.latitude, position.longitude, pos.latitude, pos.longitude);
    if (distance / 1000 < 15) {
      var frnd = Firestore.instance.collection("users").document(userid);

      frnd.get().then((doc) {
        if (doc.data['connectedToLoc'] == 'null') {
          frnd.collection("nb_loc").document(user.uid).setData({
            'userid': user.uid,
            'time': new DateTime.now().millisecondsSinceEpoch,
          });
        }
      });
    }
  });
}

Future<void> AcceptNBLoc() async {}
