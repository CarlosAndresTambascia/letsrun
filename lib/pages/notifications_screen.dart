import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/services/firestoreManagement.dart';
import 'package:loading_animations/loading_animations.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Stream<QuerySnapshot> notificationsSnapshots;
  List<String> assistantsNames = new List();

  @override
  void initState() {
    notificationsSnapshots = FirestoreManagement().getNotificationsSnapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: notificationsSnapshots,
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
          _createAssistantsList(snapshot);
          return ListView.builder(
            itemCount: assistantsNames.length,
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
                                    Text(assistantsNames[index] + ' asistira'),
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
    List<List> assistants = new List();

    snapshot.data.documents.forEach((el) {
      assistants.add(el.data['assistants']);
    });
    assistants.forEach((el) {
      el.forEach((userName) {
        assistantsNames.add(userName);
      });
    });
  }
}
