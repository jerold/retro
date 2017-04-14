import 'package:angular2/core.dart';
import 'package:built_collection/built_collection.dart';

import 'package:retro/client/client_service_actions.dart';
import 'package:retro/client/model_reference.dart';

import 'package:retro/model/data_model.dart';

abstract class ClientService {
  ClientServiceActions get actions;

  // State

  ModelReferenceFactory<UserData> userFactory;

  ModelReference<UserData> get theUser;

  ModelReference<BuiltMap<String, String>> get users;
}