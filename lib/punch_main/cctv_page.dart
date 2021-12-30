import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

/*
* name : CCTV Page
* description : CCTV Page
* writer : sherry
* create date : 2021-12-28
* last update : 2021-12-30
* */

class CCTVPage extends StatefulWidget {
  @override
  _CCTVPageState createState() => _CCTVPageState();
}

class _CCTVPageState extends State<CCTVPage> {
  List<String> urls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    // "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  late VideoPlayerController _videoPlayerController1;
  late ChewieController _chewieController1;
  late VideoPlayerController _videoPlayerController2;
  late ChewieController _chewieController2;
  double _aspectRatio = 16 / 9;

  // visibiliby
  bool _visibility1 = true;
  bool _visibility2 = true;

  @override
  initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(urls[0]);
    _videoPlayerController2 = VideoPlayerController.network(urls[1]);
    _chewieController1 = ChewieController(
      allowFullScreen: true,
      videoPlayerController: _videoPlayerController1,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: true,
    );
    _chewieController2 = ChewieController(
      allowFullScreen: true,
      videoPlayerController: _videoPlayerController2,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Visibility(
                visible: _visibility1,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("CCTV #1"),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              // 카메라를 움직이는 버튼이나 일단 풀스크린전환
                              _chewieController1.enterFullScreen();
                            });
                          },
                          icon: Icon(Icons.control_camera)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.3,
                          width: MediaQuery.of(context).size.width,
                          child: Chewie(
                            controller: _chewieController1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              Visibility(
                visible: _visibility2,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("CCTV #2"),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              // 카메라를 움직이는 버튼이나 일단 풀스크린전환
                              _chewieController2.enterFullScreen();
                            });
                          },
                          icon: Icon(Icons.control_camera)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.3,
                          width: MediaQuery.of(context).size.width,
                          child: Chewie(
                            controller: _chewieController2,
                          ),
                        )
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    _videoPlayerController1.dispose();
    _chewieController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController2.dispose();
    super.dispose();
  }
}
