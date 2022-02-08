import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';


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
  late VlcPlayerController controller;
  var controllers;
  _PageTransitionState(this. controllers);  //constructor

  @override
  void initState() {
    super.initState();
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
    print('저장된 cctv 확인 : $controllers');

  }

  @override
  void dispose() {
    super.dispose();
    // controllers.dispose();
  }

  // appbar 생성해서 전체화면 만들어야 함
  // Get.offAllback 사용해서 페이지 이동하기
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: VlcPlayer(
            controller: controllers,
            aspectRatio: 1.88
        ),
      ),
    );
  }
}