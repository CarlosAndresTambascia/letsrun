import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/pages/person_register_screen.dart';
import 'package:nice_button/NiceButton.dart';

import 'coach_register_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Registro'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).primaryColor.withAlpha(50),
                ),
                child: Image.asset(
                  'assets/img/shoe.png',
                  width: 60.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 130),
              ),
              NiceButton(
                elevation: 5,
                mini: false,
                icon: Icons.fitness_center,
                onPressed: () => Navigator.pushNamed(context, CoachRegisterScreen.id),
                text: 'Soy Profesor',
                background: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(15.0),
                radius: 30.0,
              ),
              SizedBox(
                height: 60,
              ),
              NiceButton(
                padding: EdgeInsets.all(15.0),
                radius: 30.0,
                elevation: 5,
                mini: false,
                icon: Icons.person,
                onPressed: () => Navigator.pushNamed(context, PersonRegisterScreen.id),
                text: 'Quiero entrenar',
                background: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
