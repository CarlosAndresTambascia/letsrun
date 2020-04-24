import 'package:animated_card/animated_card.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/pages/notifications_screen.dart';
import 'package:letsrun/pages/settings_screen.dart';

import 'news_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _currentView = new NewPost();

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
          setState(() {
            _currentView = _getCorrespondingPage(index);
          });
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
        return NewPost();
        break;
      case 1:
        return MenuOption1();
        break;
      case 2:
        return NotificationsScreen();
        break;
      case 3:
        return Settings();
        break;
      default:
        return NewPost();
    }
  }
}

class MenuOption1 extends StatelessWidget {
  final lista = List.generate(50, (index) => index);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        return AnimatedCard(
          direction: AnimatedCardDirection.left,
          //Initial animation direction
          initDelay: Duration(milliseconds: 0),
          //Delay to initial animation
          duration: Duration(seconds: 1),
          //Initial animation duration
          curve: Curves.bounceOut,
          //Animation curve
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              color: Colors.red,
              elevation: 5,
              child: ListTile(
                title: Container(
                  height: 150,
                  child: Center(child: Text("charly is da best")),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
