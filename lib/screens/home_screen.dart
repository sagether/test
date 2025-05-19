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

  void _onMenuItemSelected(MenuItem? item) {
    setState(() {
      _selectedItem = item;
    });
  }

  Widget _getScreen() {
    switch (_selectedItem) {
      case MenuItem.material:
        return const MaterialScreen();
      case MenuItem.task:
        return const TaskScreen();
      case MenuItem.knowledge:
        return const KnowledgeScreen();
      default:
        return const ChatScreen();
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
                child: Container(color: backgroundColor, child: _getScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
