import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/pages/home_screen.dart';
import 'package:letsrun/plugins/loading_widget.dart';
import 'package:letsrun/services/firestoreManagement.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Stream<QuerySnapshot> notificationsSnapshots;
  List<String> namesList = new List();
  final bool isCoach = HomeScreen.currentAppUser.isCoach;

  @override
  void initState() {
    super.initState();
    namesList = new List();
    notificationsSnapshots = isCoach
        ? FirestoreManagement().getCoachNotificationsSnapshots()
        : FirestoreManagement().getNonCoachNotificationsSnapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: notificationsSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        } else {
          if (isCoach) {
            _createAssistantsList(snapshot);
          } else {
            _createPostsUerNames(snapshot);
          }
          return ListView.builder(
            itemCount: namesList.length,
            itemBuilder: (context, index) {
              return AnimatedCard(
                direction: AnimatedCardDirection.top,
                initDelay: Duration(milliseconds: 0),
                duration: Duration(seconds: 0),
                curve: Curves.bounceOut,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListTile(
                    title: Container(
                      height: 70,
                      child: Padding(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.directions_run,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  children: <Widget>[
                                    isCoach
                                        ? RichText(
                                            text: TextSpan(
                                              text: namesList[index],
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                              children: [
                                                TextSpan(
                                                    text: ' asistira.', style: TextStyle(fontWeight: FontWeight.normal))
                                              ],
                                            ),
                                          )
                                        : RichText(
                                            text: TextSpan(
                                              text: namesList[index],
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                              children: [
                                                TextSpan(
                                                    text: ' hizo una nueva publicacion.',
                                                    style: TextStyle(fontWeight: FontWeight.normal))
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(2.5),
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

  _createAssistantsList(AsyncSnapshot<QuerySnapshot> snapshot) {
    namesList = new List();
    List<List> assistants = new List();
    snapshot.data.documents.forEach((post) {
      assistants.add(post.data['assistants']);
    });
    assistants.forEach((user) {
      user.forEach((userName) {
        namesList.add(userName);
      });
    });
  }

  _createPostsUerNames(AsyncSnapshot<QuerySnapshot> snapshot) {
    namesList = List();
    snapshot.data.documents.forEach((post) {
      namesList.add(post.data['fullName']);
    });
  }
}
