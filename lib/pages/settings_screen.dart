import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsrun/pages/home_screen.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File _profilePicture;

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
                          child: HomeScreen.currentAppUser.profilePictureUrl == "" ||
                                  HomeScreen.currentAppUser.profilePictureUrl == null
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
                GestureDetector(
                  child: Card(
                    elevation: 15.0,
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text('Editar Perfil', textAlign: TextAlign.center),
                        ),
                      ],
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
}
