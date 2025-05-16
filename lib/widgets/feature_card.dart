import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String statistic;
  final bool isDarkMode;
  final double iconScale;
  final double height;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.statistic,
    required this.isDarkMode,
    this.iconScale = 1.0,
    this.height = 80, // 默认高度
  }) : super(key: key);

  // 根据图标名称获取对应的Material图标
  IconData _getIconData(String iconName) {
    switch (iconName.split('/').last.split('.').first) {
      case 'jj':
        return Icons.trending_up;
      case 'dc':
        return Icons.data_usage;
      case 'wa':
        return Icons.edit_note;
      case 'yj':
        return Icons.warning_amber;
      case 'bs':
        return Icons.rocket_launch;
      case 'pt':
        return Icons.devices;
      default:
        return Icons.star;
    }
  }

  // 根据图标名称获取对应的颜色 - 更新颜色以匹配背景
  Color _getIconColor(String iconName) {
    switch (iconName.split('/').last.split('.').first) {
      case 'jj':
        return const Color(0xFF64B5F6); // 更柔和的蓝色
      case 'dc':
        return const Color(0xFFB39DDB); // 更柔和的紫色
      case 'wa':
        return const Color(0xFFFFB74D); // 更柔和的橙色
      case 'yj':
        return const Color(0xFFFF8A65); // 更柔和的红色
      case 'bs':
        return const Color(0xFF81C784); // 更柔和的绿色
      case 'pt':
        return const Color(0xFF4DB6AC); // 更柔和的青色
      default:
        return const Color(0xFFFFD54F); // 更柔和的琥珀色
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDarkMode ? 0.08 : 0.12), // 降低不透明度
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // 图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconColor(icon).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Transform.scale(
              scale: iconScale,
              child: Icon(
                _getIconData(icon),
                color: _getIconColor(icon),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 20),

          // 文本内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18, // 增大字号
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15, // 增大字号
                      color: Colors.white.withOpacity(0.9),
                    ),
                    children: [
                      TextSpan(text: description),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: statistic,
                        style: const TextStyle(
                          color: Color(0xFF5CFFB1),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
