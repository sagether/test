import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _accountName = '';
  bool _isAdmin = false;
  List<String> _userTypes = [];

  bool get isLoggedIn => _isLoggedIn;
  String get accountName => _accountName;
  bool get isAdmin => _isAdmin;
  List<String> get userTypes => _userTypes;

  Future<bool> checkLoginStatus() async {
    final response = await ApiService.checkLoginStatus();

    if (response['code'] == 0) {
      _isLoggedIn = true;
      _accountName = response['data']['accountName'];
      _isAdmin = response['data']['isAdmin'] == 1;
      _userTypes = (response['data']['userType'] as String).split(',');
      notifyListeners();
      return true;
    } else {
      _isLoggedIn = false;
      _accountName = '';
      _isAdmin = false;
      _userTypes = [];
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.clearCookie();
    _isLoggedIn = false;
    _accountName = '';
    _isAdmin = false;
    _userTypes = [];
    notifyListeners();
  }
}
