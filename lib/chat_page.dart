import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';
import 'package:video_info/bean/bean.dart';

import 'api/api.dart';
import 'component/message_cache.dart';

class ChatPage extends StatefulWidget {
  final VideoInfo videoInfo;

  const ChatPage({super.key, required this.videoInfo});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  /// 用来区分左右两个对话者的身份ID，放在消息对象Message里面
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _gpt = types.User(id: const Uuid().v4());
  final _cache = MessageCache.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final messageStringList = _cache.getMessages(widget.videoInfo.url) ?? [];
    for (var element in messageStringList) {
      final tempMessage = types.TextMessage(
        author: element.isUser ? _user : _gpt,
        id: const Uuid().v4(),
        text: element.message
      );
      _messages.add(tempMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      /// _messages保存要显示的所有消息对象，从index越小，在界面显示越靠下
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }

  /// 当点击发送按钮后的逻辑
  void _handleSendPressed(types.PartialText message) {
    /// 创建一个当前发送的message对象
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
    /// save into cache
    _cache.addMessage(widget.videoInfo.url, CachedMessage(isUser: true, message: message.text));

    /// 临时插入一个ChatGPT正在处理的消息，当真正的chatgpt消息获取到后，这个临时消息将被替换
    _addMessage(
        types.SystemMessage(id: const Uuid().v4(), text: 'generating...'));

    /// 异步的获取ChatGPT的回答
    API.chat(message.text, widget.videoInfo).then((data) {
      final replyMessage = types.TextMessage(
        author: _gpt,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: data,
      );

      _replaceMessage(0, replyMessage);
      _cache.addMessage(widget.videoInfo.url, CachedMessage(isUser: false, message: data));
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _replaceMessage(int index, types.Message message) {
    setState(() {
      _messages[index] = message;
    });
  }
}
