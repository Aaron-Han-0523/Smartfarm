
// necessary to build app
import 'package:edgeworks/components/environ_con/customScrollView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:expandable_text/expandable_text.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// dio
import 'package:dio/dio.dart';

// mqtt
import 'package:edgeworks/utils/mqtt/mqtt.dart';

// getX controller
import '../utils/getX_controller/controller.dart';

// global
import 'package:edgeworks/globals/toggle.dart' as toggle;
import '../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

import '../utils/getX_controller/motorController.dart';


/*
* name : Environment Page
* description : Environment Control Page
* writer : mark
* create date : 2021-12-24
* last update : 2021-02-15
* */

// MQTT class
ConnectMqtt _connectMqtt = ConnectMqtt();

// Dio
var dio = Dio();

// GetX
final getxController = Get.put(MotorController());

//Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// [globalkey] temp/humid
var innerTemp = stream.temp_1; // 내부온도
var extTemp = stream.exttemp_1; // 외부온도
var soilTemp = stream.soiltemp_1; // 토양온도
var innerHumid = stream.humid_1; // 내부습도
var extHumid = stream.humid_1; // 외부습도
var soilHumid = stream.soilhumid_1; // 토양습도

// [globalkey] motor
List sideMotors = stream.sideMotors;
List topMotors = stream.topMotors;
List motorName = stream.top_motor_name;
List switchId = stream.switch_id;
List sideStatus = stream.sideMotorStatus;
List topStatus = stream.topMotorStatus;

// define toggle variable
int? getToggleStatus;
int? getTopToggleStatus;
int? allSideToggleInit;
int? allTopToggleInit;

// expanded tile variable
bool _customTileExpanded = false;

// define temp variable
var temp = int.parse(extTemp);

var textSizedBox = Get.width * 1 / 5;


// [function] update DB - motor data
Future<void> _updateMotorData(var motorName, var motorType, var motorAction,
    var updateMotorType, var motorId) async {
  var params = {
    'motor_name': motorName,
    'motor_type': motorType,
    'motor_action': motorAction,
  };
  var response = await dio.put(
      '$url/$userId/site/$siteId/controls/$updateMotorType/motors/$motorId',
      data: params);
  print('### [environment page] 모터 타입 변경 완료 : $response');
  // 변경 완료 시 응답 결과 : 1
  // 변경 되어 있을 경우 응답 결과 : 0
}

// [function] update DB - motor data
Future<void> _updateEtcMotorData(var motorAction, var motorId) async {
  var params = {
    // 'motor_name': motorName,
    'actuator_action': motorAction,
  };
  var response = await dio.put(
      '$url/$userId/site/$siteId/controls/actuators/$motorId',
      data: params);
  print('### [environment page] etc 모터 타입 변경 완료 : $response');
}

Future<void> _updateAllMotorData(var motorAction, var updateMotorType) async {
  var params = {
    'motor_action': motorAction,
  };
  var response = await dio.put(
      '$url/$userId/site/$siteId/controls/$updateMotorType/motors',
      data: params);
  print('### [environment page] 사이드 전체 모터 타입 변경 완료 : $response');
}


class EnvironmentPage extends StatefulWidget {
  const EnvironmentPage({Key? key}) : super(key: key);

  @override
  _EnvironmentState createState() => _EnvironmentState();
}

class _EnvironmentState extends State<EnvironmentPage> {
  //shared preferences all side toggle status
  Future<Null> getSideSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToggleStatus = prefs.getInt('allSideValue') ?? 0;
    print('## get all side value : $getToggleStatus');
    setState(() {
      allSideToggleInit = getToggleStatus;
    });
  }

  //shared preferences top toggle status
  Future<Null> getTopSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getTopToggleStatus = prefs.getInt('allTopValue') ?? 0;
    print('## get all top value : $getTopToggleStatus');
    setState(() {
      allTopToggleInit = getTopToggleStatus;
    });
  }


  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () async {
      getxController.getMotorsData();});
    getSideSharedPrefs();
    getTopSharedPrefs();
  }

  var siteDropdown = stream.sitesDropdownValue == ''
      ? '${stream.siteNames[0]}'
      : stream.sitesDropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff2E6645),
      body: Stack(
        children: [
          EnvironCustomScrollView(),
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
}