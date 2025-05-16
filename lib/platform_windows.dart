import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

// Windows平台的窗口按钮颜色配置 - 浅白色按钮
final windowButtonColors = WindowButtonColors(
  iconNormal: Colors.white70,
  mouseOver: Colors.white24,
  mouseDown: Colors.white38,
  iconMouseOver: Colors.white,
  iconMouseDown: Colors.white,
);

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: Colors.white70,
  iconMouseOver: Colors.white,
);

// Windows平台的窗口按钮
class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: windowButtonColors),
        MaximizeWindowButton(colors: windowButtonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

// Windows平台的窗口装饰
Widget buildWindowsUI(Widget child) {
  return Container(
    decoration: BoxDecoration(color: Colors.transparent),
    child: Column(
      children: [
        // 窗口标题栏 - 完全透明，高度最小化
        Stack(
          children: [
            WindowTitleBarBox(
              child: Container(
                height: 1, // 设置标题栏高度为最小值
                color: Colors.transparent,
                child: Row(
                  children: [
                    // 左侧空白区域，用于拖动窗口，隐藏标题和图标
                    Expanded(
                      child: MoveWindow(
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    // 右侧窗口按钮
                    const WindowButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
        // 内容区域
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(color: Colors.transparent),
              child: child,
            ),
          ),
        ),
      ],
    ),
  );
}
