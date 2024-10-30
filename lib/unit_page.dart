import 'package:flutter/material.dart';
import 'package:video_info/api/api.dart';
import 'package:video_info/video_page.dart';

import 'bean/bean.dart';


class UnitPage extends StatefulWidget {
  const UnitPage({super.key});

  // 创建自己的State
  @override
  State<UnitPage> createState() => _UnitPageState();
}


class _UnitPageState extends State<UnitPage> {
  bool _loading = true;
  List<UnitInfo> infoList = [];

  /// 当State刚被创建的时候，获取VideoList
  @override
  void initState() {
    super.initState();

    API.videoList().then((data) {
      if (mounted) {
        setState(() {
          _loading = false;
          infoList = data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('8th Grade Math'),
      ),
      // Builder的构造函数传入构造Body界面样子的逻辑
      body: Builder(builder: (context) {
        // 如果正在加载，就显示一个圆形的无尽旋转进度条
        if (_loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          /// 如果已经拿到列表，则构造一个列表View
          return ListView.separated(
            itemBuilder: (c, i) {
              UnitInfo info = infoList[i];

              return ListTile(

                leading: CircleAvatar(child: Text('${i + 1}')),

                title: Text(info.title),

                subtitle: Text(info.description),

                onTap: () {
                  /// 跳转到VideoPage，并把对应的UnitInfo传过去
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return VideoPage(unitInfo: info);
                    },
                  ));
                },
              );
            },
            itemCount: infoList.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        }
      }),
    );
  }
}
