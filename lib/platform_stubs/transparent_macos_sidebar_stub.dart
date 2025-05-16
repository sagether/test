import 'package:flutter/material.dart';

// TransparentMacOSSidebar存根
class TransparentMacOSSidebar extends StatelessWidget {
  final Widget child;

  const TransparentMacOSSidebar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 在非macOS平台上直接返回子组件
    return child;
  }
}
