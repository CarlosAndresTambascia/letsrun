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
  TextEditingController textEditingController = new TextEditingController();
  bool _loading = false;
  String _description = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0XFF6a54b0),
                Color(0xFF2953a7),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
            ),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          onPressed: () => _logout(context),
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.exit_to_app, size: 25.0),
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
                        style: TextStyle(
                            fontFamily: 'PTSansNarrow',
                            fontSize: 28.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(60.0),
                        topLeft: Radius.circular(60.0),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 230,
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                    autocorrect: true,
                                    keyboardType: TextInputType.multiline,
                                    maxLength: 260,
                                    maxLines: 6,
                                    controller: textEditingController,
                                    decoration: kDescriptionDecoration.copyWith(
                                        hintText: 'Agregar informacion personal',
                                        fillColor: Colors.black,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                        ),
                                        border: InputBorder.none,
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
                                  margin: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 40.0, right: 40.0),
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
                        isCoach
                            ? Container(
                                child: GestureDetector(
                                  onTap: () => showDialog(context: context, builder: (_) => _askForSource(false)),
                                  child: Container(
                                    color: Colors.white70,
                                    width: 300.0,
                                    height: 200.0,
                                    child: FadeInImage(
                                      placeholder: AssetImage('assets/img/defaultCertificate.png'),
                                      image: NetworkImage(HomeScreen.currentAppUser.certificateUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
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
      _uploadProfileImage().catchError((e) => setState(() => _loading = false));
    } else {
      setState(() => _certificatePicture = selected);
      _uploadCertificate().catchError((e) => setState(() => _loading = false));
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
      textEditingController.clear();
      _description = '';
      setState(() => _loading = false);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Actualizado con exito'),
        duration: Duration(seconds: 3),
      ));
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
