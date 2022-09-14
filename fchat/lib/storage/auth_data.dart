class AuthData {
  String id = '';
  String name = '';
  String username = '';

  static final AuthData _singleton = AuthData._internal();
  factory AuthData() {
    return _singleton;
  }
  AuthData._internal();
}
