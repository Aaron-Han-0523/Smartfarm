import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'cctv_page.dart';


// class PageTransition extends StatelessWidget {
//
//   var controllers; //FirstRoute에서 전달 받은 변수를 사용하기 위해 변수 선언
//   PageTransition(this.controllers);
//     late VlcPlayerController controller;
//
//
//   @override
//   void initState() {
//     // controllers;
//     controller = controllers;
//     print('cctv  확인 : $controller');
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("전체 화면"),//입력받은 값을 사용하여 AppBar 타이틀 값에 적용
//       ),
//       body: VlcPlayer(
//           controller: controller,
//           aspectRatio: 1.88
//       ),
//     );
//   }
// }

class PageTransition extends StatefulWidget {
  var controllers;
  PageTransition({Key? key, @required this.controllers}) : super(key: key);


  @override
  _PageTransitionState createState() => _PageTransitionState(controllers);
}

class _PageTransitionState extends State<PageTransition> {
  var controllers;
  CCTVPage _cctvPage = CCTVPage();
  _PageTransitionState(this. controllers);  //constructor

  @override
  void initState() {
    super.initState();
    _cctvPage;
    setState(() {
      // controllers;
      Get.arguments;
      // SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.landscapeLeft,
      //   DeviceOrientation.landscapeRight,
      // ]);
    });
    // controller = VlcPlayerController.network(
    //   'rtsp://admin:dbslzhs123%21%40%23@14.46.231.48:60554/Streaming/Channels/101',
    //   autoPlay: true,
    //   options: VlcPlayerOptions(),
    // );
    // controller = VlcPlayerController.network(
    //     '$controllers',
    //   autoPlay: true,
    //   options: VlcPlayerOptions(),
    // );

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(PageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    // setState(() {});
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
              // Get.back();
              // setState(() {
              //   CCTVPage();
              //   SystemChrome.setPreferredOrientations([
              //     DeviceOrientation.portraitUp,
              //   ]);
              //   Navigator.pop(context);
              //
              // });
              // Navigator.of(context, rootNavigator: true).push(
              //   MaterialPageRoute(builder: (_) =>
              //       CCTVPage())
              // );
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) =>
              //             CCTVPage()),
              //         (Route<dynamic> route) => false);

              Navigator.of(context, rootNavigator: false).push(
                CupertinoPageRoute<bool>(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => CCTVPage(),
                ),
              );
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