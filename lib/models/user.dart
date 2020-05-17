class User {
  String email;
  String password;
  String fullName;
  String profilePictureUrl;
  String certificateUrl;
  bool isCoach;

  User(this.email, this.password, this.fullName, this.profilePictureUrl, this.certificateUrl, this.isCoach);

  @override
  String toString() {
    return 'User{_email: $email, _password: $password, _fullName: $fullName, _profilePictureUrl: $profilePictureUrl, _certificateUrl: $certificateUrl, isCoach: $isCoach}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          fullName == other.fullName &&
          profilePictureUrl == other.profilePictureUrl &&
          certificateUrl == other.certificateUrl &&
          isCoach == other.isCoach;

  @override
  int get hashCode =>
      email.hashCode ^
      password.hashCode ^
      fullName.hashCode ^
      profilePictureUrl.hashCode ^
      certificateUrl.hashCode ^
      isCoach.hashCode;
}
