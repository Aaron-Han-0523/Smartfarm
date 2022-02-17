// ** CCTV LIST VIEW WIDGET PAGE **

// necessary to build app
import 'package:edgeworks/pages/fullScreenCctv_page.dart';
import 'package:edgeworks/utils/getX_controller/cctvController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';

/*
* name : CCTV List View Widget Page
* description : CCTV List view builder widget
* writer : mark
* create date : 2021-12-28
* last update : 2022-02-16
* */


// getx controller
CctvController _cctvController = CctvController();

// Vlc Player Controller
// late  List<VlcPlayerController> controllers;
// late  List<VlcPlayerController> controllers2;

// controller variable
// var controller;
// var controller2;

// visibiliby
List<bool> _visibility = [true, true, true];


class CctvListViewWidget extends StatefulWidget {
  // var controllers;
  // var countVideo;
  // var refreshFunction;
  CctvListViewWidget({Key? key}) : super(key: key);

  @override
  _CctvListViewWidgetState createState() => _CctvListViewWidgetState();
}

class _CctvListViewWidgetState extends State<CctvListViewWidget> {
  late List<VlcPlayerController> vlcControllers;
  late List<VlcPlayerController> controllers2;
  var vlcController;

  var controllers;
  var countVideo;

  // getx controller
  final _cctvController = Get.put(CctvController());

  // _CctvListViewWidgetState(controllers, countVideo);

  void initState() {

    print(_cctvController.cctvUrls.length);
    // _cctvController.getCctvData();
    vlcControllers = <VlcPlayerController>[];
    for (var i = 0; i < _cctvController.cctvUrls.length; i++) {
      vlcController = VlcPlayerController.network(
        _cctvController.cctvUrls[i].value,
        // hwAcc: HwAcc.FULL,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
      vlcControllers.add(vlcController);
    }
    super.initState();
  }

  double _ratio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _cctvController.cctvUrls.length,
          itemBuilder: (BuildContext context, var index) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("CCTV #" + "${index + 1}"),
                          IconButton(
                              onPressed: () async {

                                // full screen mode
                                // SystemChrome.setPreferredOrientations([
                                //   DeviceOrientation.landscapeLeft,
                                //   DeviceOrientation.landscapeRight,
                                // ]);
                                // await Navigator.of(context, rootNavigator: true).push(
                                //   CupertinoPageRoute<bool>(
                                //     fullscreenDialog: true,
                                //     builder: (BuildContext context) => PageTransition(
                                //       controllers: controllers2[index],
                                //     ),
                                //   ),
                                // ).then(_refresh);
                                //
                                // SystemChrome.setPreferredOrientations([
                                //   DeviceOrientation.portraitUp,
                                // ]);
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
                                controller: vlcControllers[index],
                                // controllers[index],
                                aspectRatio: _ratio,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
            );
          });
    });
    }

  }

