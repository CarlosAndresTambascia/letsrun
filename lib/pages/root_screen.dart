import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/pages/welcome_screen.dart';
import 'package:letsrun/plugins/loading_widget.dart';
import 'package:letsrun/services/authentication_service.dart';
import 'package:letsrun/services/firestore_service.dart';

import '../locator.dart';

class RootView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootViewState();
}

class _RootViewState extends State<RootView> {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    handleAppStartup(context);
    // TODO: Maybe there is a better way to show a loading screen.
    return new LoadingWidget();
  }

  void handleAppStartup(BuildContext context) async {
    final FirebaseUser firebaseUser = await _firebaseAuthService.getCurrentUser();
    if (firebaseUser != null) {
      final User user = await _firestoreService.getUser(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomeScreen.id, arguments: ScreenArguments(user));
    } else {
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }
  }
}

class ScreenArguments {
  final User user;

  ScreenArguments(this.user);
}
