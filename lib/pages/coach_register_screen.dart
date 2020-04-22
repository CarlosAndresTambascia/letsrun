import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:nice_button/NiceButton.dart';

class CoachRegisterScreen extends StatefulWidget {
  static String id = 'coach_register_screen';

  @override
  _CoachRegisterScreen createState() => _CoachRegisterScreen();
}

class _CoachRegisterScreen extends State<CoachRegisterScreen> {
  String _email;
  String _password;
  String _name;
  String _surname;
  File _profilePicture;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => showDialog(context: context, builder: (_) => _askForSource()),
                    child: AvatarGlow(
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
                            child: Icon(
                              Icons.add_a_photo,
                              size: 35.0,
                              color: Colors.black54,
                            ),
                            radius: 50.0,
                          )),
                    ),
                  ),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      _name = value;
                    },
                    //Todo: add validation for the fields
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Nombre Completo'),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
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
                  Card(
                    elevation: 15.0,
                    margin: EdgeInsets.all(7.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text('Adjunta tu titulo o certificado de entrenador'),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                'Adjuntar',
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () => showDialog(context: context, builder: (_) => _askForSource()),
                            ),
                          ],
                        ),
                      ],
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
                    icon: Icons.person,
                    onPressed: () {},
                    text: 'Registrame',
                    background: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog _askForSource() {
    return AlertDialog(
      title: Text('De donde quieres tomar la fotografia?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => _pickImage(ImageSource.camera),
          child: Text(
            'Camara',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        FlatButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: Text(
            'Galeria',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
      elevation: 24.0,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() => _profilePicture = selected);
  }
}
