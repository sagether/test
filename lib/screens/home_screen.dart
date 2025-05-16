import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:tains_flutter/widgets/platform_container.dart';
import '../models/user_state.dart';
import '../widgets/left_sidebar.dart';
import '../platform_windows.dart'
    if (dart.library.js) '../platform_stubs/platform_windows_stub.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

    return PlatformContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              // 左侧边栏
              const LeftSidebar(),

              // 主内容区域
              Expanded(
                child: Container(
                  color: backgroundColor,
                  child: Center(
                    child: Consumer<UserState>(
                      builder: (context, userState, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '欢迎回来，${userState.accountName}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '管理员权限: ${userState.isAdmin ? "是" : "否"}',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '用户类型: ${userState.userTypes.join(", ")}',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
