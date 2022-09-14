import 'package:fchat/utils/http_service.dart';
import 'package:http/http.dart';

class AuthService {
  final HttpService _httpService = HttpService();

  Future<Response> signin(String username, String password) {
    return _httpService.post(
      'auth/signin',
      {'username': username, 'password': password},
    );
  }

  static final AuthService _singleton = AuthService._internal();
  factory AuthService() {
    return _singleton;
  }
  AuthService._internal();
}
