import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final _lista = List.generate(50, (index) => index);
  final double _circleRadius = 75.0;
  final double _circleBorderWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _lista.length,
      itemBuilder: (context, index) {
        return AnimatedCard(
          direction: AnimatedCardDirection.left,
          initDelay: Duration(milliseconds: 0),
          duration: Duration(seconds: 1),
          curve: Curves.bounceOut,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              color: Colors.white70,
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(8.0),
                height: 280.0,
                child: Column(
                  children: <Widget>[
                    Stack(alignment: Alignment.topCenter, children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: _circleRadius / 2.0),
                        child: Material(
                          child: Padding(
                            child: Text('ssssss'),
                            padding: EdgeInsets.symmetric(vertical: 75.0, horizontal: 150.0),
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
                                  'https://upload.wikimedia.org/wikipedia/commons/a/a0/Bill_Gates_2018.jpg',
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
                            Material(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                              elevation: 5.0,
                              color: Colors.white,
                              child: Padding(
                                child: LikeButton(
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.directions_run,
                                      color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                                    );
                                  },
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 3.0),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Column(
                          children: <Widget>[
                            Material(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                              elevation: 5.0,
                              color: Colors.white,
                              child: Padding(
                                child: LikeButton(
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.location_on,
                                      color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                                    );
                                  },
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 3.0),
                              ),
                            )
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
      },
    );
  }
}
