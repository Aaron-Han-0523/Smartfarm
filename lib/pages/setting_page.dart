import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:edgeworks/dio/logout_dio.dart';
import 'package:edgeworks/mqtt/mqtt.dart';
import 'package:edgeworks/pages/components/getx_controller/controller.dart';
import 'package:edgeworks/pages/soilControl_page.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../globals/stream.dart' as stream;
import 'package:edgeworks/globals/siteConfig.dart' as siteConfig;

/*
* name : Setting Page
* description : setting page
* writer : walter/mark
* create date : 2021-09-30
* last update : 2021-01-14
* */

var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = 'test';
var siteId = 'sid';

// dio APIs

Dio dio = Dio();

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // real time data
  final realTimeController = Get.put(CounterController());

  // logout API
  Logout _logout = Logout();

  // MQTT class
  MqttClass _mqttClass = MqttClass();

  // TextEditing Controller
  final _highTextEditController =
      TextEditingController(text: siteConfig.high_temp==''?null:siteConfig.high_temp);
  final _lowTextEditController =
      TextEditingController(text: siteConfig.low_temp==''?null:siteConfig.low_temp);

  //global key
  bool status = false;
  var _setTimer = siteConfig.set_timer;
  bool _alarmStatus = siteConfig.status_alarm;
  var _lowTemp = siteConfig.low_temp;
  var _highTemp = siteConfig.high_temp;
  var _waterTimer = stream.watering_timer;
  var siteDropdown =
      stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;

  @override
  void initState() {
    print('저장된 global key의 alarm Status는 : $_alarmStatus');
    print('저장된 global key의 stream alarm은 : ${stream.alarm_en}');
    // realTimeController.getConfig();
    _mqttClass.getSiteConfig();
  }

  @override
  void dispose() {
    _highTextEditController.dispose();
    _lowTextEditController.dispose();
    super.dispose();
  }

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
    // var response = await dio.get('$api/$userId/site/$siteId/settings');
    print('!!!!!!!!!!!!!!!!!');
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F9FC),
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xff222222)),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            // 로그아웃
            child: IconButton(
              icon: Icon(Icons.login_rounded, color: Color(0xff222222)),
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
              style: TextStyle(color: Color(0xff2E8953), fontSize: 18),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(siteDropdown,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, top: 20, bottom: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('경보 설정',
                    style: TextStyle(fontSize: 15, color: Colors.black54))),
          ),
          _swichWidget('경보 활성화'),
          SizedBox(height: Get.height * 0.02),
          _highTempFormField(
              '고온 경보 (°C)', "alarm_high_temp", _highTextEditController),
          SizedBox(height: Get.height * 0.02),
          _lowTempFormField(
              '저온 경보 (°C)', "alarm_low_temp", _lowTextEditController),
          const Divider(
            height: 30,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Colors.black26,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, top: 20, bottom: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '관수 타이머 설정',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                )),
          ),
          _timerDropDownButtons('타이머 시간'),
          SizedBox(height: Get.height * 0.02),
          _sitesDropDownButtons('사이트 설정'),
          SizedBox(height: Get.height * 0.15),
          _siteConfigSetButton()
        ],
      ),
    );
  }

  // bool status = false;
  List<String> labelName = ['ON', 'OFF'];
  var selectedLabel = '';
  int initialIndex = siteConfig.status_alarm == true ? 0 : 1;

  Widget _swichWidget(String name) {
    // int initialIndex = stream.alarm_en == true ? 0 : 1;
    return Container(
      color: Color(0xffFFFFFF),
      height: Get.height * 0.08,
      width: Get.width,
      // decoration: _decoration(Color(0xffFFFFFF)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ToggleSwitch(
              fontSize: 12,
              minWidth: 60.0,
              cornerRadius: 80.0,
              activeBgColors: [
                [Color(0xffe3fbed)],
                [Color(0xfff2f2f2)]
              ],
              activeFgColor: Color(0xff222222),
              inactiveBgColor: Color(0xffFFFFFF),
              inactiveFgColor: Color(0xff222222),
              initialLabelIndex: initialIndex,
              // stream.alarm_en == true ? 0 : 1,
              // stream.pumpStatus[index] == 0 ? 1 : 0,
              totalSwitches: 2,
              labels: labelName,
              radiusStyle: true,
              onToggle: (value) async {
                setState(() {
                  initialIndex = value;
                  if (value == 0) {
                    status = true;
                    // stream.alarm_en == true ? 0 : 1;
                    print(value);
                    print(status);
                  } else if (value == 1) {
                    status = false;
                    // stream.alarm_en == true ? 0 : 1;
                    print(value);
                    print(status);
                  }
                  _alarmStatus = status;
                });
                // if (value == 0) {
                //   status = true;
                // } else if (value == 1) {
                //   status = false;
                // }
                // _alarmStatus = status;
                print('global key의 alarm Status는 : $_alarmStatus');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _highTempFormField(String title, String dic, var highTempController) {
    return Container(
      color: Color(0xffFFFFFF),
      height: Get.height * 0.08,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),
          ),
          Container(
            padding: EdgeInsets.only(right: 15),
            width: Get.width * 0.35,
            height: Get.height * 0.06,
            child: TextFormField(
              enabled: status,
              controller: highTempController,
              // status==false?highTempController=='':highTempController,
    // highTempController
    // status==false?siteConfig.high_temp=='':siteConfig.high_temp
              decoration: InputDecoration(
                hintText: ' 온도를 입력하세요',
                hintStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.black38),
                // border: OutlineInputBorder(),
                // suffixIcon: IconButton(
                //   icon: const Icon(Icons.subdirectory_arrow_left),
                //   onPressed: () {
                //     _highTemp = highTempController.text;
                //     print('high temp 는? $_highTemp');
                //     // _mqttClass.configSet(dic, controller.text, '/sf/e0000001/req/cfg', '/sf/e0000001/req/cfg');
                //   }
                // )
              ),
              onChanged: (text) {
                // setState(() {});
                print('$title : $text');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _lowTempFormField(String title, String dic, var lowTempController) {
    return Container(
      color: Color(0xffFFFFFF),
      height: Get.height * 0.08,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),
          ),
          Container(
            padding: EdgeInsets.only(right: 15),
            width: Get.width * 0.35,
            height: Get.height * 0.06,
            child: TextFormField(
              enabled: status,
              controller: lowTempController,
              decoration: InputDecoration(
                hintText: ' 온도를 입력하세요',
                hintStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.black38),
                // border: OutlineInputBorder(),
                // suffixIcon: IconButton(
                //     icon: const Icon(Icons.subdirectory_arrow_left),
                //     onPressed: () {
                //       _lowTemp = lowTempController.text;
                //       print('low temp 는? $_lowTemp');
                //       // _mqttClass.configSet(dic, controller.text, '/sf/e0000001/req/cfg', '/sf/e0000001/req/cfg');
                //     }
                // )
              ),
              onChanged: (text) {
                // setState(() {});
                print('$title : $text');
              },
            ),
          ),
        ],
      ),
    );
  }

  // SITE CONFIG SET widget
  Widget _siteConfigSetButton() {
    return Container(
      height: Get.height * 0.07,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: new ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff4cbb8b),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)), // background
        ),
        child: new Text(
          '설정 저장',
          style: TextStyle(
              color: Color(0xffFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        onPressed: () async {
          _updateData(_alarmStatus, _highTextEditController.text,
              _lowTextEditController.text, _setTimer);
          _mqttClass
              .setConfig(
                  _alarmStatus,
                  _highTextEditController.text,
                  _lowTextEditController.text,
                  _setTimer,
                  '/sf/e0000001/req/cfg',
                  '/sf/e0000001/req/cfg')
              .then((value) => Get.defaultDialog(
                  backgroundColor: Colors.white,
                  title: '설정 완료',
                  middleText: '설정이 완료 되었습니다.',
                  textCancel: '확인'));
          print('hi!!!!!!!!!!!');
        },
      ),
    );
  }

  // var timerDropdownValue = '${stream.watering_timer}';
  var timerDropdownValue = siteConfig.set_timer;
  Widget _timerDropDownButtons(var name) {
    return Container(
      color: Color(0xffFFFFFF),
      height: Get.height * 0.08,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(name,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: DropdownButton<String>(
              value: timerDropdownValue,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Colors.black, size: 30),
              style: const TextStyle(color: Colors.black54),
              underline: Container(
                height: 2,
                // width: 30,
                color: Colors.black26,
              ),
              onChanged: (value) {
                setState(() {
                  timerDropdownValue = value!.toString();
                  _setTimer = value;
                  print('타이머 시간은 : $name : $_setTimer');
                });
              },
              items: <String>[
                '0',
                '30',
                '60',
                '90',
                '120',
                '150',
                '180',
                '210',
                '240'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.normal,
                        fontSize: 13),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // decoration (with box shadow)
  BoxDecoration _decoration(dynamic color) {
    return BoxDecoration(
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 2,
          offset: Offset(3, 5), // changes position of shadow
        ),
      ],
    );
  }

  String sitesDropdownValue =
      stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;

  Widget _sitesDropDownButtons(var name) {
    return Container(
      color: Color(0xffFFFFFF),
      height: Get.height * 0.08,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(name,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: DropdownButton<String>(
              value: sitesDropdownValue,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Colors.black, size: 30),
              style: const TextStyle(color: Colors.black54),
              underline: Container(
                height: 2,
                color: Colors.black26,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  sitesDropdownValue = newValue!;
                  print('$name : $newValue');
                  stream.sitesDropdownValue = sitesDropdownValue;
                });
              },
              items: <String>[
                'EdgeWorks',
                'Jsoftware',
                'smartFarm',
                'Project',
                'Nodejs',
                'Flutter',
                'MySQL',
                'AWS'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.normal,
                        fontSize: 13),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
