import 'package:animated_card/animated_card.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _currentView = new MenuOption();

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
        return MenuOption();
        break;
      case 1:
        print('this should be an add thing');
        return MenuOption1();
        break;
      case 2:
        print('this should be notif');
        return MenuOption();
        break;
      case 3:
        print('this should be settings');
        return MenuOption();
        break;
      default:
        return MenuOption();
    }
  }
}

class MenuOption extends StatelessWidget {
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
              color: Colors.black45,
              elevation: 5,
              child: ListTile(
                title: Container(
                  height: 150,
                  child: Center(child: Text("$index")),
                ),
              ),
            ),
          ),
        );
      },
    );
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
