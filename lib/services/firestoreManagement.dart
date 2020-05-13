import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/models/post.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/pages/home_screen.dart';

class FirestoreManagement {
  final _store = Firestore.instance;
  final _auth = FirebaseAuth.instance;

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
      'latitudeStarting': post.latitudeStarting,
      'latitudeEnd': post.latitudeEnd,
      'longitudeStarting': post.longitudeStarting,
      'longitudeEnd': post.longitudeEnd,
      'description': post.description,
      'profilePicUrl': post.profilePicUrl,
      'dateTime': post.dateTime,
      'assistants': post.assistants,
      'pid': post.pid
    }).then((val) {
      Navigator.pushNamed(context, HomeScreen.id);
    }).catchError((e) => print(e));
  }

  addListener(String pid, List assistants) async {
    _store
        .collection('posts')
        .where('pid', isEqualTo: pid)
        .getDocuments()
        .then((docs) => _store.document(('posts/${docs.documents[0].documentID}')).updateData({
              'assistants': assistants,
            }).catchError((e) => print(e)));
  }

  removeListener(String pid, List assistants) async {
    await _store.collection('posts').where('pid', isEqualTo: pid).getDocuments().then((docs) => _store
        .document(('posts/${docs.documents[0].documentID}'))
        .updateData({'assistants': assistants}).catchError((e) => print(e)));
  }

  Stream<QuerySnapshot> getPostsSnapshots() {
    return _store.collection('posts').orderBy("dateTime", descending: true).snapshots();
  }

  Stream<QuerySnapshot> getNotificationsSnapshots() {
    return _store.collection('posts').where('email', isEqualTo: HomeScreen.currentAppUser.email).snapshots();
  }

  uploadProfilePic(String picUrl, User user) {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;
    user.profilePictureUrl = picUrl;
  }

  Future updateUserData(String picUrl, String fullName) async {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;
    await _auth.currentUser().then((user) {
      _store.collection('users').where('uid', isEqualTo: user.uid).getDocuments().then((docs) => Firestore.instance
          .document('users/${docs.documents[0].documentID}')
          .updateData({'profilePictureUrl': picUrl, 'fullName': fullName}).catchError((e) => print(e)));
    });
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
