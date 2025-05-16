import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: [
          Consumer<UserState>(
            builder: (context, userState, child) {
              return TextButton(
                onPressed: () async {
                  await userState.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                child: Text(
                  '退出登录 (${userState.accountName})',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<UserState>(
          builder: (context, userState, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('欢迎回来，${userState.accountName}'),
                const SizedBox(height: 10),
                Text('管理员权限: ${userState.isAdmin ? "是" : "否"}'),
                const SizedBox(height: 10),
                Text('用户类型: ${userState.userTypes.join(", ")}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
