// fullscreen 작업 진행 중 -------------------------------->

// necessary to build app
import 'package:edgeworks/components/cctvController_page/cctvListViewBuilder.dart';
import 'package:edgeworks/utils/getX_controller/cctvController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// dio
import 'package:dio/dio.dart';

// global
import '../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

/*
* name : CCTV Page
* description : CCTV Page
* writer : sherry
* create date : 2021-12-28
* last update : 2022-02-17
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

// Dio
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

//회사명 가져오기
var siteDropdown = stream.sitesDropdownValue == ''
    ? '${stream.siteNames[0]}'
    : stream.sitesDropdownValue;

// GetX controller
final _cctvController = Get.put(CctvController());

class CCTVPage extends StatefulWidget {
  CCTVPage({Key? key}) : super(key: key);

  @override
  _CCTVPageState createState() => _CCTVPageState();
}

class _CCTVPageState extends State<CCTVPage> {
  @override
  void initState() {
    _cctvController.getCctvData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
  }

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
                          child: StreamBuilder(
                              stream: _cctvController.cctvUrls.stream,
                              builder: (ctx, snapshot) {
                                if (snapshot.hasData) {
                                  return CctvListViewWidget();
                                } else {
                                  return CircularProgressIndicator();
                                }
                              })),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
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
}
