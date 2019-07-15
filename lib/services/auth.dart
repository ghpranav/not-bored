import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(Map profile);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

  Future<void> createUser(Map profile, FirebaseUser user);

  Future<void> uploadProPic(String url);

  Future<void> updateProfile(Map profile);

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(Map profile) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: profile['email'], password: profile['password']);
    if (user.uid != null) {
      createUser(profile, user);
    }
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> createUser(Map profile, FirebaseUser user) async {
    DocumentReference _ref = _firestore.collection('users').document(user.uid);
    _ref.setData(<String, dynamic>{
      'name': profile['fname'] + ' ' + profile['lname'],
      'email': profile['email'],
      'userid': profile['userid'],
      'phone': profile['phone'],
      'status': 'I am Bored',
      'imageURL':
          'https://firebasestorage.googleapis.com/v0/b/not-bored.appspot.com/o/pro_pics%2Fdefault.jpg?alt=media&token=2b95838b-d7cd-4540-a7a9-f957e7a526ee',
      'isMailVerified': false,
      'searchKey': profile['fname'][0],
    });
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
    _ref.updateData(<String, dynamic>{
      'name': profile['name'],
      'userid': profile['userid'],
      'phone': profile['phone'],
      'status': profile['status'],
    });
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
