class Post {
  String _pid;
  String _coordinates;
  String _description;
  String _uid;

  Post(this._pid, this._coordinates, this._description, this._uid);

  @override
  String toString() {
    return 'Post{_pid: $_pid, _coordinates: $_coordinates, _description: $_description, _uid: $_uid}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          _pid == other._pid &&
          _coordinates == other._coordinates &&
          _description == other._description &&
          _uid == other._uid;

  @override
  int get hashCode => _pid.hashCode ^ _coordinates.hashCode ^ _description.hashCode ^ _uid.hashCode;

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get coordinates => _coordinates;

  set coordinates(String value) {
    _coordinates = value;
  }

  String get pid => _pid;

  set pid(String value) {
    _pid = value;
  }
}
