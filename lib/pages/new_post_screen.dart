import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsrun/models/post.dart';
import 'package:letsrun/plugins/constants.dart';
import 'package:letsrun/services/firestoreManagement.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uuid/uuid.dart';

import 'home_screen.dart';
import 'maps.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final double _circleRadius = 100.0;
  final double _circleBorderWidth = 5.0;
  Set<Marker> _markers = {};
  Post _post = new Post('', 0, 0, 0, 0, '', '', '', DateTime.now(), []);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _loading = false;
  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: EdgeInsets.all(8.0),
              height: 280.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(alignment: Alignment.topCenter, children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: _circleRadius / 2.0),
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
                                    onChanged: (value) => _post.description = value,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 3.0, left: 50.0, right: 50.0),
                              child: Material(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                                elevation: 5.0,
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () => print('donde fue?'),
                                  child: Padding(
                                    child: GestureDetector(
                                      onTap: () => pickMapsData(context),
                                      child: Row(
                                        children: <Widget>[
                                          Text('Indicanos la ruta'),
                                          Icon(
                                            Icons.map,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 5.0),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 300.0),
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
                    Container(
                      width: _circleRadius,
                      height: _circleRadius,
                      decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.all(_circleBorderWidth),
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                HomeScreen.currentAppUser.profilePictureUrl,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: _postIt,
                            minWidth: 20,
                            height: 50,
                            child: Text(
                              'Publicar'.toUpperCase(),
                              style: TextStyle(color: Colors.black),
                            ),
                            color: Colors.white,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      inAsyncCall: _loading,
    );
  }

  pickMapsData(BuildContext context) async {
    _markers = await Navigator.push(context, MaterialPageRoute(builder: (context) => Maps()));
    if (_markers.isNotEmpty) {
      var firstMarker = _markers.firstWhere((marker) => marker.markerId.value == Maps.startingPositionMsg);
      var secondMarker = _markers.firstWhere((marker) => marker.markerId.value == Maps.finalPositionMsg);
      _post.latitudeStarting = firstMarker.position.latitude;
      _post.longitudeStarting = firstMarker.position.longitude;
      _post.latitudeEnd = secondMarker.position.latitude;
      _post.longitudeEnd = secondMarker.position.longitude;
    }
  }

  _postIt() {
    _post.email = HomeScreen.currentAppUser.email;
    _post.profilePicUrl = HomeScreen.currentAppUser.profilePictureUrl;
    _post.dateTime = DateTime.now();
    _post.assistants = [];
    _post.pid = uuid.v1();
    if (_validatePostFields()) {
      setState(() => _loading = true);
      FirestoreManagement()
          .addPost(context, _post)
          .catchError(() => showExceptionError(context, 'Hubo un problema al crear el post, intente mas tarde.'));
      setState(() => _loading = false);
    } else {
      showExceptionError(context, null);
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showExceptionError(BuildContext context, String errorMsg) {
    final defaultMsg = 'Por favor ingrese todos los datos';
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(errorMsg == null ? defaultMsg : errorMsg),
      duration: Duration(seconds: 3),
    ));
  }

  bool _validatePostFields() {
    if (_post.latitudeStarting == 0 ||
        _post.profilePicUrl == '' ||
        _post.latitudeEnd == 0 ||
        _post.longitudeStarting == 0 ||
        _post.description == '' ||
        _post.email == '' ||
        _post.longitudeEnd == 0) {
      return false;
    }
    return true;
  }
}
