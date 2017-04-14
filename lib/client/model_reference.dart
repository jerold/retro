import 'dart:async';

import 'package:meta/meta.dart';

class ModelReference<T> {
  String _uid;
  String uid() => _uid;

  T _value;
  T value() => _value;

  bool _isClosed = true;
  bool isClosed() => _isClosed;

  bool isOpen() => !_isClosed;

  final StreamController<T> _didChange = new StreamController<T>.broadcast();
  Stream<T> get didChange => _didChange.stream;

  final Completer _wasDestroyed = new Completer();
  Future get wasDestroyed => _wasDestroyed.future;

  // Provide state for the Reference and its changes.
  @mustCallSuper
  void open(String uid) {
    if (isOpen()) close();
    _uid = uid;
    _isClosed = false;
    onOpen(uid);
  }

  @mustCallSuper
  void changevalue(T newValue) {
    _value = newValue;
    _didChange.add(_value);
  }

  // Stop providing state for a given reference.
  @mustCallSuper
  void close() {
    _value = null;
    _uid = null;
    _isClosed = true;
    onClose();
  }

  // Close all streams and subs.
  @mustCallSuper
  void destroy() {
    close();
    _didChange.close();
    _wasDestroyed.complete();
  }

  @protected
  void onOpen(String uid) {}

  @protected
  void onClose() {}

  @protected
  void onDestroy() {}
}

abstract class ModelReferenceFactory<T> {
  ModelReference<T> newModelReference();
}
