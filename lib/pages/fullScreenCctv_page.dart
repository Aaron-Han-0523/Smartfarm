// 작업 진행 중 ---------------------------->

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';


class PageTransition extends StatefulWidget {
  var controllers;
  PageTransition({Key? key, @required this.controllers}) : super(key: key);


  @override
  _PageTransitionState createState() => _PageTransitionState(controllers);
}

class _PageTransitionState extends State<PageTransition> {

  late  List<VlcPlayerController> reSetControllers;
  var controller1;
  var controllers;
  List<String> urls = [
    'rtsp://admin:dbslzhs123%21%40%23@14.46.231.48:60554/Streaming/Channels/101',
    'rtsp://admin:dbslzhs123%21%40%23@14.46.231.48:60554/Streaming/Channels/101',
    'https://www.tomandjerryonline.com/Videos/tjpb1.mov'
  ];

  _PageTransitionState(this. controllers);  //constructor

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  // appbar 생성해서 전체화면 만들어야 함
  // Get.offAllback 사용해서 페이지 이동하기 -> 안됨 cctv 페이지 자체를 호출하게 되면 tabbar와 appbar가 깨짐
  // tab bar와 appbar는 sensor 페이지에 있기 때문에 해당 컨테이너를 불러오지 못함
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              Navigator.of(context).pop(false);
              // Navigator.of(context).pop(true);
            },
          ),
        ),
        body: VlcPlayer(
            controller:
            controllers,
            // Get.arguments,
            aspectRatio: 1.88
        ),
      );
  }

}