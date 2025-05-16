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
    child: Stack(
      children: [
        // 内容区域
        Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: child,
        ),
        // 窗口标题栏 - 完全透明，固定高度
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: WindowTitleBarBox(
            child: Container(
              height: 32, // 标题栏固定高度
              color: Colors.transparent,
              child: Row(
                children: [
                  // 左侧空白区域，用于拖动窗口
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
        ),
      ],
    ),
  );
}
