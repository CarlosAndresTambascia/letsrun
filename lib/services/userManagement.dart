import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/pages/coach_register_screen.dart';

class UserManagement {
  final _auth = Firestore.instance;

  void addUser(FirebaseUser user, BuildContext context) {
    _auth
        .collection('/users')
        .add({'email': user.email, 'uid': user.uid})
        .then((val) => Navigator.pushNamed(context, CoachRegisterScreen.id))
        .catchError((e) => print(e));
  }
}
