import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _hasMessages = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      children: [
        // 聊天展示区域
        Expanded(
          child: Container(
            color: backgroundColor,
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
            child: _hasMessages ? _buildChatMessages() : _buildWelcomeMessage(),
          ),
        ),

        // 输入区域
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          color: backgroundColor,
          child: Container(
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? Colors.white.withOpacity(0.03)
                      : Colors.black.withOpacity(0.02),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 问题输入框
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: '问我任何问题',
                      hintStyle: TextStyle(
                        color: textColor.withOpacity(0.3),
                        fontSize: 15,
                        height: 1.5,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    maxLines: 6,
                    minLines: 1,
                  ),
                ),

                // 底部工具栏
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color:
                            isDarkMode
                                ? Colors.white.withOpacity(0.06)
                                : Colors.black.withOpacity(0.03),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // 联网搜索按钮
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.public,
                          color: textColor.withOpacity(0.4),
                          size: 20,
                        ),
                        tooltip: '智能体',
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),

                      const Spacer(),

                      // 发送按钮
                      IconButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            setState(() {
                              _hasMessages = true;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_return,
                          color: textColor.withOpacity(0.4),
                          size: 20,
                        ),
                        tooltip: '发送',
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo和欢迎语
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hi, 我是 Anakin',
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '有什么可以帮你？',
          style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildChatMessages() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      children: [
        // 用户消息
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '我是 Anakin Chat 机器人，请问今天什么可以帮助你呢？',
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // AI回复
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'The number provided is 123213. It\'s a six-digit number. It\'s not a palindrome (reads the same backwards',
                      style: TextStyle(color: textColor, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '你可能想问',
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSuggestionChip('Is it divisible by 9?'),
                      _buildSuggestionChip('What\'s its prime factors?'),
                      _buildSuggestionChip('What\'s the next number?'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.02),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '123213',
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        _controller.text = text;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.white24 : Colors.black12,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12),
        ),
      ),
    );
  }
}
