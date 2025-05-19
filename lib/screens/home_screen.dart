import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:tains_flutter/widgets/platform_container.dart';
import '../models/user_state.dart';
import '../widgets/left_sidebar.dart';
import '../platform_windows.dart'
    if (dart.library.js) '../platform_stubs/platform_windows_stub.dart';
import 'chat_screen.dart';
import 'material_screen.dart';
import 'task_screen.dart';
import 'knowledge_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MenuItem? _selectedItem;
  final _chatScreen = ChatScreen(key: GlobalKey());
  final _materialScreen = MaterialScreen();
  final _taskScreen = TaskScreen();
  final _knowledgeScreen = KnowledgeScreen();

  void _onMenuItemSelected(MenuItem? item) {
    setState(() {
      // 如果点击已选中的菜单项，则取消选中
      if (_selectedItem == item) {
        _selectedItem = null;
      } else {
        _selectedItem = item;
      }
    });
  }

  int _getScreenIndex() {
    switch (_selectedItem) {
      case MenuItem.material:
        return 1;
      case MenuItem.task:
        return 2;
      case MenuItem.knowledge:
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

    return PlatformContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              // 左侧边栏
              LeftSidebar(
                selectedItem: _selectedItem,
                onMenuItemSelected: _onMenuItemSelected,
              ),

              // 主内容区域
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: IndexedStack(
                    index: _getScreenIndex(),
                    children: [
                      _chatScreen,
                      _materialScreen,
                      _taskScreen,
                      _knowledgeScreen,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
