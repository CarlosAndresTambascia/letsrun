import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/pages/welcome_screen.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File _profilePicture;
  final _auth = FirebaseAuth.instance;
  final isCoach = HomeScreen.currentAppUser.isCoach;
  bool editing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: () => _logout(context),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.exit_to_app, size: 25.0),
                    heroTag: 'exit',
                  ),
                ),
                GestureDetector(
                  onTap: () => editing ? showDialog(context: context, builder: (_) => _askForSource()) : null,
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
                          child: HomeScreen.currentAppUser.profilePictureUrl == "" ||
                                  HomeScreen.currentAppUser.profilePictureUrl == null ||
                                  editing
                              ? Icon(
                                  Icons.add_a_photo,
                                  size: 35.0,
                                  color: Colors.black54,
                                )
                              : CircleAvatar(
                                  maxRadius: 90,
                                  backgroundImage: NetworkImage(HomeScreen.currentAppUser.profilePictureUrl),
                                ),
                          radius: 50.0,
                        )),
                  ),
                ),
                Text(
                  HomeScreen.currentAppUser.fullName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Lobster', fontSize: 28.0, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                isCoach
                    ? Container(
                        width: 300.0,
                        height: 300.0,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: HomeScreen.currentAppUser.certificateUrl == "" ||
                                        HomeScreen.currentAppUser.certificateUrl == null ||
                                        editing
                                    ? Icon(
                                        Icons.add_a_photo,
                                        size: 35.0,
                                        color: Colors.black54,
                                      )
                                    : NetworkImage(
                                        HomeScreen.currentAppUser.certificateUrl,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                Visibility(
                  visible: !editing,
                  child: InkWell(
                    onTap: () => setState(() => editing = true),
                    child: EditProfileButton(
                      buttonText: 'Editar Perfil',
                    ),
                  ),
                ),
                Visibility(
                  visible: editing,
                  child: InkWell(
                    onTap: () => setState(() => editing = false),
                    child: EditProfileButton(
                      buttonText: 'Terminado',
                    ),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 88.0),
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

  _logout(BuildContext context) {
    _auth.signOut().then((val) {
      Navigator.pop(context);
      Navigator.pushNamed(context, WelcomeScreen.id);
    }).catchError((e) => print(e));
  }
}

class EditProfileButton extends StatelessWidget {
  final buttonText;

  const EditProfileButton({
    Key key,
    @required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15.0,
      margin: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(buttonText, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
