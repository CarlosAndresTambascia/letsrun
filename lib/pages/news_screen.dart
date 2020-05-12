import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/services/firestoreManagement.dart';
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
  Stream<QuerySnapshot> postsSnapshots;
  List assistants;
  String currentUserFullName = HomeScreen.currentAppUser.fullName;

  @override
  void initState() {
    postsSnapshots = FirestoreManagement().getPostsSnapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: postsSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(
              child: LoadingBouncingGrid.square(
                backgroundColor: Colors.white,
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              assistants = snapshot.data.documents[index].data['assistants'];
              String pid = snapshot.data.documents[index].data['pid'];
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
                                      snapshot.data.documents[index].data['description'],
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
                                        snapshot.data.documents[index].data['profilePicUrl'],
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
                                  SizedBox(
                                    height: 35.0,
                                    width: 100.0,
                                    child: Material(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25.0),
                                      ),
                                      elevation: 5.0,
                                      color: Colors.white,
                                      child: Container(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 25.0),
                                          child: Row(
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  LikeButton(
                                                    likeCount: assistants.length,
                                                    likeBuilder: (bool isLiked) => Icon(
                                                      Icons.directions_run,
                                                      color: isLiked || assistants.contains(currentUserFullName)
                                                          ? Colors.deepPurpleAccent
                                                          : Colors.grey,
                                                    ),
                                                    onTap: (isLiked) => _addAssistants(pid, isLiked),
                                                    //onTap: (bool isLiked) => _addAssistants(pid, isLiked),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              SizedBox(
                                height: 35.0,
                                width: 100.0,
                                child: Material(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  elevation: 5.0,
                                  color: Colors.white,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25.0),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              LikeButton(
                                                likeBuilder: (bool isLiked) => Icon(
                                                  Icons.location_on,
                                                  color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
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

  Future<bool> _addAssistants(String pid, bool val) async {
    if (!assistants.contains(currentUserFullName)) {
      assistants.add(currentUserFullName);
      FirestoreManagement().addListener(pid, assistants);
    } else {
      assistants.remove(currentUserFullName);
      FirestoreManagement().removeListener(pid, assistants);
    }
    return !val;
  }
}
