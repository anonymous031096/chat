import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/subjects.dart';

class JwtData {
  var reLogin$ = PublishSubject();
  String id = '';
  String name = '';
  String username = '';
  String jwt = '';

  setData(jwt) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
    this.jwt = jwt;
    id = decodedToken['id'];
    name = decodedToken['name'];
    username = decodedToken['username'];
  }

  static final JwtData _singleton = JwtData._internal();
  factory JwtData() {
    return _singleton;
  }
  JwtData._internal();
}
