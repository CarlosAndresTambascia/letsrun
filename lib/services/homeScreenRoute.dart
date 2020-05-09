import 'package:flutter/material.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/pages/new_post_screen.dart';
import 'package:letsrun/pages/news_screen.dart';
import 'package:letsrun/pages/notifications_screen.dart';
import 'package:letsrun/pages/settings_screen.dart';

class HomeScreenRoute {
  Widget getCorrespondingPage(int index) {
    switch (index) {
      case 0:
        return News();
        break;
      case 1:
        return HomeScreen.currentAppUser.isCoach ? NewPost() : NotificationsScreen();
        break;
      case 2:
        return HomeScreen.currentAppUser.isCoach ? NotificationsScreen() : Settings();
        break;
      case 3:
        return Settings();
        break;
      default:
        return News();
    }
  }
}
