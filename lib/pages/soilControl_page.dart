// ** SOIL CONTROL PAGE **

// Necessary to build app
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// GetX
import 'package:edgeworks/utils/getX_controller/soilController.dart';

// Get Widget Pages
import 'package:edgeworks/components/soilController_page/soilCustomScrollViews.dart';


/*
* name : Soil Control Page
* description : Soil Control Page
* writer : sherry
* create date : 2021-12-24    
* last update : 2022-02-18
* */

// GetX Controller
final controller = Get.put(SoilController());


class SoilControlPage extends StatefulWidget {
  SoilControlPage({Key? key}) : super(key: key);

  @override
  _SoilControlPageState createState() => _SoilControlPageState();
}

class _SoilControlPageState extends State<SoilControlPage> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    print("_isInit1 $_isInit");
    if (_isInit == false) {
      print("_isInit3 $_isInit");
      controller.pumpsHttp();
      controller.valvesHttp();
      controller.isInits.value = true;
      print("_isInit4 $_isInit");
      Future.delayed(Duration(microseconds: 3000), () {
        controller.isFutures.value = true;
      });
    }
    print("_isInit2 $_isInit");
    print("_isInit2 $_isInit");
    // setState(() {});
    super.initState();
  }

  bool _isInit = controller.isInits.value;
  bool _isFuture = controller.isFutures.value;

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Scaffold(
      body: FutureBuilder(
          future: controller.valvesHttp(),
          builder: (context, snapshot) {
            if (_isFuture == true) {
              return Stack(
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
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
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
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
