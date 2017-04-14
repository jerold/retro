// GENERATED CODE - DO NOT MODIFY BY HAND

part of data_model;

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class UserData
// **************************************************************************

class _$UserData extends UserData {
  @override
  final String name;
  @override
  final int heartbeat;

  factory _$UserData([updates(UserDataBuilder b)]) =>
      (new UserDataBuilder()..update(updates)).build();

  _$UserData._({this.name, this.heartbeat}) : super._() {
    if (name == null) throw new ArgumentError.notNull('name');
    if (heartbeat == null) throw new ArgumentError.notNull('heartbeat');
  }

  @override
  UserData rebuild(updates(UserDataBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  UserDataBuilder toBuilder() => new UserDataBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (other is! UserData) return false;
    return name == other.name && heartbeat == other.heartbeat;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), heartbeat.hashCode));
  }

  @override
  String toString() {
    return 'UserData {'
        'name=${name.toString()},\n'
        'heartbeat=${heartbeat.toString()},\n'
        '}';
  }
}

class UserDataBuilder implements Builder<UserData, UserDataBuilder> {
  UserData _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _heartbeat;
  int get heartbeat => _$this._heartbeat;
  set heartbeat(int heartbeat) => _$this._heartbeat = heartbeat;

  UserDataBuilder();

  UserDataBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _heartbeat = _$v.heartbeat;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserData other) {
    _$v = other;
  }

  @override
  void update(updates(UserDataBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  UserData build() {
    final result = _$v ?? new _$UserData._(name: name, heartbeat: heartbeat);
    replace(result);
    return result;
  }
}
