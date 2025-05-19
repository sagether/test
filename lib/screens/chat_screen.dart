import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasMessages = false;
  bool _isAiEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
    // 确保在下一帧渲染完成后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool get _hasValidContent {
    final text = _controller.text;
    // 检查是否只包含空白字符（空格、换行等）
    return text.trim().isNotEmpty;
  }

  void _handleSubmit() {
    if (_hasValidContent) {
      setState(() {
        _hasMessages = true;
      });
      // 重置输入框
      _controller.clear();
      // TODO: 处理发送逻辑
    }
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
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  child: Focus(
                    onKeyEvent: (node, event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.enter) {
                        if (HardwareKeyboard.instance.isShiftPressed) {
                          // Shift + Enter，插入换行符
                          final text = _controller.text;
                          final selection = _controller.selection;
                          final newText = text.replaceRange(
                            selection.start,
                            selection.end,
                            '\n',
                          );
                          _controller.value = TextEditingValue(
                            text: newText,
                            selection: TextSelection.collapsed(
                              offset: selection.start + 1,
                            ),
                          );
                          return KeyEventResult.handled;
                        } else {
                          // 只按Enter，发送消息
                          _handleSubmit();
                          return KeyEventResult.handled;
                        }
                      }
                      return KeyEventResult.ignored;
                    },
                    child: TextField(
                      controller: _controller,
                      scrollController: _scrollController,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        height: 1.5,
                      ),
                      cursorColor: isDarkMode ? Colors.white : Colors.black,
                      cursorHeight: 16,
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
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSubmit(),
                    ),
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
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // 智能体按钮
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isAiEnabled = !_isAiEnabled;
                          });
                        },
                        icon: Icon(
                          Icons.public,
                          color:
                              _isAiEnabled
                                  ? (isDarkMode ? Colors.white : Colors.blue)
                                  : textColor.withOpacity(0.4),
                          size: 20,
                        ),
                        tooltip: '智能体',
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),

                      const Spacer(),

                      // 发送按钮
                      if (_hasValidContent)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _handleSubmit,
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color:
                                    isDarkMode
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.send,
                                color: isDarkMode ? Colors.white : Colors.blue,
                                size: 14,
                              ),
                            ),
                          ),
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
