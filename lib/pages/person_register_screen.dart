import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/pages/root_screen.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:letsrun/services/authentication_service.dart';
import 'package:letsrun/services/firestore_service.dart';
import 'package:letsrun/services/storage_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nice_button/NiceButton.dart';

import '../locator.dart';
import 'home_screen.dart';

class PersonRegisterScreen extends StatefulWidget {
  static const String id = 'person_register_screen';

  @override
  _PersonRegisterScreen createState() => _PersonRegisterScreen();
}

// TODO: merge common logic with CoachRegisterScreen
class _PersonRegisterScreen extends State<PersonRegisterScreen> {
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FocusNode _passwordFocus = new FocusNode();
  final FocusNode _emailFocus = new FocusNode();
  User _user = new User('', '', '', '', '', false);
  bool _passwordVisible = true;
  bool _loading = false;
  File _profilePicture;
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
                        onTap: () => showDialog(context: context, builder: (_) => _askForSource()),
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
                        validator: _validateField,
                        onChanged: (value) => _user.fullName = value,
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Nombre Completo'),
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                      ),
                      Divider(),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        validator: _validateField,
                        onChanged: (value) => _user.email = value,
                        decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                        focusNode: _emailFocus,
                      ),
                      Divider(),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        validator: _validateField,
                        obscureText: _passwordVisible ? true : false,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          _password = value;
                        },
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

  _register(BuildContext context) async {
    try {
      if (_formKey.currentState.validate() && _validateFields()) {
        setState(() => _loading = true);

        final AuthResult authResult = await _firebaseAuthService.register(_user.email, _password);

        final User newUser = new User(authResult.user.uid, _user.email, _user.fullName, _user.profilePictureUrl, _user.certificateUrl, _user.isCoach);

        await _firestoreService.createUser(newUser);

        setState(() => _loading = false);

        Navigator.pushReplacementNamed(context, HomeScreen.id, arguments: ScreenArguments(newUser));
      } else {
        showExceptionError(context, null);
      }
    } catch (e) {
      showExceptionError(context, _handleAuthError(e));
      setState(() => _loading = false);
    }
  }

  bool _validateFields() {
    if (_user.email == "" || _password == "" || _user.profilePictureUrl == "" || _user.fullName == "") {
      return false;
    }
    return true;
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showExceptionError(BuildContext context, String errorMsg) {
    final defaultMsg = 'Por favor ingrese todos los datos y adjunte la/s imagene/s';
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(errorMsg == null ? defaultMsg : errorMsg),
      duration: Duration(seconds: 3),
    ));
  }

  String _handleAuthError(PlatformException e) {
    print(e);
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        return 'Formato de email invalido';
        break;
      case "ERROR_WEAK_PASSWORD":
        return 'La Contraseña es demasiado debil';
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
    return const SizedBox(
      height: 25.0,
    );
  }
}
