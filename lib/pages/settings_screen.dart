import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsrun/locator.dart';
import 'package:letsrun/models/user.dart';
import 'package:letsrun/pages/welcome_screen.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:letsrun/services/authentication_service.dart';

class Settings extends StatefulWidget {
  final User currentAppUser;

  Settings({@required this.currentAppUser});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File _profilePicture;
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          child: Column(children: <Widget>[
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
                      child: widget.currentAppUser.profilePictureUrl == "" ||
                              widget.currentAppUser.profilePictureUrl == null
                          ? Icon(
                              Icons.add_a_photo,
                              size: 35.0,
                              color: Colors.black54,
                            )
                          : CircleAvatar(
                              maxRadius: 90,
                              backgroundImage: NetworkImage(widget.currentAppUser.profilePictureUrl),
                            ),
                      radius: 50.0,
                    )),
              ),
            ),
            Text(
              widget.currentAppUser.fullName,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Lobster', fontSize: 28.0, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Material(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 350,
                      height: 300,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.multiline,
                            maxLength: 260,
                            maxLines: 8,
                            decoration: kDescriptionDecoration,
                            //onChanged: (value) => _post.description = value,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
                elevation: 5.0,
                color: Colors.white,
              ),
            ),
            widget.currentAppUser.isCoach
                ? Container(
                    width: 200.0,
                    height: 180.0,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: widget.currentAppUser.certificateUrl == "" ||
                                    widget.currentAppUser.certificateUrl == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: 35.0,
                                    color: Colors.black54,
                                  )
                                : NetworkImage(
                                    widget.currentAppUser.certificateUrl,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ]),
          padding: EdgeInsets.all(10.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
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
    _firebaseAuthService.logout().then((val) {
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
