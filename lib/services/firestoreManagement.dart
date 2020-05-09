import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/models/post.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/pages/home_screen.dart';

class FirestoreManagement {
  final _store = Firestore.instance;

  Future addUser(FirebaseUser user, BuildContext context, User appUser) {
    return _store.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'fullName': appUser.fullName,
      'profilePictureUrl': appUser.profilePictureUrl,
      'certificateUrl': appUser.certificateUrl,
      'password': appUser.password,
      'isCoach': appUser.isCoach
    }).then((val) {
      Navigator.pop(context);
      Navigator.pushNamed(context, HomeScreen.id);
    }).catchError((e) => print(e));
  }

  Future addPost(BuildContext context, Post post) {
    return _store.collection('/posts').add({
      'email': post.email,
      //'pid': post.pid,
      'latitudeStarting': post.latitudeStarting,
      'latitudeEnd': post.latitudeEnd,
      'longitudeStarting': post.longitudeStarting,
      'longitudeEnd': post.longitudeEnd,
      'description': post.description,
    }).then((val) {
      Navigator.pop(context);
      Navigator.pushNamed(context, HomeScreen.id);
    }).catchError((e) => print(e));
  }

  Stream<QuerySnapshot> getPostsSnapshots() {
    return _store.collection('posts').snapshots();
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

  Future<User> getAppUser(Future<FirebaseUser> currentUser) async {
    User appUser = new User('', '', '', '', '', false);
    DocumentSnapshot databaseUser;
    databaseUser = await getCurrentUser(currentUser);

    if (databaseUser.exists) {
      var data = databaseUser.data;
      appUser = new User(data['email'], data['password'], data['fullName'], data['profilePictureUrl'],
          data['certificateUrl'], data['isCoach']);
    }
    return appUser;
  }

  Future<DocumentSnapshot> getCurrentUser(Future<FirebaseUser> currentUser) {
    return currentUser.then((user) async {
      return await _store
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) async => await _store.document('users/${docs.documents[0].documentID}').get())
          .catchError((e) => print(e));
    });
  }
}