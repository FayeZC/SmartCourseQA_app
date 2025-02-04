import 'package:flutter/material.dart';
import 'package:video_info/api/api.dart';
import 'package:video_info/video_page.dart';

import 'bean/bean.dart';


class UnitPage extends StatefulWidget {
  const UnitPage({super.key});

  @override
  State<UnitPage> createState() => _UnitPageState();
}


class _UnitPageState extends State<UnitPage> {
  bool _loading = true;
  List<UnitInfo> infoList = [];

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
     
      body: Builder(builder: (context) {
        // endless!!!!!rotation!!!!
        if (_loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            itemBuilder: (c, i) {
              UnitInfo info = infoList[i];

              return ListTile(

                leading: CircleAvatar(child: Text('${i + 1}')),

                title: Text(info.title),

                subtitle: Text(info.description),

                onTap: () {
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
