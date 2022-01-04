import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import '../globals/stream.dart' as stream;

/*
* name : CCTV Page
* description : CCTV Page
* writer : sherry
* create date : 2021-12-28
* last update : 2022-01-04
* */

// global
List cctvs = stream.cctvs;
List cctv_url = stream.cctv_url;

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = 'test';
var siteId = 'sid';

// dio APIs
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

// getData()
void _getData() async {
  // cctvs
  final getCctvs = await dio.get('$url/$userId/site/$siteId/cctvs');
  stream.cctvs = getCctvs.data;
  print('##### cctvPage GET CCTV List from stream: ${stream.cctvs}');
  print('##### cctvPage GET CCTV List length: ${stream.cctvs.length}');
  stream.cctv_url = [];
  for (var i = 0; i < stream.cctvs.length; i++) {
    var cctvUrl = stream.cctvs[i]['cctv_url'];
    stream.cctv_url.add(cctvUrl);
  }
  print('##### cctvPage GET CCTV Url List: ${stream.cctv_url}');
}

class CCTVPage extends StatefulWidget {
  @override
  _CCTVPageState createState() => _CCTVPageState();
}

class _CCTVPageState extends State<CCTVPage> {
  late List<VideoPlayerController> VideoPlayerControllers;
  late List<ChewieController> ChewieControllers;
  double _aspectRatio = 16 / 9;

  // visibiliby
  List<bool> _visibility = [true, true];

  @override
  initState() {
    _getData();
    super.initState();
    VideoPlayerControllers = [];
    ChewieControllers = [];
    for (var i = 0; i < cctv_url.length; i++) {
      var videoPlayerController = VideoPlayerController.network(cctv_url[i]);
      VideoPlayerControllers.add(videoPlayerController);
      var chewieController = ChewieController(
        allowFullScreen: true,
        videoPlayerController: VideoPlayerControllers[i],
        aspectRatio: _aspectRatio,
        autoInitialize: true,
        autoPlay: true,
      );
      ChewieControllers.add(chewieController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: cctvs.length,
          itemBuilder: (BuildContext context, var index) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Visibility(
                      visible: _visibility[index],
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("CCTV #" + "${index + 1}"),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    // 카메라를 움직이는 버튼이나 일단 풀스크린전환
                                    ChewieControllers[index].enterFullScreen();
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
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width,
                                child: Chewie(
                                  controller: ChewieControllers[index],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    for (final videoPlayerController in VideoPlayerControllers) {
      await videoPlayerController.dispose();
    }
    for (final chewieController in ChewieControllers) {
      chewieController.dispose();
    }
  }
}
