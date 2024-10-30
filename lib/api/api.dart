import 'package:dio/dio.dart';
import 'package:video_info/bean/bean.dart';

/// 调用后端的API
class API {
  static const String _base = 'http://10.0.2.2:5000';
  static const String _videoList = '$_base/video_list';
  static const String _chat = '$_base/chat';

  static Dio dio = Dio();


  static Future<List<UnitInfo>> videoList() async {

    var result = await dio.get(_videoList);
    List<UnitInfo> list = [];
    for (var item in result.data) {
      list.add(UnitInfo.fromJson(item));
    }
    return list;
  }

  static Future<String> chat(String question, VideoInfo videoInfo) async {
    var result = await dio.get(_chat, queryParameters: {
      'question': question,
      'video_url': videoInfo.url,
      'video_title': videoInfo.title,
      'video_description': videoInfo.description,
    });
    return result.data;
  }
}
