import 'package:fchat/utils/http_service.dart';

class AuthService {
  final HttpService _httpService = HttpService();

  signin(String username, String password) async {
    try {
      var response = await _httpService.post(
        'auth/signin',
        {'username': username, 'password': password},
      );
      return response.data['accessToken'];
    } catch (e) {
      return '';
    }
  }

  static final AuthService _singleton = AuthService._internal();
  factory AuthService() {
    return _singleton;
  }
  AuthService._internal();
}
