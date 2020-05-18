import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/plugins/loading_widget.dart';
import 'package:letsrun/services/firestoreManagement.dart';
import 'package:letsrun/services/homeScreenRoute.dart';

import 'news_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  static User currentAppUser;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _currentView = new News();
  final _auth = FirebaseAuth.instance;
  Future<User> futureUser;
  final _fbm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    futureUser = FirestoreManagement()
        .getAppUser(_auth.currentUser())
        .then((data) => HomeScreen.currentAppUser = data)
        .catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          } else {
            _setupPushNotifications();
            return Scaffold(
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Theme.of(context).primaryColor,
                items: HomeScreen.currentAppUser.isCoach
                    ? <Widget>[
                        Icon(Icons.menu, size: 30),
                        Icon(Icons.add, size: 30),
                        Icon(Icons.notifications, size: 30),
                        Icon(Icons.settings, size: 30),
                      ]
                    : <Widget>[
                        Icon(Icons.menu, size: 30),
                        Icon(Icons.notifications, size: 30),
                        Icon(Icons.settings, size: 30),
                      ],
                onTap: (index) => setState(() => _currentView = HomeScreenRoute().getCorrespondingPage(index)),
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0XFF6a54b0),
                    Color(0xFF2953a7),
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
                child: _currentView,
              ),
            );
          }
        });
  }

  void _setupPushNotifications() {
    _fbm.requestNotificationPermissions();
    if (!HomeScreen.currentAppUser.isCoach) {
      _fbm.subscribeToTopic('posts');
    }
    _fbm.configure(onMessage: (msg) {
      setState(() => _currentView = HomeScreenRoute().getCorrespondingPage(1));
      return;
    }, onLaunch: (msg) {
      return;
    }, onResume: (msg) {
      return;
    });
  }
}
