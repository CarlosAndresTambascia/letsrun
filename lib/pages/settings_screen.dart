import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/pages/welcome_screen.dart';
import 'package:letsrun/plugins/Exception.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:letsrun/services/firestoreManagement.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File _profilePicture;
  File _certificatePicture;
  final _auth = FirebaseAuth.instance;
  final isCoach = HomeScreen.currentAppUser.isCoach;
  final _store = FirebaseStorage.instance;
  final _picId = HomeScreen.currentAppUser.picId;
  bool _loading = false;
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: SingleChildScrollView(
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
                onTap: () => showDialog(context: context, builder: (_) => _askForSource(true)),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: FadeInImage(
                            width: 100,
                            height: 100,
                            placeholder: AssetImage('assets/img/defaultProfile.jpg'),
                            image: NetworkImage(HomeScreen.currentAppUser.profilePictureUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        radius: 50.0,
                      )),
                ),
              ),
              Text(
                HomeScreen.currentAppUser.fullName,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontFamily: 'Lobster', fontSize: 28.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 350,
                      height: 300,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            autocorrect: true,
                            keyboardType: TextInputType.multiline,
                            maxLength: 260,
                            maxLines: 8,
                            decoration: kDescriptionDecoration.copyWith(
                                hintText: 'Agregar informacion personal',
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hoverColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.white)),
                            onChanged: (value) => setState(() => _description = value),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _description.isNotEmpty,
                      child: InkWell(
                        onTap: () => _addUserDescription(context),
                        child: Card(
                          color: Colors.white70,
                          elevation: 15.0,
                          margin: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text('Agregar', textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isCoach
                  ? Expanded(
                      child: GestureDetector(
                        onTap: () => showDialog(context: context, builder: (_) => _askForSource(false)),
                        child: Container(
                          color: Colors.white70,
                          width: 300.0,
                          height: 200.0,
                          margin: EdgeInsets.only(top: 15.0),
                          child: FadeInImage(
                            placeholder: AssetImage('assets/img/defaultCertificate.png'),
                            image: NetworkImage(HomeScreen.currentAppUser.certificateUrl),
                            fit: BoxFit.cover,
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
      ),
      inAsyncCall: _loading,
    );
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
      _uploadProfileImage();
    } else {
      setState(() => _certificatePicture = selected);
      _uploadCertificate();
    }
  }

  Future _uploadProfileImage() async {
    var storageReference = _store.ref().child('profilePics/$_picId.jpg');
    setState(() {
      Navigator.pop(context);
      _loading = true;
    });
    StorageUploadTask task = storageReference.putFile(_profilePicture);
    FirestoreManagement()
        .uploadProfilePic(await (await task.onComplete).ref.getDownloadURL(), HomeScreen.currentAppUser);
    setState(() => _loading = false);
  }

  Future _uploadCertificate() async {
    var storageReference = _store.ref().child('certificatePics/$_picId.jpg');
    setState(() {
      Navigator.pop(context);
      _loading = true;
    });
    StorageUploadTask task = storageReference.putFile(_certificatePicture);
    HomeScreen.currentAppUser.certificateUrl = (await (await task.onComplete).ref.getDownloadURL());
    setState(() => _loading = false);
  }

  _logout(BuildContext context) {
    _auth.signOut().then((val) {
      Navigator.pop(context);
      Navigator.pushNamed(context, WelcomeScreen.id);
    }).catchError((e) => print(e));
  }

  _addUserDescription(BuildContext context) async {
    try {
      setState(() => _loading = true);
      await FirestoreManagement().addUserDescription(_description);
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        return Exception.showException(context);
      });
    }
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
