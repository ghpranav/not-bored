import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(Map profile);

  Future<FirebaseUser> getCurrentUser();

  Future<String> getCurrentUserid();

  Future<void> signOut();

  Future<void> createUser(Map profile, FirebaseUser user);

  Future<void> uploadProPic(String url);

  Future<void> updateProfile(Map profile);

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

  Future<void> resetPassword(String email);

  Future<void> saveDeviceToken();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    saveDeviceToken();
    return user.user.uid;
  }

  Future<String> signUp(Map profile) async {
    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: profile['email'], password: profile['password']);
    if (user.user.uid != null) {
      createUser(profile, user.user);
    }
    return user.user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<String> getCurrentUserid() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    final FirebaseMessaging _fcm = FirebaseMessaging();
    String fcmToken = await _fcm.getToken();
    DocumentReference _ref = _firestore.collection('users').document(user.uid);
    _ref.collection('tokens').document(fcmToken).delete();
    return _firebaseAuth.signOut();
  }

  Future<void> createUser(Map profile, FirebaseUser user) async {
    DocumentReference _ref = _firestore.collection('users').document(user.uid);

    _ref.setData(<String, dynamic>{
      'fname': profile['fname'],
      'lname': profile['lname'],
      'name': profile['fname'] + ' ' + profile['lname'],
      'email': profile['email'],
      'username': profile['username'],
      'userid': user.uid.toString(),
      'phone': profile['phone'],
      'status': 'I am Bored',
      'imageURL':
          'https://firebasestorage.googleapis.com/v0/b/not-bored-002.appspot.com/o/pro_pics%2Fdefault.jpg?alt=media&token=8198b851-f08e-4bfa-b7b8-64d055c43f20',
      'isMailVerified': false,
      'req_rec': [],
      'req_sent': [],
    });
    _ref.collection(user.uid).document('null').setData(<String, dynamic>{});
    _ref.collection('req_rec').document('null').setData(<String, dynamic>{});
    _ref.collection('nb_msg').document('null').setData(<String, dynamic>{});
  }

  Future<void> uploadProPic(String url) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    DocumentReference _ref = _firestore.collection('users').document(user.uid);
    _ref.updateData(<String, dynamic>{
      'imageURL': url,
    });
  }

  Future<void> updateProfile(Map profile) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    DocumentReference _ref = _firestore.collection('users').document(user.uid);
    _ref
        .collection(profile['fname'][0].toString().toUpperCase())
        .document(user.uid)
        .delete();
    if (profile['fname'][0].toString().toUpperCase() !=
        profile['lname'][0].toString().toUpperCase()) {
      _ref
          .collection(profile['lname'][0].toString().toUpperCase())
          .document(user.uid)
          .delete();
    }
    _ref.updateData(<String, dynamic>{
      'fname': profile['fname'],
      'lname': profile['lname'],
      'userid': profile['userid'],
      'phone': profile['phone'],
      'status': profile['status'],
      'name': profile['fname'] + profile['lname'],
    });
    _ref
        .collection(profile['fname'][0].toString().toUpperCase())
        .document('null')
        .setData(<String, dynamic>{
      'userid': user.uid.toString(),
    });
    if (profile['fname'][0].toString().toUpperCase() !=
        profile['lname'][0].toString().toUpperCase()) {
      _ref
          .collection(profile['lname'][0].toString().toUpperCase())
          .document('null')
          .setData(<String, dynamic>{
        'userid': user.uid.toString(),
      });
    }
  }



  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> saveDeviceToken() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    final FirebaseMessaging _fcm = FirebaseMessaging();
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokens = _firestore
          .collection('users')
          .document(user.uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), 
        'platform': Platform.operatingSystem 
      });
    }
  }
}
