import 'package:flutter/material.dart';
import 'package:letsrun/pages/root_screen.dart';
import 'package:letsrun/router.dart';
import 'package:letsrun/services/authentication_service.dart';

void main() => runApp(LetsRunApp());

class LetsRunApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lets Run',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0XFF6D3FFF),
        accentColor: Color(0XFF233C63),
        fontFamily: 'Poppins',
      ),
      home: RootView(auth: new FirebaseAuthService()),
      onGenerateRoute: generateRoute,
    );
  }
}
