import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsrun/models/post.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/pages/post_map.dart';
import 'package:letsrun/plugins/loading_widget.dart';
import 'package:letsrun/services/firestoreManagement.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';

import 'coach_profile_screen.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  Stream<QuerySnapshot> postsSnapshots;
  String currentUserFullName = HomeScreen.currentAppUser.fullName;

  @override
  void initState() {
    super.initState();
    postsSnapshots = FirestoreManagement().getPostsSnapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: postsSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return PostWidget(
                  post: Post.fromData(snapshot.data.documents[index].data), currentUserFullName: currentUserFullName);
            },
          );
        }
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  PostWidget({Key key, @required this.post, @required this.currentUserFullName})
      : _isSubscribed = post.assistants.contains(currentUserFullName),
        _subscribedCount = post.assistants.length,
        super(key: key);

  final Post post;
  final String currentUserFullName;
  final bool _isSubscribed;
  final int _subscribedCount;
  final double _circleRadius = 75.0;
  final double _circleBorderWidth = 5.0;
  final DateFormat date = DateFormat('dd/MM/yyyy-HH:mm');

  @override
  Widget build(BuildContext context) {
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
                  PostDateTime(date: date, post: post),
                  CustomCard(post: post, circleRadius: _circleRadius),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, CoachProfileScreen.id),
                    child: CustomCircularProfileImage(
                        circleRadius: _circleRadius, circleBorderWidth: _circleBorderWidth, post: post),
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
                                        SubscribeWidget(
                                            isSubscribed: _isSubscribed,
                                            subscribedCount: _subscribedCount,
                                            onTapped: _onSubscribe),
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
                        child: InkWell(
                          onTap: () => _goToMapWithCoordinates(context, post.latitudeStarting, post.longitudeStarting,
                              post.latitudeEnd, post.longitudeEnd),
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 35.0, top: 3.0),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
  }

  _goToMapWithCoordinates(
      context, double latitudeStarting, double longitudeStarting, double latitudeEnd, double longitudeEnd) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostMap(latitudeStarting, longitudeStarting, latitudeEnd, longitudeEnd),
      ),
    );
  }

  Future<bool> _onSubscribe() async {
    if (_isSubscribed) {
      post.assistants.remove(currentUserFullName);
      try {
        await FirestoreManagement().addListener(post.pid, post.assistants);
      } catch (e) {}
      return false;
    } else {
      post.assistants.add(currentUserFullName);
      await FirestoreManagement().addListener(post.pid, post.assistants);
      return true;
    }
  }
}

class PostDateTime extends StatelessWidget {
  const PostDateTime({
    Key key,
    @required this.date,
    @required this.post,
  }) : super(key: key);

  final DateFormat date;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 230.0, top: 20.0),
      child: Text(
        date.format(post.dateTime),
        style: TextStyle(fontSize: 11.0, color: Colors.black54),
      ),
    );
  }
}

class CustomCircularProfileImage extends StatelessWidget {
  const CustomCircularProfileImage({
    Key key,
    @required double circleRadius,
    @required double circleBorderWidth,
    @required this.post,
  })  : _circleRadius = circleRadius,
        _circleBorderWidth = circleBorderWidth,
        super(key: key);

  final double _circleRadius;
  final double _circleBorderWidth;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _circleRadius,
      height: _circleRadius,
      decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.white),
      child: Padding(
        padding: EdgeInsets.all(_circleBorderWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: FadeInImage(
            width: 100,
            height: 100,
            placeholder: AssetImage('assets/img/defaultProfile.jpg'),
            image: NetworkImage(post.profilePicUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key key,
    @required this.post,
    @required double circleRadius,
  })  : _circleRadius = circleRadius,
        super(key: key);

  final Post post;
  final double _circleRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: SizedBox(
        width: 350.0,
        height: 180.0,
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
            child: ReadMoreText(
              post.description,
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
    );
  }
}

class SubscribeWidget extends StatelessWidget {
  SubscribeWidget({Key key, this.isSubscribed: false, this.subscribedCount: 0, @required this.onTapped})
      : super(key: key);

  final bool isSubscribed;
  final int subscribedCount;
  final Future<bool> Function() onTapped;

  Future<bool> _onTapped(bool isLiked) async {
    return onTapped();
  }

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      likeCount: subscribedCount,
      likeBuilder: (bool isLiked) => Icon(
        Icons.directions_run,
        color: isSubscribed ? Colors.deepPurpleAccent : Colors.grey,
      ),
      onTap: _onTapped,
    );
  }
}
