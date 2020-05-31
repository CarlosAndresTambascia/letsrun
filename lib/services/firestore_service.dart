import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letsrun/models/post.dart';
import 'package:letsrun/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference = Firestore.instance.collection('users');
  final CollectionReference _postsCollectionReference = Firestore.instance.collection('posts');
  final StreamController<List<Post>> _postsController = StreamController<List<Post>>.broadcast();

  Future createUser(User user) async {
    await _usersCollectionReference.document(user.uid).setData(user.toJson());
  }

  Future<User> getUser(String userId) async {
    var userData = await _usersCollectionReference.document(userId).get();
    return User.fromMap(userData.data);
  }

  Future createPost(Post post) async {
    final DocumentReference documentReference = await _postsCollectionReference.add(post.toJson());
    await _postsCollectionReference.document(documentReference.documentID).updateData({'pid': documentReference.documentID});
  }

  Future updatePostAssistants(String pid, List assistants) async {
    await _postsCollectionReference.document(pid).updateData({'assistants': assistants});
  }

  Stream<QuerySnapshot> getPostsSnapshots() {
    return _postsCollectionReference.orderBy("dateTime", descending: true).snapshots();
  }

  Stream<QuerySnapshot> getCoachNotificationsSnapshots(User currentAppUser) {
    return _postsCollectionReference.where('email', isEqualTo: currentAppUser.email).snapshots();
  }

  Stream<QuerySnapshot> getNonCoachNotificationsSnapshots() {
    return _postsCollectionReference.snapshots();
  }
}
