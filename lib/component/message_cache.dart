
class CachedMessage
{
  bool isUser;
  String message;

  CachedMessage({
    required this.isUser,
    required this.message
  });
}

class MessageCache
{
  static MessageCache? _instance;

  MessageCache._internal();

  static MessageCache getInstance()
  {
    _instance ??= MessageCache._internal();
    return _instance!;
  }

  final Map<String, List<CachedMessage>> _cache = {};

  void addMessage(String key, CachedMessage message)
  {
    if (_cache[key] == null)
      {
        _cache.putIfAbsent(key, () => [message]);
      }
    else
      {
        _cache[key]!.insert(0, message);
      }
  }

  void addMessages(String key, List<CachedMessage> messages)
  {
    _cache.putIfAbsent(key, () => messages);
  }

  List<CachedMessage>? getMessages(String key)
  {
    return _cache[key];
  }
}