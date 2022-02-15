// fullscreen 작업 진행 중 -------------------------------->

// necessary to build app
import 'package:edgeworks/utils/getX_controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// dio
import 'package:dio/dio.dart';

// global
import '../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

// pages
import 'package:edgeworks/pages/fullScreenCctv_page.dart';
import 'fullScreenCctv_page.dart';

/*
* name : CCTV Page
* description : CCTV Page
* writer : sherry
* create date : 2021-12-28
* last update : 2022-02-09
* */

// global
List cctvs = stream.cctvs;
List cctvUrl = stream.cctv_url;
var vlcController;

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

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
  print('##### [cctvPage] GET CCTV List from stream: ${stream.cctvs}');
  print('##### [cctvPage] GET CCTV List length: ${stream.cctvs.length}');
  stream.cctv_url = [];
  for (var i = 0; i < stream.cctvs.length; i++) {
    var cctvUrl = stream.cctvs[i]['cctv_url'];
    stream.cctv_url.add(cctvUrl);
  }
  print('##### [cctvPage] GET CCTV Url List: ${stream.cctv_url}');
}

class CCTVPage extends StatefulWidget {
  CCTVPage({Key? key}) : super(key: key);

  @override
  _CCTVPageState createState() => _CCTVPageState();
}

class _CCTVPageState extends State<CCTVPage> {
  late  List<VlcPlayerController> controllers;
  late  List<VlcPlayerController> controllers2;

  // late VlcPlayerController vlcPlayerController;
  List<String> urls = [
    'rtsp://admin:dbslzhs123%21%40%23@14.46.231.48:60554/Streaming/Channels/101',
    'rtsp://admin:dbslzhs123%21%40%23@14.46.231.48:60554/Streaming/Channels/101',
    'https://www.tomandjerryonline.com/Videos/tjpb1.mov'
  ];

  // visibiliby
  List<bool> _visibility = [true, true, true];
  // controller variable
  var controller;
  var controller2;

  final getXcontroller = Get.put(CounterController());


  //회사명 가져오기
  var siteDropdown = stream.sitesDropdownValue == ''
      ? '${stream.siteNames[0]}'
      : stream.sitesDropdownValue;


  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    setState(() {
      _getData();

      controllers = <VlcPlayerController>[];
      for (var i = 0; i < urls.length; i++) {
        controller = VlcPlayerController.network(
          urls[i],
          // hwAcc: HwAcc.FULL,
          autoPlay: true,
          options: VlcPlayerOptions(),
        );
        controllers.add(controller);
      }
      // 전체화면 controller
      controllers2 = <VlcPlayerController>[];
      for (var i = 0; i < urls.length; i++) {
        controller2 = VlcPlayerController.network(
          urls[i],
          autoPlay: true,
          options: VlcPlayerOptions(),
        );
        controllers2.add(controller2);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
  }

  // refresh function
  _refresh(dynamic value) => setState(() {
    controllers.remove(value);
    controllers = <VlcPlayerController>[];
    for (var i = 0; i < urls.length; i++) {
      controller = VlcPlayerController.network(
        urls[i],
        // hwAcc: HwAcc.FULL,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
      controllers.add(controller);
    }
    controllers.remove(value);
    controllers2 = <VlcPlayerController>[];
    for (var i = 0; i < urls.length; i++) {
      controller2 = VlcPlayerController.network(
        urls[i],
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
      controllers2.add(controller2);
    }
  });

  double _ratio = 16 / 9;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                toolbarHeight: Get.height * 0.08,
                backgroundColor: Color(0xffF5F9FC),
                title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Farm in Earth',
                          style:
                          TextStyle(color: Color(0xff2E8953), fontSize: 22),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(siteDropdown,
                            style:
                            TextStyle(color: Colors.black, fontSize: 17)),
                      ),
                      SizedBox(height: Get.height * 0.01),
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
          Positioned(
            bottom: 0,
            // height: Get.height * 1 / 14,
            // width: Get.width,
            child: Container(
              height: Get.height * 1 / 30,
              width: Get.width,
              child: Image.asset(
                'assets/images/image_bottombar.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isFullScreen = false;

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
                              onPressed: () async {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeLeft,
                                  DeviceOrientation.landscapeRight,
                                ]);
                                await Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute<bool>(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) => PageTransition(
                                      controllers: controllers2[index],
                                    ),
                                  ),
                                ).then(_refresh);

                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                ]);
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
                                // controllers[index],
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
        });
  }
}
