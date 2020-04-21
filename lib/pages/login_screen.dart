import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:nice_button/NiceButton.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  String _email;
  String _password;
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Registro'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _email = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
            ),
            SizedBox(
              height: 25.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              obscureText: _passwordVisible ? true : false,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Contrasena',
                suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      semanticLabel: _passwordVisible ? 'hide password' : 'show password',
                    ),
                    onPressed: () => setState(() => _passwordVisible ^= true)),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            NiceButton(
              padding: EdgeInsets.all(15.0),
              radius: 30.0,
              elevation: 5,
              mini: false,
              onPressed: () {},
              text: 'Iniciar sesion',
              background: Theme.of(context).primaryColor,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      ),
    );
  }
}
