// necessary to build app
import 'package:edgeworks/components/environmentController_page/customScrollView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// dio
import 'package:dio/dio.dart';

// global
import '../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;
import '../utils/getX_controller/motorController.dart';

/*
* name : Environment Page
* description : Environment Control Page
* writer : mark
* create date : 2021-12-24
* last update : 2021-02-17
* */


// Dio
var dio = Dio();

// GetX
final _motorController = Get.put(MotorController());

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


// define temp variable
var temp = int.parse(extTemp);

var textSizedBox = Get.width * 1 / 5;


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
    getSideSharedPrefs();
    getTopSharedPrefs();
  }

  // get site id
  var siteDropdown = stream.sitesDropdownValue == ''
      ? '${stream.siteNames[0]}'
      : stream.sitesDropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
