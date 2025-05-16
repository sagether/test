import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Toast工具类，封装toastification库
/// 提供全局访问的toast提示功能
class ToastHelper {
  /// 全局单例实例
  static final ToastHelper _instance = ToastHelper._internal();

  /// 获取单例实例
  static ToastHelper get instance => _instance;

  /// 私有构造函数
  ToastHelper._internal();

  /// 全局导航键，用于在没有context的情况下显示toast
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 显示成功提示
  void showSuccess(String message, {Duration? duration}) {
    _show(
      title: '成功',
      description: message,
      type: ToastificationType.success,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// 显示错误提示
  void showError(String message, {Duration? duration}) {
    _show(
      title: '错误',
      description: message,
      type: ToastificationType.error,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// 显示警告提示
  void showWarning(String message, {Duration? duration}) {
    _show(
      title: '警告',
      description: message,
      type: ToastificationType.warning,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// 显示信息提示
  void showInfo(String message, {Duration? duration}) {
    _show(
      title: '提示',
      description: message,
      type: ToastificationType.info,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// 内部显示toast的方法
  void _show({
    required String title,
    required String description,
    required ToastificationType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlayState = navigatorKey.currentState?.overlay;

    if (overlayState == null) {
      debugPrint('无法显示toast: overlay为空');
      return;
    }

    toastification.show(
      overlayState: overlayState,
      // title: Text(
      //   title,
      //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      // ),
      description: Text(description, style: const TextStyle(fontSize: 13)),
      type: type,
      style: ToastificationStyle.fillColored,
      showIcon: false,
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      showProgressBar: false,
      dragToClose: true,
    );
  }
}

/// 全局访问点
final toast = ToastHelper.instance;
