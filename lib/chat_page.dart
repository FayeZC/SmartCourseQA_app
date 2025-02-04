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
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
=    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
    /// save into cache
    _cache.addMessage(widget.videoInfo.url, CachedMessage(isUser: true, message: message.text));

    _addMessage(
        types.SystemMessage(id: const Uuid().v4(), text: 'generating...'));

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
