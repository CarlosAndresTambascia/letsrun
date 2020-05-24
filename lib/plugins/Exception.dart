import 'package:flutter/material.dart';

class Exception {
  static showException(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('oh oh'),
        content: Text('Hubo un problema, por favor intenta mas tarde'),
        actions: <Widget>[
          FlatButton(
            child: Text('Entendido'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
