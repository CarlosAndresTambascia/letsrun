import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letsrun/pages/coach_register_screen.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/pages/login_screen.dart';
import 'package:letsrun/pages/maps.dart';
import 'package:letsrun/pages/person_register_screen.dart';
import 'package:letsrun/pages/registration_screen.dart';
import 'package:letsrun/pages/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Lets Run',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0XFF6D3FFF),
        accentColor: Color(0XFF233C63),
        fontFamily: 'Poppins',
      ),
      initialRoute: WelcomeScreen.id,
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
}
