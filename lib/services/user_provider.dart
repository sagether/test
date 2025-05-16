import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  UserProvider() {
    _initUser();
  }

  // 初始化用户状态
  Future<void> _initUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 登录
  Future<bool> login(
    String username,
    String password, {
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        username,
        password,
        rememberMe: rememberMe,
      );

      if (result.success) {
        _user = result.user;
        return true;
      } else {
        _error = result.errorMessage ?? '登录失败';
        return false;
      }
    } catch (e) {
      _error = '登录过程中出错: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 登出
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
    } catch (e) {
      _error = '登出失败: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 清除错误信息
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
