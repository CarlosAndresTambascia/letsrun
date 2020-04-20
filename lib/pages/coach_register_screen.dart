import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:nice_button/NiceButton.dart';

class CoachRegisterScreen extends StatefulWidget {
  static String id = 'coach_register_screen';

  @override
  _CoachRegisterScreen createState() => _CoachRegisterScreen();
}

class _CoachRegisterScreen extends State<CoachRegisterScreen> {
  String email;
  String password;
  String name;
  String surname;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Registro'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AvatarGlow(
              endRadius: 90,
              duration: Duration(seconds: 2),
              glowColor: Colors.white24,
              repeat: true,
              repeatPauseDuration: Duration(seconds: 2),
              startDelay: Duration(seconds: 1),
              child: Material(
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: Image.asset('assets/img/illustration.png'),
                    radius: 50.0,
                  )),
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              onChanged: (value) {
                name = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Nombre'),
            ),
            SizedBox(
              height: 25.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              onChanged: (value) {
                surname = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Apellido'),
            ),
            SizedBox(
              height: 25.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
            ),
            SizedBox(
              height: 25.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Contrasena'),
            ),
            SizedBox(height: 25.0),
            NiceButton(
              padding: EdgeInsets.all(15.0),
              radius: 30.0,
              elevation: 5,
              mini: false,
              icon: Icons.person,
              onPressed: () {},
              text: 'Registrame',
              background: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
