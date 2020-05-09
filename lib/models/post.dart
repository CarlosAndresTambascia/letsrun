class Post {
  String _pid;
  double _latitudeStarting;
  double _latitudeEnd;
  double _longitudeStarting;
  double _longitudeEnd;
  String _description;
  String _email;

  Post(this._pid, this._latitudeStarting, this._latitudeEnd, this._longitudeStarting, this._longitudeEnd,
      this._description, this._email);

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  double get longitudeEnd => _longitudeEnd;

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
          _email == other._email;

  @override
  int get hashCode =>
      _pid.hashCode ^
      _latitudeStarting.hashCode ^
      _latitudeEnd.hashCode ^
      _longitudeStarting.hashCode ^
      _longitudeEnd.hashCode ^
      _description.hashCode ^
      _email.hashCode;

  @override
  String toString() {
    return 'Post{_pid: $_pid, _latitudeStarting: $_latitudeStarting, _latitudeEnd: $_latitudeEnd, _longitudeStarting: $_longitudeStarting, _longitudeEnd: $_longitudeEnd, _description: $_description, _email: $_email}';
  }
}
