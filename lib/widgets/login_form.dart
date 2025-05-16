import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../utils/route_manager.dart';
import '../services/auth_service.dart';
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
  bool _rememberMe = false;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);

    return MouseRegion(
      opaque: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 用户名输入
          _buildInputLabel('账号', isDarkMode),
          _buildUsernameField(isDarkMode),
          const SizedBox(height: 24),

          // 密码输入
          _buildInputLabel('密码', isDarkMode),
          _buildPasswordField(isDarkMode, userProvider),
          const SizedBox(height: 16),

          const SizedBox(height: 24),

          // 登录按钮
          _buildLoginButton(userProvider),

          // 第三方登录选项
          const SizedBox(height: 30),
          _buildDividerWithText('其他登录方式', isDarkMode),
          const SizedBox(height: 20),
          _buildSocialLoginButtons(isDarkMode),
        ],
      ),
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
    final hintColor = isDarkMode ? Colors.white38 : Colors.black38;

    return TextFormField(
      controller: _usernameController,
      focusNode: _usernameFocusNode,
      keyboardType: TextInputType.text,
      style: TextStyle(color: textColor, fontSize: 15),
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

  Widget _buildPasswordField(bool isDarkMode, UserProvider userProvider) {
    final borderColor = isDarkMode ? Colors.white24 : Colors.black12;
    final focusedBorderColor =
        isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFF2A2A2A);
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final hintColor = isDarkMode ? Colors.white38 : Colors.black38;

    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: _obscurePassword,
      style: TextStyle(color: textColor, fontSize: 15),
      keyboardType: TextInputType.text,
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

  Widget _buildLoginButton(UserProvider userProvider) {
    // 使用更深、更有质感的黑色作为按钮背景
    final buttonColor = const Color(0xFF1E1E1E);

    return ElevatedButton(
      onPressed:
          userProvider.isLoading ? null : () => _handleLogin(userProvider),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        // 添加微弱的阴影以增加质感
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.3),
        // 确保禁用状态下颜色不变
        disabledBackgroundColor: buttonColor,
        disabledForegroundColor: Colors.white,
      ),
      child: SizedBox(
        height: 24, // 固定高度
        child: Center(
          child:
              userProvider.isLoading
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.5,
                    ),
                  )
                  : const Text(
                    '登 录',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
        ),
      ),
    );
  }

  Widget _buildDividerWithText(String text, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDarkMode ? Colors.white24 : Colors.black12,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white54 : Colors.black45,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDarkMode ? Colors.white24 : Colors.black12,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialLoginButton(Icons.fingerprint, isDarkMode),
        const SizedBox(width: 24),
        _buildSocialLoginButton(Icons.qr_code, isDarkMode),
        const SizedBox(width: 24),
        _buildSocialLoginButton(Icons.phone_android, isDarkMode),
      ],
    );
  }

  Widget _buildSocialLoginButton(IconData icon, bool isDarkMode) {
    return InkWell(
      onTap: () {
        // 第三方登录逻辑
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDarkMode ? Colors.white24 : Colors.black12,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isDarkMode ? Colors.white70 : Colors.black54,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildRememberMeOption(bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
            activeColor: const Color(0xFF4568DC),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _rememberMe = !_rememberMe;
            });
          },
          child: Text('记住我', style: TextStyle(fontSize: 14, color: textColor)),
        ),
      ],
    );
  }

  void _handleLogin(UserProvider userProvider) async {
    // 清除之前的错误
    userProvider.clearError();

    // 获取输入值
    final username = _usernameController.text;
    final password = _passwordController.text;

    // 简单验证
    if (username.isEmpty) {
      _showSnackBar('请输入账号');
      return;
    }

    if (password.isEmpty) {
      _showSnackBar('请输入密码');
      return;
    }

    if (password.length < 6) {
      _showSnackBar('密码长度不能小于6位');
      return;
    }

    // 调用登录方法，传递记住我选项
    final success = await userProvider.login(
      username,
      password,
      rememberMe: _rememberMe,
    );

    if (success && mounted) {
      // 登录成功，导航到主页
      Navigator.of(context).pushReplacementNamed(RouteManager.homeRoute);
    }
  }

  // 安全地显示提示消息
  void _showSnackBar(String message) {
    if (!mounted) return;

    // 使用toast工具类显示错误提示
    toast.showError(message);
  }
}
