import 'package:dio/dio.dart';
import 'package:fchat/config.dart';
import 'package:fchat/storage/jwt_data.dart';
import 'package:flutter/material.dart';

class HttpService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: API,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  );
  final JwtData _jwtData = JwtData();

  init() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer ${_jwtData.jwt}'
      };
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError e, handler) {
      if (e.response!.statusCode == 401) {
        _jwtData.reLogin$.add(true);
      }
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    }));
  }

  Future<Response<T>> get<T>(String path) {
    return _dio.get(path);
  }

  Future<Response<T>> post<T>(String path, dynamic body) {
    return _dio.post(path, data: body);
  }

  static final HttpService _singleton = HttpService._internal();
  factory HttpService() {
    return _singleton;
  }
  HttpService._internal();
}
