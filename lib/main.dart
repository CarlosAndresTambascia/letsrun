import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letsrun/pages/coach_register_screen.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/pages/login_screen.dart';
import 'package:letsrun/pages/maps.dart';
import 'package:letsrun/pages/person_register_screen.dart';
import 'package:letsrun/pages/registration_screen.dart';
import 'package:letsrun/pages/welcome_screen.dart';
import 'package:loading_animations/loading_animations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseUser user;

  @override
  void initState() {
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return FutureBuilder(
        future: _getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingBouncingGrid.square(
                backgroundColor: Colors.white,
              ),
            );
          } else {
            return MaterialApp(
              title: 'Lets Run',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color(0XFF6D3FFF),
                accentColor: Color(0XFF233C63),
                fontFamily: 'Poppins',
              ),
              initialRoute: user == null ? WelcomeScreen.id : HomeScreen.id,
              routes: {
                WelcomeScreen.id: (context) => WelcomeScreen(),
                LoginScreen.id: (context) => LoginScreen(),
                RegistrationScreen.id: (context) => RegistrationScreen(),
                CoachRegisterScreen.id: (context) => CoachRegisterScreen(),
                PersonRegisterScreen.id: (context) => PersonRegisterScreen(),
                HomeScreen.id: (context) => HomeScreen(),
                Maps.id: (context) => Maps(),
                //ChatScreen.id: (context) => ChatScreen(),
              },
            );
          }
        });
  }

  Future<FirebaseUser> _getCurrentUser() {
    return FirebaseAuth.instance.currentUser().then((actualUser) {
      user = actualUser;
    }).catchError((e) => print(e));
  }
}
