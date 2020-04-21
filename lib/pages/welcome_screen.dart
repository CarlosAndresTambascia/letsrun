import 'package:flutter/material.dart';
import 'package:letsrun/pages/login_screen.dart';
import 'package:letsrun/pages/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(25, 100, 25, 25),
          child: Center(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/img/illustration.png',
                  width: 300,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Text(
                  'Estas preparado?',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lets run!'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 48,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Bebas',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Text(
                  'Bienvenido a la ultima aplicacion para ponerte en forma. Aqui vas a poder encontrar entrenadores y gente con pasion por la actividad fisica. Empecemos cuando estes listo!',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: double.infinity,
                  height: 50,
                  child: Text(
                    'Registrate'.toUpperCase(),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                MaterialButton(
                  onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                  minWidth: double.infinity,
                  height: 50,
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Iniciar sesion'.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
