import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final lista = List.generate(50, (index) => index);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        return AnimatedCard(
          direction: AnimatedCardDirection.top,
          initDelay: Duration(milliseconds: 0),
          duration: Duration(seconds: 0),
          curve: Curves.bounceOut,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Card(
              color: Colors.white70,
              elevation: 5,
              child: ListTile(
                title: Container(
                  height: 100,
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
