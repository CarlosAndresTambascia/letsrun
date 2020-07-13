import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String pid;
  double latitudeStarting;
  double latitudeEnd;
  double longitudeStarting;
  double longitudeEnd;
  String description;
  String email;
  String profilePicUrl;
  DateTime dateTime;
  List<String> assistants;
  String fullName;
  String uid;

  Post.fromData(Map<String, dynamic> data)
      : pid = data['pid'],
        latitudeStarting = data['latitudeStarting'],
        latitudeEnd = data['latitudeEnd'],
        longitudeStarting = data['longitudeStarting'],
        longitudeEnd = data['longitudeEnd'],
        description = data['description'],
        email = data['email'],
        uid = data['uid'],
        fullName = data['fullName'],
        profilePicUrl = data['profilePicUrl'],
        dateTime = (data['dateTime'] as Timestamp).toDate(),
        assistants = data['assistants'].cast<String>();

  Post(this.pid, this.latitudeStarting, this.latitudeEnd, this.longitudeStarting, this.longitudeEnd, this.description,
      this.email, this.profilePicUrl, this.dateTime, this.assistants, this.uid);

  @override
  String toString() {
    return 'Post{pid:$pid,'
        'latitudeStarting:$latitudeStarting,'
        'latitudeEnd:$latitudeEnd,'
        'longitudeStarting:$longitudeStarting,'
        'longitudeEnd:$longitudeEnd,'
        'description: $description,'
        'email:$email,'
        'uid:$uid,'
        'fullName:$fullName,'
        'profilePicUrl:$profilePicUrl,'
        'dateTime:$dateTime,'
        'assistants:$assistants}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          pid == other.pid &&
          latitudeStarting == other.latitudeStarting &&
          latitudeEnd == other.latitudeEnd &&
          longitudeStarting == other.longitudeStarting &&
          longitudeEnd == other.longitudeEnd &&
          description == other.description &&
          email == other.email &&
          uid == other.uid &&
          fullName == other.fullName &&
          profilePicUrl == other.profilePicUrl &&
          dateTime == other.dateTime &&
          assistants == other.assistants;

  @override
  int get hashCode =>
      pid.hashCode ^
      latitudeStarting.hashCode ^
      latitudeEnd.hashCode ^
      longitudeStarting.hashCode ^
      longitudeEnd.hashCode ^
      description.hashCode ^
      email.hashCode ^
      uid.hashCode ^
      fullName.hashCode ^
      profilePicUrl.hashCode ^
      dateTime.hashCode ^
      assistants.hashCode;
}
