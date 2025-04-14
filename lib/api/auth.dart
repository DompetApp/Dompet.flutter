import 'package:dompet/configure/dio.dart';

class AuthApi {
  static Future<void> login(Map<String, String> map) {
    return fetch.post('/auth/login', data: map);
  }

  static Future<void> register(Map<String, String> map) {
    return fetch.post('/auth/register', data: map);
  }
}
