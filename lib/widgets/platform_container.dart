import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:macos_window_utils/widgets/transparent_macos_sidebar.dart'
    if (dart.library.js) '../platform_stubs/transparent_macos_sidebar_stub.dart';
import '../platform_windows.dart'
    if (dart.library.js) '../platform_stubs/platform_windows_stub.dart';

/// 平台适配容器，根据不同平台提供适当的UI包装
///
/// 在macOS上使用TransparentMacOSSidebar
/// 在Windows上使用自定义Windows UI
/// 在其他平台上使用标准容器
class PlatformContainer extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 是否使用透明背景（仅适用于非macOS和非Windows平台）
  final bool useTransparentBackground;

  /// 背景颜色（仅适用于非macOS和非Windows平台）
  final Color? backgroundColor;

  const PlatformContainer({
    Key? key,
    required this.child,
    this.useTransparentBackground = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPlatformSpecificUI(context);
  }

  /// 构建平台特定的UI
  Widget _buildPlatformSpecificUI(BuildContext context) {
    // Windows平台特定UI
    if (!kIsWeb && Platform.isWindows) {
      return buildWindowsUI(child);
    }
    // 仅在macOS平台使用TransparentMacOSSidebar
    else if (!kIsWeb && Platform.isMacOS) {
      return TransparentMacOSSidebar(child: child);
    } else {
      // 其他平台使用标准UI
      return _buildStandardUI(context);
    }
  }

  /// 标准UI (用于非macOS平台)
  Widget _buildStandardUI(BuildContext context) {
    if (!kIsWeb && Platform.isWindows) {
      // Windows平台使用透明背景
      return WindowBorder(color: Colors.transparent, width: 1, child: child);
    } else {
      // 其他平台使用常规背景
      return Container(
        color:
            useTransparentBackground
                ? Colors.transparent
                : (backgroundColor ?? Theme.of(context).colorScheme.surface),
        child: child,
      );
    }
  }
}
