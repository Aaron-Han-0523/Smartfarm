// ** ENVIRONMENT PAGE **

// Necessary to build app
import 'package:edgeworks/components/environmentController_page/customScrollView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Dio
import 'package:dio/dio.dart';

// GetX Controller
import 'package:edgeworks/utils/getX_controller/motorController.dart';

// Global
import 'package:edgeworks/globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;


/*
* name : Environment Page
* description : Environment Control Page
* writer : mark
* create date : 2021-12-24
* last update : 2021-02-18
* */

//Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// Dio
var dio = Dio();

// GetX
final _motorController = Get.put(MotorController());

// Define shared toggle variable
int? getToggleStatus;
int? getTopToggleStatus;
int? allSideToggleInit;
int? allTopToggleInit;

// Define global variable
bool isLoading = _motorController.isLoading.value;

// Define Text Size Box
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
    if (isLoading == false) {
      _motorController.getSideMotorsData();
      _motorController.getTopMotorsData();
      _motorController.getEtcMotorData();
      _motorController.isLoading.value = true;
    }
    getSideSharedPrefs();
    getTopSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _motorController.getEtcMotorData(),
      builder: (ctx, snapshot) {
        if (isLoading == true) {
          return Scaffold(
            body: Stack(
              children: [
                EnvironCustomScrollView(),
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
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Stack(
              children: [
                EnvironCustomScrollView(),
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
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}
