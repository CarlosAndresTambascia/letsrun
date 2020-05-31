import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/pages/settings_screen.dart';

import 'new_post_screen.dart';
import 'news_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  final User currentAppUser;

  HomeScreen({@required this.currentAppUser});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _fbm = FirebaseMessaging();
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _setupPushNotifications();
    return widget.currentAppUser.isCoach
        ? HomeScreenNavigation(
            pageController: _pageController,
            children: <Widget>[
              News(currentAppUser: widget.currentAppUser),
              NewPost(currentAppUser: widget.currentAppUser),
              NotificationsScreen(currentAppUser: widget.currentAppUser),
              Settings(currentAppUser: widget.currentAppUser),
            ],
            items: <Widget>[
              BottomNavigationIcons.posts.call(context),
              BottomNavigationIcons.addPosts.call(context),
              BottomNavigationIcons.notifications.call(context),
              BottomNavigationIcons.settings.call(context),
            ],
            onPageChanged: (int index) {
              setState(() => _pageController.jumpToPage(index));
            },
          )
        : HomeScreenNavigation(
            pageController: _pageController,
            children: <Widget>[
              News(currentAppUser: widget.currentAppUser),
              NotificationsScreen(currentAppUser: widget.currentAppUser),
              Settings(currentAppUser: widget.currentAppUser),
            ],
            items: <Widget>[
              BottomNavigationIcons.posts.call(context),
              BottomNavigationIcons.notifications.call(context),
              BottomNavigationIcons.settings.call(context),
            ],
            onPageChanged: (int index) => setState(() => _pageController.jumpToPage(index)));
  }

  void _setupPushNotifications() {
    _fbm.requestNotificationPermissions();
    if (!widget.currentAppUser.isCoach) {
      _fbm.subscribeToTopic('posts');
    }
    _fbm.configure(onMessage: (msg) {
      setState(() => _pageController.jumpToPage(1));
      return;
    }, onLaunch: (msg) {
      return;
    }, onResume: (msg) {
      return;
    });
  }
}

class HomeScreenNavigation extends StatefulWidget {
  final GlobalKey _bottomNavigationKey = GlobalKey();
  final PageController pageController;
  final Function(int) onPageChanged;
  final List<Widget> children;
  final List<Widget> items;

  HomeScreenNavigation({
    @required this.pageController,
    @required this.onPageChanged,
    @required this.children,
    @required this.items,
  });

  @override
  _HomeScreenNavigationState createState() => _HomeScreenNavigationState();
}

class _HomeScreenNavigationState extends State<HomeScreenNavigation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new PageView(controller: widget.pageController, children: widget.children, onPageChanged: widget.onPageChanged),
      bottomNavigationBar: CurvedNavigationBar(
        key: widget._bottomNavigationKey,
        buttonBackgroundColor: Colors.white70,
        backgroundColor: Color(0XFF6a54b0),
        items: widget.items,
        onTap: widget.onPageChanged,
      ),
    );
  }
}

class BottomNavigationIcons {
  static Icon Function(BuildContext) posts = (context) => Icon(Icons.menu, size: 30, color: Theme.of(context).primaryColor);
  static Icon Function(BuildContext) addPosts = (context) => Icon(Icons.add, size: 30, color: Theme.of(context).primaryColor);
  static Icon Function(BuildContext) notifications = (context) => Icon(Icons.notifications, size: 30, color: Theme.of(context).primaryColor);
  static Icon Function(BuildContext) settings = (context) => Icon(Icons.settings, size: 30, color: Theme.of(context).primaryColor);
}
