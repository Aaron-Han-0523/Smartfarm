import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:dio/dio.dart';
import '../globals/stream.dart' as stream;

/*
* name : CCTV Page
* description : CCTV Page
* writer : sherry
* create date : 2021-12-28
* last update : 2022-01-14
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
  late List<VlcPlayerController> controllers;
  late VlcPlayerController vlcPlayerController;
  List<String> urls = [
    'rtsp://admin:dbslzhs123%21%40%23@14.46.231.48:60554/Streaming/Channels/101',
    'rtsp://admin:dbslzhs123%21%40%23@14.46.231.48:60554/Streaming/Channels/101',
    'https://www.tomandjerryonline.com/Videos/tjpb1.mov'
  ];

  // visibiliby
  List<bool> _visibility = [true, true, true];

  @override
  void initState() {
    _getData();
    super.initState();
    controllers = <VlcPlayerController>[];
    for (var i = 0; i < urls.length; i++) {
      var controller = VlcPlayerController.network(
        urls[i],
        // hwAcc: HwAcc.FULL,
        autoPlay: true,
        // options: VlcPlayerOptions(),
      );
      controllers.add(controller);
    }
  }

  double _ratio = 16 / 9;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: Get.height * 0.14 ,
            backgroundColor: Color(0xffF5F9FC),
            title: Column(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Farm in Earth',
                  style: TextStyle(color: Color(0xff2E8953), fontSize: 22),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(stream.sitesDropdownValue,
                    style: TextStyle(color: Colors.black, fontSize: 17)),
              ),
            ]),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF5F9FC),
                      ),
                      alignment: Alignment.center,
                      child: _cctvBuilder()),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cctvBuilder() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
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
                                  // controllers[index].enterFullScreen();
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
                              // height: Get.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: VlcPlayer(
                                controller: controllers[index],
                                aspectRatio: _ratio,
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
        }
        );
  }



  // @override
  // void dispose() async {
  //   super.dispose();
  //   for (final controllers in controllers) {
  //     await controllers.dispose();
  //   }
  //   for (final controllers in controllers) {
  //     controllers.dispose();
  //   }
  // }
}


