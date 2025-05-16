import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;

  AuthResult({required this.success, this.errorMessage, this.user});
}

class AuthService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _credentialsKey = 'user_credentials';

  // 内存缓存，作为SharedPreferences的备选方案
  static User? _cachedUser;
  static String? _cachedToken;
  static Map<String, String>? _cachedCredentials;

  // 模拟API调用登录
  Future<AuthResult> login(
    String username,
    String password, {
    bool rememberMe = false,
  }) async {
    try {
      // 这里应该是实际的API调用
      // 为了演示，我们使用延迟和模拟数据
      await Future.delayed(const Duration(seconds: 1));

      // 模拟验证
      if (username.isEmpty || password.isEmpty) {
        return AuthResult(success: false, errorMessage: '用户名和密码不能为空');
      }

      // 简单的模拟验证逻辑
      if (password.length < 6) {
        return AuthResult(success: false, errorMessage: '密码长度不能小于6位');
      }

      // 模拟成功登录
      final user = User(
        id: '1',
        name: username,
        email: '$username@example.com',
      );

      // 保存用户数据到本地
      await _saveUserData(user);
      await _saveToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');

      // 如果选择了"记住我"，则保存凭据
      if (rememberMe) {
        await _saveCredentials(username, password);
      } else {
        await _clearCredentials();
      }

      return AuthResult(success: true, user: user);
    } catch (e) {
      print(e.toString());
      return AuthResult(success: false, errorMessage: '登录失败: ${e.toString()}');
    }
  }

  // 获取保存的凭据
  Future<Map<String, String>?> getSavedCredentials() async {
    try {
      // 先尝试从内存缓存获取
      if (_cachedCredentials != null) {
        return _cachedCredentials;
      }

      try {
        final prefs = await SharedPreferences.getInstance();
        final credentialsStr = prefs.getString(_credentialsKey);

        if (credentialsStr == null) {
          return null;
        }

        final credentials = jsonDecode(credentialsStr) as Map<String, dynamic>;
        _cachedCredentials = {
          'username': credentials['username'] as String,
          'password': credentials['password'] as String,
        };
        return _cachedCredentials;
      } catch (e) {
        if (kDebugMode) {
          print('获取凭据失败: $e');
        }
        return _cachedCredentials;
      }
    } catch (e) {
      return null;
    }
  }

  // 保存凭据
  Future<void> _saveCredentials(String username, String password) async {
    try {
      // 保存到内存缓存
      _cachedCredentials = {'username': username, 'password': password};

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          _credentialsKey,
          jsonEncode({'username': username, 'password': password}),
        );
      } catch (e) {
        if (kDebugMode) {
          print('保存凭据到SharedPreferences失败: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('保存凭据失败: $e');
      }
    }
  }

  // 清除凭据
  Future<void> _clearCredentials() async {
    try {
      // 清除内存缓存
      _cachedCredentials = null;

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_credentialsKey);
      } catch (e) {
        if (kDebugMode) {
          print('清除凭据从SharedPreferences失败: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('清除凭据失败: $e');
      }
    }
  }

  // 获取当前登录用户
  Future<User?> getCurrentUser() async {
    try {
      // 先尝试从内存缓存获取
      if (_cachedUser != null) {
        return _cachedUser;
      }

      try {
        final prefs = await SharedPreferences.getInstance();
        final userData = prefs.getString(_userKey);

        if (userData == null) {
          return null;
        }

        final user = User.fromJson(jsonDecode(userData));
        _cachedUser = user; // 缓存用户数据
        return user;
      } catch (e) {
        if (kDebugMode) {
          print('获取用户数据失败: $e');
        }
        // 如果SharedPreferences失败，返回内存中的数据
        return _cachedUser;
      }
    } catch (e) {
      if (kDebugMode) {
        print('获取用户数据失败: $e');
      }
      return null;
    }
  }

  // 检查是否已登录
  Future<bool> isLoggedIn() async {
    try {
      // 先检查内存缓存
      if (_cachedToken != null) {
        return true;
      }

      try {
        final prefs = await SharedPreferences.getInstance();
        return prefs.containsKey(_tokenKey);
      } catch (e) {
        // 如果SharedPreferences失败，检查内存缓存
        return _cachedToken != null;
      }
    } catch (e) {
      return false;
    }
  }

  // 登出
  Future<bool> logout() async {
    try {
      // 清除内存缓存
      _cachedUser = null;
      _cachedToken = null;
      _cachedCredentials = null;

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_userKey);
        await prefs.remove(_tokenKey);
        await prefs.remove(_credentialsKey);
      } catch (e) {
        // 即使SharedPreferences失败，也认为登出成功
        if (kDebugMode) {
          print('清除存储数据失败: $e');
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // 保存用户数据
  Future<void> _saveUserData(User user) async {
    try {
      // 保存到内存缓存
      _cachedUser = user;

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(user.toJson()));
      } catch (e) {
        if (kDebugMode) {
          print('保存用户数据到SharedPreferences失败: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('保存用户数据失败: $e');
      }
    }
  }

  // 保存认证令牌
  Future<void> _saveToken(String token) async {
    try {
      // 保存到内存缓存
      _cachedToken = token;

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
      } catch (e) {
        if (kDebugMode) {
          print('保存令牌到SharedPreferences失败: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('保存令牌失败: $e');
      }
    }
  }
}
