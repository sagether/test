import 'package:flutter/material.dart';
import 'toast_helper.dart';

/// Toast示例组件
/// 展示如何使用不同类型的toast
class ToastExample extends StatelessWidget {
  const ToastExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Toast示例',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildToastButton(
            '显示成功提示',
            Icons.check_circle_outline,
            Colors.green,
            () => toast.showSuccess('操作成功完成！'),
          ),
          const SizedBox(height: 8),
          _buildToastButton(
            '显示错误提示',
            Icons.error_outline,
            Colors.red,
            () => toast.showError('操作失败，请重试！'),
          ),
          const SizedBox(height: 8),
          _buildToastButton(
            '显示警告提示',
            Icons.warning_amber_outlined,
            Colors.orange,
            () => toast.showWarning('请注意，这是一个警告！'),
          ),
          const SizedBox(height: 8),
          _buildToastButton(
            '显示信息提示',
            Icons.info_outline,
            Colors.blue,
            () => toast.showInfo('这是一条提示信息'),
          ),
        ],
      ),
    );
  }

  /// 构建toast按钮
  Widget _buildToastButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: color.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: color.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }
}
