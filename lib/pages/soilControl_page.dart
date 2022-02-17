// necessary to build app
import 'package:edgeworks/components/soilController_page/customScrollViews.dart';
import 'package:edgeworks/utils/getX_controller/soilController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/*
* name : Soil Control Page
* description : Soil Control Page
* writer : sherry
* create date : 2021-12-24    
* last update : 2022-02-03
* */

class SoilControlPage extends StatefulWidget {
  SoilControlPage({Key? key}) : super(key: key);

  @override
  _SoilControlPageState createState() => _SoilControlPageState();
}

class _SoilControlPageState extends State<SoilControlPage> {
  final controller = Get.put(SoilController());

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    if (_isInit == false) {
      controller.pumpsHttp();
      controller.valvesHttp();
      _isInit = true;
    }
    setState(() {});
    super.initState();
  }

  bool _isInit = false;

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollViews(),
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
