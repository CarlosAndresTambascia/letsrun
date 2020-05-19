import 'package:flutter/material.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/pages/welcome_screen.dart';
import 'package:letsrun/plugins/loading_widget.dart';
import 'package:letsrun/services/authentication_service.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootView extends StatefulWidget {
  RootView({@required this.auth});

  final FirebaseAuthService auth;

  @override
  State<StatefulWidget> createState() => new _RootViewState();
}

class _RootViewState extends State<RootView> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user?.uid;

        if (_userId.length > 0 && _userId != null) {
          authStatus = AuthStatus.LOGGED_IN;
        } else {
          authStatus = AuthStatus.NOT_LOGGED_IN;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_LOGGED_IN:
        return new WelcomeScreen();
        break;
      case AuthStatus.LOGGED_IN:
        return new HomeScreen();
        break;
      case AuthStatus.NOT_DETERMINED:
      default:
        return new LoadingWidget();
    }
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }
}
