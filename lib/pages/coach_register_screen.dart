import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:letsrun/services/authentication_service.dart';
import 'package:letsrun/services/firestore_service.dart';
import 'package:letsrun/services/storage_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nice_button/NiceButton.dart';

import '../locator.dart';

class CoachRegisterScreen extends StatefulWidget {
  static const String id = 'coach_register_screen';

  @override
  _CoachRegisterScreen createState() => _CoachRegisterScreen();
}

// TODO: merge common logic with PersonRegisterScreen
class _CoachRegisterScreen extends State<CoachRegisterScreen> {
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  User _user = new User('', '', '', '', '', true);
  bool _passwordVisible = true;
  bool _loading = false;
  File _profilePicture;
  File _certificatePicture;
  String _password; // TODO: This is a placeholder for a future fix

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        key: _scaffoldKey,
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
                        onTap: () => showDialog(context: context, builder: (_) => _askForSource(true)),
                        child: AvatarGlow(
                          endRadius: 90.0,
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
                                child: _user.profilePictureUrl == "" || _user.profilePictureUrl == null
                                    ? Icon(
                                        Icons.add_a_photo,
                                        size: 35.0,
                                        color: Colors.black54,
                                      )
                                    : CircleAvatar(
                                        maxRadius: 90,
                                        backgroundImage: NetworkImage(_user.profilePictureUrl),
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
                        validator: _validateField,
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Nombre Completo'),
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                      ),
                      Divider(),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) => _user.email = value,
                        validator: _validateField,
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
                        focusNode: _emailFocus,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                      ),
                      Divider(),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        obscureText: _passwordVisible ? true : false,
                        textAlign: TextAlign.center,
                        validator: _validateField,
                        onChanged: (value) => _password = value,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Contraseña',
                          suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                semanticLabel: _passwordVisible ? 'hide password' : 'show password',
                              ),
                              onPressed: () => setState(() => _passwordVisible ^= true)),
                        ),
                        focusNode: _passwordFocus,
                      ),
                      Divider(),
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
                                  onPressed: () => showDialog(context: context, builder: (_) => _askForSource(false)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      NiceButton(
                        padding: EdgeInsets.all(15.0),
                        radius: 30.0,
                        elevation: 5,
                        mini: false,
                        icon: Icons.person,
                        onPressed: () => _register(context),
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
      ),
      inAsyncCall: _loading,
    );
  }

  String _validateField(value) {
    if (value.isEmpty) {
      return 'Por favor completa este campo';
    }
    return null;
  }

  AlertDialog _askForSource(bool isProfile) {
    return AlertDialog(
      title: Text('De donde quieres tomar la fotografia?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => _pickImage(ImageSource.camera, isProfile),
          child: Text(
            'Camara',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        FlatButton(
          onPressed: () => _pickImage(ImageSource.gallery, isProfile),
          child: Text(
            'Galeria',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
      elevation: 24.0,
    );
  }

  Future<void> _pickImage(ImageSource source, bool isProfile) async {
    File selected = await ImagePicker.pickImage(source: source);
    if (isProfile) {
      setState(() => _profilePicture = selected);
      _uploadProfileImage().whenComplete(() {
        setState(() {});
      });
    } else {
      setState(() => _certificatePicture = selected);
      _uploadCertificate().whenComplete(() {
        setState(() {});
      });
    }
  }

  Future _uploadProfileImage() async {
    setState(() {
      Navigator.pop(context);
      _loading = true;
    });
    final String picUrl = await _firebaseStorageService.uploadProfilePicture(_profilePicture);
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;
    _user.profilePictureUrl = picUrl;
    setState(() => _loading = false);
  }

  Future _uploadCertificate() async {
    setState(() {
      Navigator.pop(context);
      _loading = true;
    });
    final String certUrl = await _firebaseStorageService.uploadCertificate(_profilePicture);
    _user.certificateUrl = certUrl;
    setState(() => _loading = false);
  }

  _register(BuildContext context) async {
    try {
      if (_formKey.currentState.validate() && _validateFields()) {
        setState(() => _loading = true);

        final AuthResult authResult = await _firebaseAuthService.register(_user.email, _password);

        final User newUser = new User(authResult.user.uid, _user.email, _user.fullName, _user.profilePictureUrl, _user.certificateUrl, _user.isCoach);

        await _firestoreService.createUser(newUser);

        setState(() => _loading = false);
      } else {
        showExceptionError(context, null);
      }
    } catch (e) {
      showExceptionError(context, _handleAuthError(e));
    }
  }

  bool _validateFields() {
    if (_user.email == "" ||
        _password == "" ||
        _user.profilePictureUrl == "" ||
        _user.fullName == "" ||
        _user.certificateUrl == "") {
      return false;
    }
    return true;
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showExceptionError(BuildContext context, String errorMsg) {
    final defaultMsg = 'Por favor ingrese todos los datos y adjunte ambas imagenes';
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(errorMsg == null ? defaultMsg : errorMsg),
      duration: Duration(seconds: 3),
    ));
  }

  String _handleAuthError(PlatformException e) {
    print(e);
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        return 'Formato de email inválido';
        break;
      case "ERROR_WEAK_PASSWORD":
        return 'La Contraseña es demasiado débil';
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return 'El email ingresado ya esta registrado';
        break;
      default:
        return null;
    }
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
