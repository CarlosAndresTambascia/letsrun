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
      body: Center(
        child: LoadingBouncingGrid.square(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
