import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0XFF6a54b0),
            Color(0xFF2953a7),
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        ),
        child: Center(
          child: LoadingBouncingGrid.square(
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
