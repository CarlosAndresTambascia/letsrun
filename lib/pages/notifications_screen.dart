import 'package:animated_card/animated_card.dart';
import 'package:animated_card/animated_card_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letsrun/services/firestoreManagement.dart';
import 'package:loading_animations/loading_animations.dart';

class NotificationsScreen extends StatelessWidget {
  Stream<QuerySnapshot> notificationsSnapshots;

  @override
  void initState() {
    notificationsSnapshots = FirestoreManagement().getNotificationsSnapshots();
    print(notificationsSnapshots);
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
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
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
                      height: 100,
                      child: Padding(
                        child: Card(
                          child: Center(
                            child: Text("$index"),
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
}
