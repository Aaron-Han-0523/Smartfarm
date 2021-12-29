import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

/*
* name : CCTV Page
* description : CCTV Page
* writer : sherry
* create date : 2021-12-28
* last update : 2021-12-29
* */

// TODO : 전체화면 전환

class CCTVPage extends StatefulWidget {
  @override
  _CCTVPageState createState() => _CCTVPageState();
}

class _CCTVPageState extends State<CCTVPage> {
  late List<VlcPlayerController> playerControllers;
  List<String> urls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://media.w3.org/2010/05/sintel/trailer.mp4',
  ];

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  double _aspectRatio = 16 / 9;

  @override
  initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(urls[0]);
    _chewieController = ChewieController(
      allowFullScreen: true,
      videoPlayerController: _videoPlayerController,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("CCTV #1"),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _chewieController.enterFullScreen();
                    });
                  },
                  icon: Icon(Icons.control_camera)),
            ],
          ),
          Container(
            child: Chewie(
              controller: _chewieController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("CCTV #2"),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _chewieController.enterFullScreen();
                    });
                  },
                  icon: Icon(Icons.control_camera)),
            ],
          ),
          Container(
            child: Chewie(
              controller: _chewieController,
            ),
          ),
        ]),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     child: ListView.separated(
  //       padding: EdgeInsets.all(8.0),
  //       itemCount: playerControllers.length,
  //       separatorBuilder: (_, index) {
  //         return Divider(height: 50, thickness: 5);
  //       },
  //       itemBuilder: (_, index) {
  //         return Container(
  //           padding: EdgeInsets.only(left: 10, right: 10),
  //           alignment: Alignment.center,
  //           child: Visibility(
  //             visible: visibility_value[index],
  //             child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text("CCTV #${index + 1}"),
  //                       IconButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               playerControllers[index].value.isPlaying
  //                                   ? playerControllers[index].pause()
  //                                   : playerControllers[index].play();
  //                             });
  //                           },
  //                           icon: Icon(Icons.control_camera)),
  //                     ],
  //                   ),
  //                   VlcPlayer(
  //                     controller: playerControllers[index],
  //                     aspectRatio: _aspectRatio,
  //                   ),
  //                 ]),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  void dispose() async {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
    // for (final controller in playerControllers) {
    //   await controller.dispose();
    // }
  }
}
