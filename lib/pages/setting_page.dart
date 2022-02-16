// necessary to build app
import 'package:edgeworks/components/setting_page/listViews.dart';
import 'package:edgeworks/utils/getX_controller/settingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

// dio
import 'package:dio/dio.dart';
import 'package:edgeworks/utils/dio/logoutdio.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// mqtt
import 'package:edgeworks/utils/mqtt/mqtt.dart';

// getX controller
import 'package:edgeworks/utils/getX_controller/sensorController.dart';

// global
import '../globals/stream.dart' as stream;
import 'package:edgeworks/globals/siteConfig.dart' as siteConfig;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;
import 'package:edgeworks/globals/toggle.dart' as toggle;

/*
* name : Setting Page
* description : setting page
* writer : walter/mark
* create date : 2021-09-30
* last update : 2021-02-03
* */

// Api's
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

// siteDropdown button global variable
String sitesDropdownValue =
    stream.sitesDropdownValue == '' ? 'test' : stream.sitesDropdownValue;

// siteDropdown button global variable
var siteDropdown =
    stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // real time data
  final realTimeController = Get.put(SensorController());

  // logout class
  Logout _logout = Logout();

  // MQTT class
  ConnectMqtt _connectMqtt = ConnectMqtt();

  // TextEditing Controller
  final _highTextEditController = TextEditingController(
      text: siteConfig.high_temp == '' ? null : siteConfig.high_temp);
  final _nullTextEditingController = TextEditingController(text: ' ');
  final _lowTextEditController = TextEditingController(
      text: siteConfig.low_temp == '' ? null : siteConfig.low_temp);

  //global key
  bool status = false;
  var _setTimer = siteConfig.set_timer;
  bool _alarmStatus = siteConfig.status_alarm;

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

  final controller = Get.put(SettingController());
  @override
  void initState() {
    // realTimeController.getConfig();
    getAlarmToggle();
    // _connectMqtt.getSiteConfig();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    controller.connect();
    setState(() {});
  }

  @override
  void dispose() {
    _highTextEditController.dispose();
    _lowTextEditController.dispose();
    super.dispose();
  }

  // Update DB function
  Future<void> _updateData(var site_set_alarm_enable, var site_set_alarm_high,
      var site_set_alarm_low, var site_set_alarm_timer) async {
    var params = {
      'site_set_alarm_enable': site_set_alarm_enable,
      'site_set_alarm_high': site_set_alarm_high,
      'site_set_alarm_low': site_set_alarm_low,
      'site_set_alarm_timer': site_set_alarm_timer,
    };
    var response =
        await dio.put('$url/$userId/site/$siteId/settings', data: params);
    print('[setting page] 경보 알림 설정 결과 : $response');
    // 경보 알림 설정이 변경 되었을 경우 : 1
    // 경보 알림 설정 변경이 이미 되어있는 경우 : 0
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

  // 경보 활성화 widget
  List<String> labelName = ['ON', 'OFF'];
  var selectedLabel = '';
  int initialIndex = siteConfig.status_alarm == true ? 0 : 1;
  int? toggleValue;

  // Widget _swichWidget(String name) {
  //   return Container(
  //     color: Color(0xffFFFFFF),
  //     height: Get.height * 0.08,
  //     width: Get.width,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(left: 15),
  //           child: Text(
  //             name,
  //             style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.black54),
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(right: 10),
  //           child: ToggleSwitch(
  //             fontSize: 12,
  //             minWidth: 60.0,
  //             cornerRadius: 80.0,
  //             activeBgColors: [
  //               [Color(0xffe3fbed)],
  //               [Color(0xfff2f2f2)]
  //             ],
  //             activeFgColor: Color(0xff222222),
  //             inactiveBgColor: Color(0xffFFFFFF),
  //             inactiveFgColor: Color(0xff222222),
  //             initialLabelIndex: alarmToggleValue,
  //             // stream.alarm_en == true ? 0 : 1,
  //             // stream.pumpStatus[index] == 0 ? 1 : 0,
  //             totalSwitches: 2,
  //             labels: labelName,
  //             radiusStyle: true,
  //             onToggle: (value) async {
  //               setState(() {
  //                 alarmToggleValue = value;
  //                 if (value == 0) {
  //                   status = true;
  //                 } else if (value == 1) {
  //                   status = false;
  //                 }
  //                 // toggleValue = value;
  //                 _alarmStatus = status;
  //                 // shared preferences toggle
  //                 toggle.saveAlarmToggle(value);
  //               });
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // 고온 경보 widget
  // Widget _highTempFormField(String title, String dic, var highTempController) {
  //   return Container(
  //     color: Color(0xffFFFFFF),
  //     height: Get.height * 0.08,
  //     width: Get.width,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(left: 15),
  //           child: Text(title,
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.black54)),
  //         ),
  //         Container(
  //           padding: EdgeInsets.only(right: 15),
  //           width: Get.width * 0.35,
  //           height: Get.height * 0.06,
  //           child: TextFormField(
  //             enabled: alarmToggleValue == 0 ? true : false,
  //             controller: alarmToggleValue == 1
  //                 ? _nullTextEditingController
  //                 : highTempController,
  //             // highTempController
  //             decoration: InputDecoration(
  //               hintText: ' 온도를 입력하세요',
  //               hintStyle: TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.normal,
  //                   color: Colors.black38),
  //             ),
  //             onChanged: (text) {
  //               // setState(() {});
  //               print('$title : $text');
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // 저온 경보 widget
  // Widget _lowTempFormField(String title, String dic, var lowTempController) {
  //   return Container(
  //     color: Color(0xffFFFFFF),
  //     height: Get.height * 0.08,
  //     width: Get.width,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(left: 15),
  //           child: Text(title,
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.black54)),
  //         ),
  //         Container(
  //           padding: EdgeInsets.only(right: 15),
  //           width: Get.width * 0.35,
  //           height: Get.height * 0.06,
  //           child: TextFormField(
  //             enabled: alarmToggleValue == 0 ? true : false,
  //             controller: alarmToggleValue == 1
  //                 ? _nullTextEditingController
  //                 : lowTempController,
  //             // lowTempController,
  //             decoration: InputDecoration(
  //               hintText: ' 온도를 입력하세요',
  //               hintStyle: TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.normal,
  //                   color: Colors.black38),
  //             ),
  //             onChanged: (text) {
  //               // setState(() {});
  //               print('$title : $text');
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // SITE CONFIG SET widget
  // Widget _siteConfigSetButton() {
  //   return Container(
  //     height: Get.height * 0.07,
  //     padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
  //     child: new ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         primary: Color(0xff4cbb8b),
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20)), // background
  //       ),
  //       child: new Text(
  //         '설정 저장',
  //         style: TextStyle(
  //             color: Color(0xffFFFFFF),
  //             fontSize: 18,
  //             fontWeight: FontWeight.w500),
  //       ),
  //       onPressed: () async {
  //         _updateData(_alarmStatus, _highTextEditController.text,
  //             _lowTextEditController.text, _setTimer);
  //         _connectMqtt
  //             .setConfig(
  //                 _alarmStatus,
  //                 _highTextEditController.text,
  //                 _lowTextEditController.text,
  //                 _setTimer,
  //                 '/sf/$siteId/req/cfg',
  //                 '/sf/$siteId/req/cfg')
  //             .then((value) => Get.defaultDialog(
  //                 backgroundColor: Colors.white,
  //                 title: '설정 완료',
  //                 middleText: '설정이 완료 되었습니다.',
  //                 textCancel: '확인'));
  //       },
  //     ),
  //   );
  // }

  // // 타이머 시간 설정 widget
  // var timerDropdownValue = siteConfig.set_timer;
  // Widget _timerDropDownButtons(var name) {
  //   return Container(
  //     color: Color(0xffFFFFFF),
  //     height: Get.height * 0.08,
  //     width: Get.width,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(left: 15),
  //           child: Text(name,
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.black54)),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(right: 10),
  //           child: DropdownButton<String>(
  //             value: timerDropdownValue,
  //             icon: const Icon(Icons.arrow_drop_down,
  //                 color: Colors.black, size: 30),
  //             style: const TextStyle(color: Colors.black54),
  //             underline: Container(
  //               height: 2,
  //               color: Colors.black26,
  //             ),
  //             onChanged: (value) {
  //               setState(() {
  //                 timerDropdownValue = value!.toString();
  //                 _setTimer = value;
  //               });
  //             },
  //             items: <String>[
  //               '0',
  //               '30',
  //               '60',
  //               '90',
  //               '120',
  //               '150',
  //               '180',
  //               '210',
  //               '240'
  //             ].map<DropdownMenuItem<String>>((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(
  //                   value,
  //                   style: TextStyle(
  //                       color: Colors.black38,
  //                       fontWeight: FontWeight.normal,
  //                       fontSize: 13),
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // // site name에 맞는 site id 가져오기
  // Future<dynamic> getSiteId(var siteNames) async {
  //   print('##### [SettingPage] siteNames는  : ${siteNames}');
  //   final getSiteId = await dio.post('$url/$userId/sites/$siteNames');
  //   stream.siteId = getSiteId.data;
  //   print('##### [SettingPage] Site Id는  : ${stream.siteId}');
  //   Get.offAllNamed('/home');
  // }

  // // 사이트 설정 widget
  // Widget _sitesDropDownButtons(var name) {
  //   return Container(
  //     color: Color(0xffFFFFFF),
  //     height: Get.height * 0.08,
  //     width: Get.width,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(left: 15),
  //           child: Text(name,
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.black54)),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(right: 10),
  //           child: DropdownButton<String>(
  //             value: sitesDropdownValue,
  //             icon: const Icon(Icons.arrow_drop_down,
  //                 color: Colors.black, size: 30),
  //             style: const TextStyle(color: Colors.black54),
  //             underline: Container(
  //               height: 2,
  //               color: Colors.black26,
  //             ),
  //             onChanged: (String? newValue) {
  //               if (newValue != sitesDropdownValue) {
  //                 showAlertDialog(context, newValue);
  //               }
  //             },
  //             items: stream.siteNames
  //                 .map<DropdownMenuItem<String>>((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(
  //                   value,
  //                   style: TextStyle(
  //                       color: Colors.black38,
  //                       fontWeight: FontWeight.normal,
  //                       fontSize: 13),
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // // 사이트 설정 완료 후 확인 알림
  // showAlertDialog(BuildContext context, var siteName) {
  //   // set up the buttons
  //   Widget cancelButton = FlatButton(
  //     child: Text("취소"),
  //     onPressed: () {
  //       Get.back();
  //     },
  //   );
  //   Widget continueButton = FlatButton(
  //     child: Text("확인"),
  //     onPressed: () {
  //       setState(() {
  //         stream.sitesDropdownValue = siteName;
  //         print("[setting page] siteName은 $siteName");
  //         getSiteId(stream.sitesDropdownValue);
  //       });
  //     },
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("사이트 설정 확인"),
  //     content: Text("사이트 설정을 하시겠습니까?"),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
