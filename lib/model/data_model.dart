library data_model;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'data_model.g.dart';

abstract class DataModel {}

abstract class UserData implements Built<UserData, UserDataBuilder>, DataModel {
	String get name;

  int get heartbeat;

  factory UserData([updates(UserDataBuilder b)]) = _$UserData;
  UserData._();
}
