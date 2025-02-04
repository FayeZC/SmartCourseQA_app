import 'package:flutter/material.dart';
import 'package:video_info/bean/bean.dart';
import 'package:video_info/chat_page.dart';

class VideoPage extends StatefulWidget {
  final UnitInfo unitInfo;

  const VideoPage({super.key, required this.unitInfo});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late UnitInfo unitInfo = widget.unitInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(unitInfo.title),
      ),
      body: ListView.separated(
          itemBuilder: (c, i) {
            VideoInfo info = unitInfo.videos[i];
            return ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text(info.title),
              subtitle: Text(info.description),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return ChatPage(videoInfo: info);
                  },
                ));
              },
            );
          },
          separatorBuilder: (c, i) {
            return const Divider();
          },
          itemCount: unitInfo.videos.length),
    );
  }
}
