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

class PersonRegisterScreen extends StatefulWidget {
  static String id = 'person_register_screen';

  @override
  _PersonRegisterScreen createState() => _PersonRegisterScreen();
}

class _PersonRegisterScreen extends State<PersonRegisterScreen> {
  User _user = new User('', '', '', '', '');
  bool _passwordVisible = true;
  bool _loading = false;
  File _profilePicture;
  File _certificatePicture;
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  var _randomPicsId = Random(25).nextInt(5000).toString();

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
            child: Form(
              key: _formKey,
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
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      validator: _validateField,
                      onChanged: (value) => _user.fullName = value,
                      decoration: kTextFieldDecoration.copyWith(hintText: 'Nombre Completo'),
                    ),
                    Divider(),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      validator: _validateField,
                      onChanged: (value) => _user.email = value,
                      decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
                    ),
                    Divider(),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      validator: _validateField,
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
                    Divider(),
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
      ),
    );
  }

  String _validateField(value) {
    if (value.isEmpty) {
      return 'Por favor completa este campo';
    }
    return null;
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
    _uploadProfileImage().whenComplete(() {
      setState(() {});
    });
  }

  Future _uploadProfileImage() async {
    var storageReference = _store.ref().child('profilePics/$_randomPicsId.jpg');
    setState(() {
      Navigator.pop(context);
      _loading = true;
    });
    StorageUploadTask task = storageReference.putFile(_profilePicture);
    UserManagement().uploadProfilePic(await (await task.onComplete).ref.getDownloadURL(), _user);
    setState(() => _loading = false);
  }

  _register() {
    if (_formKey.currentState.validate()) {
      _auth
          .createUserWithEmailAndPassword(email: _user.email, password: _user.password)
          //.then(_validateFields())
          //.catchError((e) => print(e))
          .then((createdUser) => UserManagement().addUser(createdUser.user, context, _user))
          .catchError((e) => print(e));
    }
  }

  _validateFields() {
    if (_profilePicture == null ||
        _user.email == '' ||
        _user.password == '' ||
        _user.profilePictureUrl == '' ||
        _user.fullName == '' ||
        _certificatePicture == null) {
      throw Exception;
    }
  }

  AlertDialog _showErrorMsg(Exception e) {
    return AlertDialog(title: Text('De donde quieres tomar la fotografia?'));
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.0,
    );
  }
}
