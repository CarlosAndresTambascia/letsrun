import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/pages/notifications_screen.dart';
import 'package:letsrun/pages/settings_screen.dart';

import 'new_post_screen.dart';
import 'news_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  static User currentAppUser;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _currentView = new News();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        items: <Widget>[
          Icon(Icons.menu, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.notifications, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        onTap: (index) {
          setState(() => _currentView = _getCorrespondingPage(index));
        },
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: _currentView,
      ),
    );
  }

  Widget _getCorrespondingPage(int index) {
    switch (index) {
      case 0:
        return News();
        break;
      case 1:
        return NewPost();
        break;
      case 2:
        return NotificationsScreen();
        break;
      case 3:
        return Settings();
        break;
      default:
        return News();
    }
  }
}
