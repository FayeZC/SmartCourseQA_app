class UnitInfo {
  String title;
  String description;
  List<VideoInfo> videos;

  UnitInfo({
    required this.title,
    required this.description,
    required this.videos,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'videos': videos,
    };
  }

  factory UnitInfo.fromJson(Map<String, dynamic> map) {
    List list = map['videos'];
    List<VideoInfo> videos =
        list.map((map) => VideoInfo.fromJson(map)).toList();
    return UnitInfo(
      title: map['title'] as String,
      description: map['description'] as String,
      videos: videos,
    );
  }
}

class VideoInfo {
  String title;
  String description;
  String url;
  List<VideoSubtitleItem> subtitles;

  VideoInfo({
    required this.title,
    required this.description,
    required this.url,
    required this.subtitles,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'subtitles': subtitles,
    };
  }

  factory VideoInfo.fromJson(Map<String, dynamic> map) {
    return VideoInfo(
      title: map['title'] as String,
      description: map['description'] as String,
      url: map['url'] as String,
      subtitles: map['subtitles'] ?? [],
    );
  }
}

class VideoSubtitleItem {
  int startTime;
  int endTime;
  String content;

  VideoSubtitleItem({
    required this.startTime,
    required this.endTime,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'content': content,
    };
  }

  factory VideoSubtitleItem.fromJson(Map<String, dynamic> map) {
    return VideoSubtitleItem(
      startTime: map['startTime'] as int,
      endTime: map['endTime'] as int,
      content: map['content'] as String,
    );
  }
}
