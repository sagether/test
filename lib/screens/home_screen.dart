import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tains_flutter/widgets/platform_container.dart';
import '../models/user_state.dart';
import '../widgets/left_sidebar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PlatformContainer(
      child: Scaffold(
        body: Row(
          children: [
            // 左侧边栏
            const LeftSidebar(),

            // 主内容区域
            Expanded(
              child: Container(
                color: Colors.black,
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
                                  isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '用户类型: ${userState.userTypes.join(", ")}',
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black87,
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
    );
  }
}
