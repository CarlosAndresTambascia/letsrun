import 'package:flutter/material.dart';
import 'package:letsrun/plugins/constants.dart';

import 'home_screen.dart';
import 'maps.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final double _circleRadius = 100.0;
  final double _circleBorderWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
                            child: Container(
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 9,
                                decoration: kDescriptionDecoration,
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
                                    onTap: () => Navigator.pushNamed(context, Maps.id),
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
                          onPressed: () {},
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
    );
  }
}
