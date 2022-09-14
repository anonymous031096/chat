import 'dart:convert';

import 'package:fchat/storage/jwt_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpService {
  final String _domain = '127.0.0.1:3000';
  final JwtData _jwtData = JwtData();

  final Map<String, String> _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Response> get(path) {
    return http.get(
      Uri.http(_domain, path),
      headers: {..._headers, 'authorization': 'Bearer ${_jwtData.jwt}'},
    );
  }

  Future<Response> post(path, body) {
    return http.post(
      Uri.http(_domain, path),
      headers: _headers,
      body: json.encode(body),
    );
  }

  static final HttpService _singleton = HttpService._internal();
  factory HttpService() {
    return _singleton;
  }
  HttpService._internal();
}
