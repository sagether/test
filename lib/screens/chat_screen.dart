import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _messageScrollController = ScrollController();
  final ScrollController _inputScrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isAiEnabled = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _messageScrollController.dispose();
    _inputScrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
    // 确保在下一帧渲染完成后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_inputScrollController.hasClients) {
        _inputScrollController.animateTo(
          _inputScrollController.position.maxScrollExtent,
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
      final messageText = _controller.text.trim();
      setState(() {
        // 添加用户消息
        _messages.add(
          ChatMessage(
            text: messageText,
            isUser: true,
            timestamp: DateTime.now(),
          ),
        );

        // 模拟AI回复
        _messages.add(
          ChatMessage(
            text: "这是一个模拟的AI回复消息。在实际应用中，这里应该调用后端API获取真实的AI回复。",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      // 重置输入框
      _controller.clear();

      // 滚动消息列表到底部
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_messageScrollController.hasClients) {
          _messageScrollController.animateTo(
            _messageScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 需要调用super.build来支持AutomaticKeepAliveClientMixin
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      children: [
        // 聊天展示区域
        Expanded(
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
            child:
                _messages.isEmpty
                    ? _buildWelcomeMessage()
                    : _buildChatMessages(),
          ),
        ),

        // 输入区域
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          color: Colors.transparent,
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
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: TextField(
                        controller: _controller,
                        scrollController: _inputScrollController,
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
                        IconButton(
                          onPressed: _handleSubmit,
                          icon: Icon(
                            Icons.send_rounded,
                            color: isDarkMode ? Colors.white : Colors.blue,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          splashRadius: 24,
                          tooltip: '发送',
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

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        controller: _messageScrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];

          if (message.isUser) {
            // 用户消息
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : const Color(0xFFF7F7F8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // AI回复
            return Padding(
              padding: const EdgeInsets.only(bottom: 24, right: 48),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
