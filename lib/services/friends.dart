import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FriendRequest {
  Future<void> sendReq(userId, friendId);

  Future<void> cancelReq(userId, friendId);

  Future<void> acceptReq(userId, friendId);

  Future<void> rejectReq(userId, friendId);

  Future<void> removeFrnd(userId, friendId);
}

class Friends implements FriendRequest {
  final Firestore _firestore = Firestore.instance;

  Future<void> sendReq(userId, friendId) async {
    DocumentReference _refMe = _firestore.collection('users').document(userId);
    DocumentReference _refU = _firestore.collection('users').document(friendId);
    _refMe.updateData({
      'req_sent': FieldValue.arrayUnion([friendId]),
    });
    _refU.updateData({
      'req_rec': FieldValue.arrayUnion([userId]),
    });
    _refU.collection('req_rec').document(userId).setData({
      'userid': userId,
    });
  }

  Future<void> cancelReq(userId, friendId) async {
    DocumentReference _refMe = _firestore.collection('users').document(userId);
    DocumentReference _refU = _firestore.collection('users').document(friendId);
    _refMe.updateData({
      'req_sent': FieldValue.arrayRemove([friendId]),
    });
    _refU.updateData({
      'req_rec': FieldValue.arrayRemove([userId]),
    });
    _refU.collection('req_rec').document(friendId).delete();
  }

  Future<void> acceptReq(userId, friendId) async {
    DocumentReference _refMe = _firestore.collection('users').document(userId);
    DocumentReference _refU = _firestore.collection('users').document(friendId);
    DocumentReference _refMeF = _firestore
        .collection('users')
        .document(userId)
        .collection(userId)
        .document(friendId);

    DocumentReference _refUF = _firestore
        .collection('users')
        .document(friendId)
        .collection(friendId)
        .document(userId);

    _refMe.updateData({
      'req_rec': FieldValue.arrayRemove([friendId]),
    });
    _refU.updateData({
      'req_sent': FieldValue.arrayRemove([userId]),
    });
    _refMe.collection('req_rec').document(friendId).delete();
    _refMeF.setData(<String, dynamic>{
      'userid': friendId,
      'isBlocked': false,
    });
    _refUF.setData(<String, dynamic>{
      'userid': userId,
      'isBlocked': false,
    });
  }

  Future<void> rejectReq(userId, friendId) async {
    DocumentReference _refMe = _firestore.collection('users').document(userId);
    DocumentReference _refU = _firestore.collection('users').document(friendId);
    _refMe.updateData({
      'req_rec': FieldValue.arrayRemove([friendId]),
    });
    _refU.updateData({
      'req_sent': FieldValue.arrayRemove([userId]),
    });
    _refMe.collection('req_rec').document(friendId).delete();
  }

  Future<void> removeFrnd(userId, friendId) async {
    DocumentReference _refMeF = _firestore
        .collection('users')
        .document(userId)
        .collection(userId)
        .document(friendId);
    DocumentReference _refUF = _firestore
        .collection('users')
        .document(friendId)
        .collection(friendId)
        .document(userId);
    _refMeF.delete();
    _refUF.delete();
  }
}
