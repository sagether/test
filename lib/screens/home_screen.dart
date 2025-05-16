import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
