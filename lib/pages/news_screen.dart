import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/services/userManagement.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:readmore/readmore.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final double _circleRadius = 75.0;
  final double _circleBorderWidth = 5.0;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserManagement().getAppUser(_auth.currentUser()),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingBouncingGrid.square(
              backgroundColor: Colors.white,
            ),
          );
        } else {
          HomeScreen.currentAppUser = snapshot.data;
          return ListView.builder(
            itemCount: 1,
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
                              child: SizedBox(
                                width: 350.0,
                                height: 180.0,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
                                    child: ReadMoreText(
                                      'lksajdölksajdlklksadjlksajdlksajdlksajdlksajdlksajdlksajdlksajdsalkdjsalkdjsalkdjsalkdjsalkdjsalkdjsadlkdsj,msandlsandlksajdjlksajdlksajdlksajdlksajdlksajdlksajdsalkdjalksdjlkdsalksajdsajdölksajdölsajdölsakdjsaölkdnjlkdjölkcadjsaöljdaslkjdasldjsaldjsalkdjksadsa31s',
                                      //HomeScreen.currentAppUser.email,
                                      trimLines: 5,
                                      colorClickableText: Theme.of(context).primaryColor,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '...ver mas',
                                      trimExpandedText: ' ver menos',
                                    ),
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(top: _circleRadius / 2.0),
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
      },
    );
  }
}
