import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/pages/home_screen.dart';

class UserManagement {
  final _store = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  Future addUser(FirebaseUser user, BuildContext context, User appUser) {
    return _store.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'fullName': appUser.fullName,
      'profilePictureUrl': appUser.profilePictureUrl,
      'certificateUrl': appUser.certificateUrl,
      'isCoach': appUser.isCoach
    }).then((val) {
      Navigator.pop(context);
      Navigator.pushNamed(context, HomeScreen.id);
    }).catchError((e) => print(e));
  }

  uploadProfilePic(String picUrl, User user) {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;
    user.profilePictureUrl = picUrl;

    /* await _auth.currentUser().then((user) {
      _store.collection('users').where('uid', isEqualTo: user.uid).getDocuments().then((docs) => Firestore.instance
          .document('users/${docs.documents[0].documentID}')
          .updateData({'profilePictureUrl': picUrl})
          .then((val) => print('the file got updated'))
          .catchError((e) => print(e)));
    });*/
  }

  Future updateProfilePic(String picUrl) async {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;

    /*await _auth.currentUser().then((user) {
      _store.collection('users').where('uid', isEqualTo: user.uid).getDocuments().then((docs) => Firestore.instance
          .document('users/${docs.documents[0].documentID}')
          .updateData({'profilePictureUrl': picUrl})
          .then((val) => print('the file got updated'))
          .catchError((e) => print(e)));
    });*/
  }
}
