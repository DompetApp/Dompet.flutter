import 'package:dompet/configure/dio.dart';

class AuthApi {
  static Future<void> login(Map<String, String> data) {
    return fetch.post(
      '/auth/login',
      options: Options(extra: {'retry': 2, 'cache': true}),
      queryParameters: null,
      data: data,
    );
  }

  static Future<void> register(Map<String, String> data) {
    return fetch.post(
      '/auth/register',
      options: Options(extra: {'retry': 2}),
      queryParameters: null,
      data: data,
    );
  }
}
