import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nice_button/NiceButton.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool _loading = false;
  User _user = new User('', '', '', '', '', false);
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Iniciar Sesion'),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Padding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      child: Image.asset(
                        'assets/img/illustration.png',
                        width: 450,
                      ),
                      tag: 'logo',
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
                      obscureText: _passwordVisible ? true : false,
                      textAlign: TextAlign.center,
                      validator: _validateField,
                      onChanged: (value) => _user.password = value,
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
                      onPressed: () => _signIn(context),
                      text: 'Iniciar sesion',
                      background: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 88.0),
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

  _signIn(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() => _loading = true);
      var signInUser = await _auth
          .signInWithEmailAndPassword(email: _user.email, password: _user.password)
          .catchError((e) => showExceptionError(context, _handleSingInError(e)));
      setState(() => _loading = false);
      if (signInUser != null) {
        Navigator.pop(context);
        Navigator.pushNamed(context, HomeScreen.id);
      }
    } else {
      showExceptionError(context, null);
    }
  }

  String _handleSingInError(PlatformException e) {
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        return 'Formato de email invalido';
        break;
      case "ERROR_WRONG_PASSWORD":
        return 'Contrasena incorrecta';
        break;
      case "ERROR_USER_NOT_FOUND":
        return 'Usuario no encontrado';
        break;
      case "ERROR_USER_DISABLED":
        return 'El usuario ha sido deshabilitado. Pongase en contacto con el administrador';
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        return 'Demasiados intentos. Intenta mas tarde.';
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        return 'El email y contrasena no han sido habilitados aun.';
        break;
      default:
        return null;
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showExceptionError(BuildContext context, String errorMsg) {
    final defaultMsg = 'Por favor ingrese todos los datos';
    setState(() => _loading = false);
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(errorMsg == null ? defaultMsg : errorMsg),
      duration: Duration(seconds: 3),
    ));
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
