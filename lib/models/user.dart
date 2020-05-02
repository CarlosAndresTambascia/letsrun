class User {
  String _email;
  String _password;
  String _fullName;
  String _profilePictureUrl;

  User(this._email, this._password, this._fullName, this._profilePictureUrl);

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
