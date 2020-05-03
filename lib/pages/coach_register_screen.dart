import 'dart:io';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:letsrun/services/userManagement.dart';
import 'package:nice_button/NiceButton.dart';

class CoachRegisterScreen extends StatefulWidget {
  static String id = 'coach_register_screen';

  @override
  _CoachRegisterScreen createState() => _CoachRegisterScreen();
}

class _CoachRegisterScreen extends State<CoachRegisterScreen> {
  User _user = new User('', '', '', '', '');
  bool _passwordVisible = true;
  File _profilePicture;
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((user) {
      _user.profilePictureUrl = user.photoUrl;
    }).catchError((e) => print(e));
  }

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
                            child: _user.profilePictureUrl == ""
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: 35.0,
                                    color: Colors.black54,
                                  )
                                : Image(
                                    image: NetworkImage(_user.profilePictureUrl),
                                  ),
                            radius: 50.0,
                          )),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    onChanged: (value) => _user.fullName = value,
                    validator: (value) => 'Por favor completar este campo.',
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Nombre Completo'),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) => _user.email = value,
                    validator: (value) => 'Por favor completar este campo.',
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.text,
                    obscureText: _passwordVisible ? true : false,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      _user.password = value;
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
                    onPressed: () => _register(),
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
    _uploadImage();
  }

  _uploadImage() async {
    var random = Random(25);
    var storageReference = _store.ref().child('profilePics/${random.nextInt(5000).toString()}.jpg');
    StorageUploadTask task = storageReference.putFile(_profilePicture);

    UserManagement().uploadProfilePic(await (await task.onComplete).ref.getDownloadURL(), _user);
  }

  _register() {
    _auth
        .createUserWithEmailAndPassword(email: _user.email, password: _user.password)
        //.then(_validateFields())
        //.catchError((e) => print(e))
        .then((createdUser) => UserManagement().addUser(createdUser.user, context, _user))
        .catchError((e) => print(e));
  }

  _validateFields() {
    if (_profilePicture == null ||
        _user.email == "" ||
        _user.password == "" ||
        _user.profilePictureUrl == "" ||
        _user.fullName == "") {
      throw (new Exception('Por favor complete todos los datos'));
    }
  }
}
