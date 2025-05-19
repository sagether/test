import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_state.dart';
import '../services/api_service.dart';
import '../utils/toast_helper.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      toast.showError('请输入账号和密码');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.login(username, password);

      if (response['code'] == 0) {
        if (mounted) {
          final userState = Provider.of<UserState>(context, listen: false);
          final success = await userState.checkLoginStatus();

          if (success && mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
            return;
          }
        }

        toast.showError('登录失败：无法获取用户信息');
      } else {
        toast.showError(response['msg'] ?? '登录失败');
      }
    } catch (e) {
      toast.showError('登录失败：$e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 用户名输入
        _buildInputLabel('账号', isDarkMode),
        _buildUsernameField(isDarkMode),
        const SizedBox(height: 24),

        // 密码输入
        _buildInputLabel('密码', isDarkMode),
        _buildPasswordField(isDarkMode),
        const SizedBox(height: 24),

        // 登录按钮
        ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child:
              _isLoading
                  ? const SizedBox(
                    height: 23,
                    width: 23,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Text(
                    '登录',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label, bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildUsernameField(bool isDarkMode) {
    final borderColor = isDarkMode ? Colors.white24 : Colors.black12;
    final focusedBorderColor =
        isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFF2A2A2A);
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return TextFormField(
      controller: _usernameController,
      focusNode: _usernameFocusNode,
      keyboardType: TextInputType.text,
      style: TextStyle(color: textColor, fontSize: 15),
      cursorColor: isDarkMode ? Colors.white70 : Colors.black87,
      cursorHeight: 16,
      cursorWidth: 1.5,
      decoration: InputDecoration(
        hintText: '输入账号',
        prefixIcon: Icon(
          Icons.person_outline,
          color: isDarkMode ? Colors.white54 : Colors.black54,
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
        filled: true,
        fillColor:
            isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.02),
      ),
    );
  }

  Widget _buildPasswordField(bool isDarkMode) {
    final borderColor = isDarkMode ? Colors.white24 : Colors.black12;
    final focusedBorderColor =
        isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFF2A2A2A);
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: _obscurePassword,
      style: TextStyle(color: textColor, fontSize: 15),
      cursorColor: isDarkMode ? Colors.white70 : Colors.black87,
      cursorHeight: 16,
      cursorWidth: 1.5,
      decoration: InputDecoration(
        hintText: '输入密码',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: isDarkMode ? Colors.white54 : Colors.black54,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: isDarkMode ? Colors.white54 : Colors.black54,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
        filled: true,
        fillColor:
            isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.02),
      ),
    );
  }
}
