import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_state.dart';

enum MenuItem { material, task, knowledge }

class LeftSidebar extends StatefulWidget {
  const LeftSidebar({super.key});

  @override
  State<LeftSidebar> createState() => _LeftSidebarState();
}

class _LeftSidebarState extends State<LeftSidebar> {
  MenuItem _selectedItem = MenuItem.material;

  // 定义每个菜单项的图标尺寸
  static const Map<MenuItem, Size> _iconSizes = {
    MenuItem.material: Size(16, 16),
    MenuItem.task: Size(18, 18),
    MenuItem.knowledge: Size(17, 17),
  };

  void _onMenuItemSelected(MenuItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor =
        isDarkMode
            ? Colors.black.withOpacity(0.2) // 更透明的背景，配合毛玻璃效果
            : const Color(0xFFFAFAFA);
    final dividerColor =
        isDarkMode
            ? Colors.white.withOpacity(0.1) // 更柔和的分割线
            : Colors.black.withOpacity(0.06);

    return Container(
      width: 220,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: dividerColor, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // 新会话按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                // TODO: 处理新会话
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                foregroundColor: isDarkMode ? Colors.white : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_outlined,
                    size: 18,
                    color:
                        isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '新会话',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          isDarkMode
                              ? Colors.white.withOpacity(0.9)
                              : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),

          // 菜单项
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Column(
              children: [
                _buildMenuItem(
                  imagePath:
                      _selectedItem == MenuItem.material
                          ? 'assets/images/sc_a.png'
                          : 'assets/images/sc.png',
                  label: '素材',
                  isSelected: _selectedItem == MenuItem.material,
                  isDarkMode: isDarkMode,
                  onTap: () => _onMenuItemSelected(MenuItem.material),
                  iconSize: _iconSizes[MenuItem.material]!,
                ),
                _buildMenuItem(
                  imagePath:
                      _selectedItem == MenuItem.task
                          ? 'assets/images/rw_a.png'
                          : 'assets/images/rw.png',
                  label: '任务',
                  isSelected: _selectedItem == MenuItem.task,
                  isDarkMode: isDarkMode,
                  onTap: () => _onMenuItemSelected(MenuItem.task),
                  iconSize: _iconSizes[MenuItem.task]!,
                ),
                _buildMenuItem(
                  imagePath:
                      _selectedItem == MenuItem.knowledge
                          ? 'assets/images/zsk_a.png'
                          : 'assets/images/zsk.png',
                  label: '知识库',
                  isSelected: _selectedItem == MenuItem.knowledge,
                  isDarkMode: isDarkMode,
                  onTap: () => _onMenuItemSelected(MenuItem.knowledge),
                  iconSize: _iconSizes[MenuItem.knowledge]!,
                ),
              ],
            ),
          ),

          const Spacer(),

          // 底部用户信息
          Container(
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.02),
              border: Border(top: BorderSide(color: dividerColor)),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Consumer<UserState>(
              builder: (context, userState, child) {
                return Row(
                  children: [
                    // 用户头像
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              isDarkMode
                                  ? [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ]
                                  : [Color(0xFF60A5FA), Color(0xFF3B82F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            isDarkMode
                                ? Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                )
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          userState.accountName.isNotEmpty
                              ? userState.accountName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color:
                                isDarkMode
                                    ? Colors.white.withOpacity(0.9)
                                    : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 用户名和角色
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            userState.accountName,
                            style: TextStyle(
                              color:
                                  isDarkMode
                                      ? Colors.white.withOpacity(0.9)
                                      : textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 0.5,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isDarkMode
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  isDarkMode
                                      ? Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      )
                                      : null,
                            ),
                            child: Text(
                              userState.isAdmin ? '管理员' : '普通用户',
                              style: TextStyle(
                                color:
                                    isDarkMode
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.blue[700],
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 设置按钮
                    Container(
                      width: 28,
                      height: 28,
                      child: IconButton(
                        onPressed: () {
                          // TODO: 显示设置菜单
                        },
                        icon: Icon(
                          Icons.settings_outlined,
                          color:
                              isDarkMode
                                  ? Colors.white.withOpacity(0.7)
                                  : textColor.withOpacity(0.7),
                          size: 16,
                        ),
                        padding: EdgeInsets.zero,
                        tooltip: '设置',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String imagePath,
    required String label,
    required bool isDarkMode,
    required VoidCallback onTap,
    required Size iconSize,
    bool isSelected = false,
  }) {
    final color = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor =
        isSelected
            ? (isDarkMode
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFF2563EB).withOpacity(0.1))
            : Colors.transparent;

    return Container(
      height: 36,
      margin: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              // 基础内容
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 36,
                      child: Center(
                        child: Image.asset(
                          imagePath,
                          width: iconSize.width,
                          height: iconSize.height,
                          color:
                              isSelected
                                  ? (isDarkMode
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.blue[700])
                                  : color.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        label,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? (isDarkMode
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.blue[700])
                                  : color.withOpacity(0.7),
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 选中状态边框
              if (isSelected && isDarkMode)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
