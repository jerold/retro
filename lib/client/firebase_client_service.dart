import 'dart:async';
import 'dart:convert';

import 'package:angular2/core.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:meta/meta.dart';

import 'package:retro/client/client_service_actions.dart';
import 'package:retro/client/client_service.dart';
import 'package:retro/client/firebase_model_reference.dart';

import 'package:retro/model/data_model.dart';
import 'package:retro/model/serializers.dart';

const String USERS_KEY = "users";
const String NAME_KEY = "name";
const String HEARTBEAT_TIME_KEY = "heartbeat-time";

Built fromEvent(firebase.QueryEvent event) => fromVal(event.snapshot.val());

Built fromVal(String val) => serializers.deserialize(JSON.decode(val));

String fromBuilt(Built data) => JSON.encode(serializers.serialize(data));

@Injectable()
class FirebaseClient implements ClientService {
  final ClientServiceActions actions = new ClientServiceActions();

  firebase.GoogleAuthProvider _fbGoogleAuthProvider;
  firebase.Auth _fbAuth;
  firebase.Database _fbDatabase;

  // User References

  @override
  @protected
  SingleModelReferenceFactory<UserData> userFactory;

  @override
  @protected
  SingleModelReference<UserData> theUser;

  @override
  @protected
  MappedModelReference<BuiltMap<String, String>> users;

  Timer _heartbeatTimer;
  bool _recentActivity = true;

  // Streams

  FirebaseClient() {
    userFactory = new SingleModelReferenceFactory<UserData>(_userRef, userDataFromEvent);
    theUser = userFactory.newModelReference();

    // TODO: this makes a huge ref of all users just to get the uids...
    users = new MappedModelReference<BuiltMap<String, String>>(_usersRef, _keyFromEvent, new BuiltMap<String, String>());
  }

  Future init() async {
    actions
      ..signIn.listen(_handleSignIn)
      ..signOut.listen(_handleSignOut);

    firebase.initializeApp(
      apiKey: "--apiKey--",
      authDomain: "--authDomain--",
      databaseURL: "--databaseURL--",
      storageBucket: "--storageBucket--",
    );

    _fbGoogleAuthProvider = new firebase.GoogleAuthProvider();
    _fbAuth = firebase.auth();
    _fbAuth.onAuthStateChanged.listen(_authChanged);

    _fbDatabase = firebase.database();
  }

  // Reference builders

  firebase.DatabaseReference _ref(String entityType, String uid, [String childPath]) {
    String options = childPath != null ? "/${childPath}" : "";
    return _fbDatabase.ref("$entityType/$uid$options");
  }

  firebase.DatabaseReference _userRef(String uid, [String childPath]) => _ref(USERS_KEY, uid);

  firebase.DatabaseReference _usersRef([_]) => _fbDatabase.ref(USERS_KEY);

  // Model from Event Snapshot Helpers

  String _keyFromEvent(firebase.QueryEvent event) => event.snapshot.key;

  // Setters

  Future openTheUser(String uid) async {
    theUser.open(uid);
  }

  Future closeTheUser([_]) async {
    if (theUser.isOpen()) {
      theUser.close();
    }
  }

  // Action Handlers

  Future _handleSignIn([_]) async {
    try {
      await _fbAuth.signInWithRedirect(_fbGoogleAuthProvider);
    } catch (error) {
      try {
        await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
      } catch (error) {}
    }
  }

  Future _handleSignOut([_]) async {
    _fbAuth.signOut();
  }

  // Time Utility functions

  int _dateTimeToEpoch([DateTime dateTime]) {
    dateTime = dateTime ?? new DateTime.now();
    return dateTime.millisecondsSinceEpoch;
  }

  DateTime _epochToDateTime([int epoch]) {
    if (epoch != null) return new DateTime.fromMillisecondsSinceEpoch(epoch);
    return new DateTime.now();
  }

  // Lifecycle

  void _authChanged(firebase.AuthEvent authData) {
    if (authData.user != null) {
      openTheUser(authData.user.uid);
      _userRef(authData.user.uid).once('value').then((firebase.QueryEvent event) {
        _userExistsCallback(authData.user, event);
      });
    } else {
      closeTheUser();
      _stopHeartbeat();
    }
  }

  _startHeartbeat() {
    if (_heartbeatTimer == null) {
      _heartbeatTimer = new Timer.periodic(const Duration(seconds: 10), _doHeartbeat);
    }
    _doHeartbeat();
  }

  _doHeartbeat([_]) {
    if (_recentActivity) {
      if (theUser.isOpen()) {
        print("Ping: ${_epochToDateTime()}");
        _userRef(theUser.uid()).update({HEARTBEAT_TIME_KEY: _dateTimeToEpoch()});
      }
      _recentActivity = false;
    }
  }

  _stopHeartbeat() {
    if (_heartbeatTimer != null) _heartbeatTimer.cancel();
    _heartbeatTimer = null;
    _recentActivity = false;
  }

  void _userExistsCallback(firebase.User user, firebase.QueryEvent event) {
    if (event.snapshot.val() == null) {
      _userRef(user.uid).set({
        NAME_KEY: _displayName(user.displayName),
      });
    }
    _startHeartbeat();
  }

  String _displayName(String name) {
    List<String> splitName = name.split(" ");
    if (splitName.length == 2) return "${splitName[0]} ${splitName[1].substring(0,1)}.";
    return name;
  }
}

UserData userDataFromEvent(firebase.QueryEvent event) {
  final data = event.snapshot.val();
  return new UserData((UserDataBuilder builder) {
    builder
      ..name = data[NAME_KEY]
      ..heartbeat = data[HEARTBEAT_TIME_KEY];
    return builder;
  });
}
