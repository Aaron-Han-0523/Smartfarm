import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plms_start/dio/logout_dio.dart';
import 'package:plms_start/mqtt/mqtt.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../globals/stream.dart' as stream;
import 'package:plms_start/globals/siteConfig.dart' as siteConfig;

/*
* name : Setting Page
* description : setting page
* writer : walter/mark
* create date : 2021-09-30
* last update : 2021-01-13
* */

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  // logout API
  Logout _logout = Logout();

  // MQTT class
  MqttClass _mqttClass = MqttClass();

  // TextEditing Controller
  final _highTextEditController = TextEditingController();
  final _lowTextEditController = TextEditingController();

  //global key
  var _setTimer = siteConfig.set_timer;
  bool _switchStatus = siteConfig.status_alarm;
  var _lowTemp = siteConfig.low_temp;
  var _highTemp = siteConfig.high_temp;

  @override
  void initState() {
    print('저장된 global key의 alarm Status는 : $_switchStatus');
    // mqttConnect;
  }

  @override
  void dispose() {
    _highTextEditController.dispose();
    _lowTextEditController.dispose();
    super.dispose();
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
          onPressed: (){
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
            child: Text(stream.sitesDropdownValue,
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
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
          _highTempFormField('고온 경보 (°C)', "alarm_high_temp", _highTextEditController),
          SizedBox(height: Get.height * 0.02),
          _lowTempFormField('저온 경보 (°C)', "alarm_low_temp",_lowTextEditController),
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

  bool status = false;

  Widget _swichWidget(String name) {
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
              // initialLabelIndex:
              // stream.pumpStatus[index] == 0 ? 1 : 0,
              totalSwitches: 2,
              labels: ['ON', 'OFF'],
              radiusStyle: true,
              onToggle: (value) async {
                if (value == 0) {
                  status = true;
                } else if (value == 1) {
                  status = false;
                }
                _switchStatus = status;
                print('global key의 alarm Status는 : $_switchStatus');
                // _mqttClass.configSet("alarm_en", _switchStatus, '/sf/e0000001/req/cfg', '/sf/e0000001/req/cfg');
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
              controller: highTempController,
              decoration: InputDecoration(
                hintText: ' 온도를 입력하세요',
                hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black38),
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
              controller: lowTempController,
              decoration: InputDecoration(
                  hintText: ' 온도를 입력하세요',
                  hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black38),
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
      padding: EdgeInsets.fromLTRB(15,0,15,0),
      child: new ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff4cbb8b),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),// background
        ),
        child: new Text(
          'SET CONIG(저장)',
          style: TextStyle(
              color: Color(0xffFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        onPressed: () async {
            _mqttClass.setConfig(_switchStatus, _highTextEditController.text, _lowTextEditController.text, _setTimer, '/sf/e0000001/req/cfg', '/sf/e0000001/req/cfg');
        },
      ),
    );
  }


  String timerDropdownValue = '30';
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
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
              style: const TextStyle(color: Colors.black54),
              underline: Container(
                height: 2,
                // width: 30,
                color: Colors.black26,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  timerDropdownValue = newValue!;
                  _setTimer = newValue;
                  // _mqttClass.configSet("watering_timer", newValue, '/sf/e0000001/res/cfg', '/sf/e0000001/res/cfg');
                  print('타이머 시간은 : $name : $_setTimer');
                });
              },
              items: <String>[
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
                  child: Text(value, style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),),
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
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
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
                  child: Text(value, style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
