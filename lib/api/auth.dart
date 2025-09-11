import 'package:dompet/configure/dio.dart';

class AuthApi {
  static Future<void> login(Map<String, String> data) {
    final options = Options(extra: {'retry': 2});
    return fetch.post('/auth/login', data: data, options: options);
  }

  static Future<void> register(Map<String, String> data) {
    return fetch.post('/auth/register', data: data);
  }
}
