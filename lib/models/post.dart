class Post {
  String _pid;
  double _latitudeStarting;
  double _latitudeEnd;
  double _longitudeStarting;
  double _longitudeEnd;
  String _description;
  String _email;
  String _profilePicUrl;
  DateTime dateTime;
  List<String> assistants;

  Post(this._pid, this._latitudeStarting, this._latitudeEnd, this._longitudeStarting, this._longitudeEnd,
      this._description, this._email, this._profilePicUrl, this.dateTime, this.assistants);

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  double get longitudeEnd => _longitudeEnd;

  String get profilePicUrl => _profilePicUrl;

  set profilePicUrl(String value) {
    _profilePicUrl = value;
  }

  set longitudeEnd(double value) {
    _longitudeEnd = value;
  }

  double get longitudeStarting => _longitudeStarting;

  set longitudeStarting(double value) {
    _longitudeStarting = value;
  }

  double get latitudeEnd => _latitudeEnd;

  set latitudeEnd(double value) {
    _latitudeEnd = value;
  }

  double get latitudeStarting => _latitudeStarting;

  set latitudeStarting(double value) {
    _latitudeStarting = value;
  }

  String get pid => _pid;

  set pid(String value) {
    _pid = value;
  }

  @override
  String toString() {
    return 'Post{_pid: $_pid, _latitudeStarting: $_latitudeStarting, _latitudeEnd: $_latitudeEnd, _longitudeStarting: $_longitudeStarting, _longitudeEnd: $_longitudeEnd, _description: $_description, _email: $_email, _profilePicUrl: $_profilePicUrl, dateTime: $dateTime, assistants: $assistants}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          _pid == other._pid &&
          _latitudeStarting == other._latitudeStarting &&
          _latitudeEnd == other._latitudeEnd &&
          _longitudeStarting == other._longitudeStarting &&
          _longitudeEnd == other._longitudeEnd &&
          _description == other._description &&
          _email == other._email &&
          _profilePicUrl == other._profilePicUrl &&
          dateTime == other.dateTime &&
          assistants == other.assistants;

  @override
  int get hashCode =>
      _pid.hashCode ^
      _latitudeStarting.hashCode ^
      _latitudeEnd.hashCode ^
      _longitudeStarting.hashCode ^
      _longitudeEnd.hashCode ^
      _description.hashCode ^
      _email.hashCode ^
      _profilePicUrl.hashCode ^
      dateTime.hashCode ^
      assistants.hashCode;
}
