import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/services/firestoreManagement.dart';
import 'package:letsrun/services/homeScreenRoute.dart';
import 'package:loading_animations/loading_animations.dart';

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

  @override
  void initState() {
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
            return Center(
              child: LoadingBouncingGrid.square(
                backgroundColor: Colors.white,
              ),
            );
          } else {
            return Scaffold(
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Theme.of(context).primaryColor,
                items: <Widget>[
                  Icon(Icons.menu, size: 30),
                  Icon(Icons.add, size: 30),
                  Icon(Icons.notifications, size: 30),
                  Icon(Icons.settings, size: 30),
                ],
                onTap: (index) => setState(() => _currentView = HomeScreenRoute().getCorrespondingPage(index)),
              ),
              body: Container(
                color: Theme.of(context).primaryColor,
                child: _currentView,
              ),
            );
          }
        });
  }
}
