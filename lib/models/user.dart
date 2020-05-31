class User {
  String uid;
  String email;
  String fullName;
  String profilePictureUrl;
  String certificateUrl;
  bool isCoach;

  User(
    this.uid,
    this.email,
    this.fullName,
    this.profilePictureUrl,
    this.certificateUrl,
    this.isCoach,
  );

  User.fromMap(Map<String, dynamic> data)
      : uid = data['uid'],
        email = data['email'],
        fullName = data['fullName'],
        profilePictureUrl = data['profilePictureUrl'],
        certificateUrl = data['certificateUrl'],
        isCoach = data['isCoach'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'profilePictureUrl': profilePictureUrl,
      'certificateUrl': certificateUrl,
      'isCoach': isCoach,
    };
  }

  @override
  String toString() {
    return 'User{'
        'email:$email,'
        'fullName:$fullName,'
        'profilePictureUrl:$profilePictureUrl,'
        'certificateUrl:$certificateUrl,'
        'isCoach:$isCoach}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          fullName == other.fullName &&
          profilePictureUrl == other.profilePictureUrl &&
          certificateUrl == other.certificateUrl &&
          isCoach == other.isCoach;

  @override
  int get hashCode => email.hashCode ^ fullName.hashCode ^ profilePictureUrl.hashCode ^ certificateUrl.hashCode ^ isCoach.hashCode;
}
