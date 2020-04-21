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
  String email;
  String password;
  String name;
  String surname;
  File profilePicture;
  bool _passwordVisible = false;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () => showDialog(context: context, builder: (_) => askForSource()),
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
                          child: Image.asset('assets/img/cam2.png'),
                          radius: 50.0,
                        )),
                  ),
                ),
                TextField(
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
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
                  obscureText: _passwordVisible ? true : false,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Adjunta tu certificado'),
                        subtitle: Text('Para comprobar que eres un entrenador por favor adjunta tu certificacion.'),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'Adjuntar',
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              /* ... */
                            },
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
          ),
        ),
      ),
    );
  }

  AlertDialog askForSource() {
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
    setState(() => profilePicture = selected);
  }
}
