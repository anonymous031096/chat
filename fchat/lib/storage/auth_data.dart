import 'package:rxdart/subjects.dart';

class AuthData {
  PublishSubject name$ = PublishSubject<String>();

  static final AuthData _singleton = AuthData._internal();

  factory AuthData() {
    return _singleton;
  }

  AuthData._internal();
}
