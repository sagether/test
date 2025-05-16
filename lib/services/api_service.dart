import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_service.dart';

class ApiService {
  static const String cookieKey = 'user_cookie';
  static final _dio = DioService();

  static Future<Map<String, dynamic>> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString(cookieKey);

      if (cookie == null) {
        return {'code': 1, 'msg': 'No cookie found'};
      }

      _dio.updateCookie(cookie);
      final response = await _dio.get(
        '/webhook/b7f94345-9de0-4166-8622-17ca60ab0f39',
        queryParameters: {"cookie": cookie},
      );
      return response.data;
    } catch (e) {
      return {'code': 1, 'msg': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await _dio.get(
        '/webhook/28d21f0f-bcb8-4577-b75d-42338ce77796',
        queryParameters: {'account': username, 'password': password},
      );

      if (response.data['code'] == 0) {
        final cookie = response.data['cookie'];
        if (cookie != null) {
          await saveCookie(cookie);
          _dio.updateCookie(cookie);
        }
      }

      return response.data;
    } catch (e) {
      return {'code': 1, 'msg': 'Login failed: $e'};
    }
  }

  static Future<void> saveCookie(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cookieKey, cookie);
  }

  static Future<void> clearCookie() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cookieKey);
    _dio.updateCookie(null);
  }
}
