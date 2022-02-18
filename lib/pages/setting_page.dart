// ** SETTING PAGE **

// Necessary to build app
import 'package:edgeworks/components/setting_page/listViews.dart';
import 'package:edgeworks/utils/getX_controller/settingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dio
import 'package:dio/dio.dart';
import 'package:edgeworks/utils/dio/logoutdio.dart';

// Env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// GetX Controller
import 'package:edgeworks/utils/getX_controller/sensorController.dart';

// Global
import '../globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;

/*
* name : Setting Page
* description : setting page
* writer : walter/mark
* create date : 2021-09-30
* last update : 2021-02-18
* */

// Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// Dio
Dio dio = Dio();

// GetX Controller
final realTimeController = Get.put(SensorController());

// Get Logout Class
Logout _logout = Logout();

// SiteDropdown button global variable
String sitesDropdownValue = stream.sitesDropdownValue == ''
    ? '${stream.siteNames[0]}'
    : stream.sitesDropdownValue;

// Define Global Variable
bool status = false;


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {


  // [Function] get alarm toggle value
  int? alarmToggleValue;
  getAlarmToggle() async {
    final prefs = await SharedPreferences.getInstance();
    alarmToggleValue = prefs.getInt('alarmToggleValue') ?? 0;
    print('[global/toggle page] get all side value : $alarmToggleValue');
    setState(() {
      alarmToggleValue;
    });
    return alarmToggleValue;
  }

  @override
  void initState() {
    getAlarmToggle();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    controller.connect();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Get.put(SettingController()).set_timer.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                backgroundColor: Color(0xffF5F9FC),
                appBar: AppBar(
                  backgroundColor: Color(0xffFFFFFF),
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded,
                        color: Color(0xff222222)),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      // 로그아웃
                      child: IconButton(
                        icon:
                            Icon(Icons.login_rounded, color: Color(0xff222222)),
                        onPressed: () {
                          _logout.logout();
                        },
                      ),
                    )
                  ],
                  title: Column(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Farm in Earth',
                        style:
                            TextStyle(color: Color(0xff2E8953), fontSize: 18),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(sitesDropdownValue,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ),
                body: BodyListViews());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
