import 'package:flutter/material.dart';
import 'package:letsrun/pages/coach_register_screen.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/pages/login_screen.dart';
import 'package:letsrun/pages/maps.dart';
import 'package:letsrun/pages/person_register_screen.dart';
import 'package:letsrun/pages/registration_screen.dart';
import 'package:letsrun/pages/welcome_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case WelcomeScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: WelcomeScreen(),
      );
    case LoginScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginScreen(),
      );
    case RegistrationScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: RegistrationScreen(),
      );
    case CoachRegisterScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CoachRegisterScreen(),
      );
    case PersonRegisterScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PersonRegisterScreen(),
      );
    case HomeScreen.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeScreen(),
      );
    case Maps.id:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Maps(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
