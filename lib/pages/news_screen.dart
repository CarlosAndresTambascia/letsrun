import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPost extends StatelessWidget {
  final lista = List.generate(50, (index) => index);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        return AnimatedCard(
          direction: AnimatedCardDirection.left,
          initDelay: Duration(milliseconds: 0),
          duration: Duration(seconds: 1),
          curve: Curves.bounceOut,
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
