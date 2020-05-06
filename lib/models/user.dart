class User {
  String _email;
  String _password;
  String _fullName;
  String _profilePictureUrl;
  String _certificateUrl;
  bool isCoach;

  User(this._email, this._password, this._fullName, this._profilePictureUrl, this._certificateUrl, this.isCoach);

  String get certificateUrl => _certificateUrl;

  @override
  String toString() {
    return 'User{_email: $_email, _password: $_password, _fullName: $_fullName, _profilePictureUrl: $_profilePictureUrl, _certificateUrl: $_certificateUrl, isCoach: $isCoach}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          _email == other._email &&
          _password == other._password &&
          _fullName == other._fullName &&
          _profilePictureUrl == other._profilePictureUrl &&
          _certificateUrl == other._certificateUrl &&
          isCoach == other.isCoach;

  @override
  int get hashCode =>
      _email.hashCode ^
      _password.hashCode ^
      _fullName.hashCode ^
      _profilePictureUrl.hashCode ^
      _certificateUrl.hashCode ^
      isCoach.hashCode;

  set certificateUrl(String value) {
    _certificateUrl = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  String get profilePictureUrl => _profilePictureUrl;

  set profilePictureUrl(String value) {
    _profilePictureUrl = value;
  }

  String get fullName => _fullName;

  set fullName(String value) {
    _fullName = value;
  }

  set password(String value) {
    _password = value;
  }
}
