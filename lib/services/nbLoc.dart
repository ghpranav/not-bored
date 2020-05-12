import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_bored/services/serve.dart';

//import 'package:location/location.dart';

Future<void> sendNBloc(
    Position position, Map<String, GeoPoint> nbLocList) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  nbLocList.forEach((String userid, GeoPoint pos) async {
    // final distance = await Geolocator().distanceBetween(
    //     position.latitude, position.longitude, pos.latitude, pos.longitude);
    //if (distance / 1000 < 15) {
    var frnd = Firestore.instance.collection("users").document(userid);
    frnd.get().then((doc) {
      if (doc.data['connectedToLoc'] == 'null' &&
          doc.data['connectedTo'] == 'null' &&
          doc.data['isSearching'] == false) {
        frnd.collection("nb_loc").document(user.uid).setData({
          'userid': user.uid,
          'time': new DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
    //}
  });
}

getNBLoc() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot querySnapshot = await Firestore.instance
      .collection("users")
      .document(user.uid)
      .collection("nb_loc")
      .getDocuments();

  var frndList = querySnapshot.documents;
  var connectedTo;

  frndList.forEach((doc) {
    if (doc.data["userid"] != null) connectedTo = doc.data["userid"];
  });
  return connectedTo;
}

Future<void> rejectNBLoc(userid, frndid) async {
  await Firestore.instance
      .collection("users")
      .document(userid)
      .collection("nb_loc")
      .document(frndid)
      .delete();
}

Future<void> acceptNBLoc(userid, frndid) async {
  await Firestore.instance.collection('users').document(userid).updateData({
    'connectedToLoc': frndid,
  });
  await Firestore.instance.collection('users').document(frndid).updateData({
    'connectedToLoc': frndid,
  });
  await Firestore.instance
      .collection('users')
      .document(frndid)
      .collection('nb_loc_meet')
      .document(userid)
      .setData({
    'userid': userid,
  });
}

// waitNBLoc() async {
//   FirebaseUser user = await FirebaseAuth.instance.currentUser();
//   bool _show = false;

//   DocumentSnapshot querySnapshot =
//       await Firestore.instance.collection("users").document(user.uid).get();
//   if (querySnapshot.data['connectedToLoc'] != 'null') {
//     await Firestore.instance.collection("places").document(user.uid).setData({
//       'show': true,
//     });
//     _show = true;
//   }

//   await deleteNBLoc();
//   return _show;
// }

Future<void> deleteNBLoc() async {
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
        .collection("nb_loc")
        .document(user.uid)
        .delete();
  });
}
