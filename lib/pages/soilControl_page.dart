// necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
// env
import 'package:flutter_dotenv/flutter_dotenv.dart';
// mqtt
import 'package:edgeworks/utils/mqtt/mqtt.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// dio
import 'package:dio/dio.dart';
// getX controller
import '../utils/getX_controller/controller.dart';
// global
import '../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

/*
* name : Soil Control Page
* description : Soil Control Page
* writer : sherry
* create date : 2021-12-24    
* last update : 2022-02-03
* */

// globalKey
var innerTemp = stream.temp_1; // 내부온도
var extTemp = stream.exttemp_1; // 외부온도
var soilTemp = stream.soiltemp_1; // 토양온도
var innerHumid = stream.humid_1; // 내부습도
var extHumid = stream.humid_1; // 외부습도
var soilHumid = stream.soilhumid_1; // 토양습도
var pump_1 = stream.pump_1; // pump_1의 on/off
var pump_2 = stream.pump_2; // pump_2의 on/off

List pumps = stream.pumps;
List pumpName = stream.pump_name;
List valves = stream.valves;
List valveName = stream.valve_name;

List sensorId = stream.sensor_id;

// APIs
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

// weather status
var temp = int.parse(extTemp);

// MQTT
ConnectMqtt _connectMqtt = ConnectMqtt();
String statusText = "Status Text";
bool isConnected = false;
final MqttServerClient client = MqttServerClient('14.46.231.48', '');

class SoilControlPage extends StatefulWidget {
  SoilControlPage({Key? key}) : super(key: key);

  @override
  _SoilControlPageState createState() => _SoilControlPageState();
}

class _SoilControlPageState extends State<SoilControlPage> {
  @override
  void initState() {
    super.initState();
  }

  // siteDropdown button global variable
  var siteDropdown = stream.sitesDropdownValue == ''
      ? '${stream.siteNames[0]}'
      : stream.sitesDropdownValue;

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                toolbarHeight: Get.height * 0.29,
                backgroundColor: Color(0xffF5F9FC),
                title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Farm in Earth',
                          style:
                              TextStyle(color: Color(0xff2E8953), fontSize: 22),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(siteDropdown,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17)),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      _weather(),
                    ]),
              ),
              SliverList(
                // itemExtent: 3.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                        color: Color(0xffF5F9FC),
                        child: Column(
                          children: [
                            _pumpsControl(),
                            _valvesControl(),
                          ],
                        ));
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
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

  // 날씨 위젯
  Widget _weather() {
    final controller = Get.put(CounterController());
    return Obx(
      () => Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _mainMonitoring("맑음", "${controller.extTemp.value}", "7860"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Container(
                  height: Get.height * 0.13,
                  width: Get.width * 0.425,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _subMonitoring(
                          'assets/images/icon_temp.png',
                          "내부 온도",
                          "${controller.innerTemp.value}" + "°C",
                          'assets/images/icon_humid.png',
                          "내부 습도",
                          "${controller.innerHumid.value}" + "%"),
                    ],
                  ),
                ),
              ),
              Container(
                height: Get.height * 0.13,
                width: Get.width * 0.425,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _subMonitoring(
                        'assets/images/icon_soiltemp.png',
                        "토양 온도",
                        "${controller.soilTemp.value}°C",
                        'assets/images/icon_soilhumid.png',
                        "토양 습도",
                        "${controller.soilHumid.value}%"),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  // 펌프 제어
  Widget _pumpsControl() {
    return Column(children: [
      _fromLTRBPadding(
        child: Container(
          decoration: _decoration(Color(0xff2E8953)),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: IgnorePointer(
              ignoring: stream.pumps.length == 0 ? true : false,
              child: ExpansionTile(
                initiallyExpanded: true,
                title: _edgeLeftPadding(
                  15,
                  child: Text('관수 펌프 제어',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffFFFFFF))),
                ),
                textColor: Colors.white,
                collapsedTextColor: Colors.white,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                // tilePadding: EdgeInsets.all(8.0),
                children: <Widget>[
                  _topBottomPadding(
                    15,
                    15,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        primary: false,
                        shrinkWrap: true,
                        itemCount: stream.pumpStatus.length,
                        itemBuilder: (BuildContext context, var index) {
                          return _switchToggle(
                              index,
                              '${stream.pump_name[index]}',
                              stream.pumpStatus,
                              'pump',
                              'pump_${index + 1}',
                              'pump_id',
                              'pump_action',
                              '$url/$userId/site/$siteId/controls/pumps/pump_${index + 1}');
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  // 밸브 제어
  Widget _valvesControl() {
    return Column(children: [
      _fromLTRBPadding(
        child: Container(
          decoration: _decoration(Color(0xff2E8953)),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: IgnorePointer(
              ignoring: stream.valves.length == 0 ? true : false,
              child: ExpansionTile(
                title: _edgeLeftPadding(
                  15,
                  child: Text('밸브 제어',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffFFFFFF))),
                ),
                textColor: Colors.white,
                collapsedTextColor: Colors.white,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                // tilePadding: EdgeInsets.all(8.0),
                children: <Widget>[
                  _topBottomPadding(
                    15,
                    15,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        primary: false,
                        shrinkWrap: true,
                        itemCount: stream.valveStatus.length,
                        itemBuilder: (BuildContext context, var index) {
                          return _switchToggle(
                              index,
                              '${stream.valve_name[index]}',
                              stream.valveStatus,
                              'valve',
                              'valve_${index + 1}',
                              'valve_id',
                              'valve_action',
                              '$url/$userId/site/$siteId/controls/valves/valve_${index + 1}');
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

// 펌프/밸브 토글 상태 제어
Widget _switchToggle(var index, var text, var streamStatus, var action,
    var type, var typeIdText, var typeActionText, var putUrl) {
  return _marginContainer(
    height: Get.height * 0.09,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _edgeLeftPadding(
          20,
          child: Text(text,
              style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: 15,
                  fontWeight: FontWeight.normal)),
        ),
        _edgeRightPadding(
          10,
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
            initialLabelIndex: streamStatus[index],
            // streamStatus[index] == 1 ? 1 : 0,
            totalSwitches: 2,
            labels: ['ON', 'OFF'],
            radiusStyle: true,
            onToggle: (value) async {
              String switchStatus = '';

              if (value == 0) {
                switchStatus = 'on';
                streamStatus[index] = 0;
              } else if (value == 1) {
                switchStatus = 'off';
                streamStatus[index] = 1;
              }
              var typeId = type;
              _connectMqtt.setControl(
                  'did',
                  "${index + 1}",
                  'dact',
                  switchStatus,
                  '/sf/$siteId/req/$action',
                  '/sf/$siteId/req/$action');
              var data = {
                'uid': userId,
                'sid': siteId,
                typeIdText: typeId,
                typeActionText: value,
              };
              final putType = await dio.put(putUrl, data: data);
              print('[soilControl page] 성공 여부 확인 $putType');
              // 데이터 업데이트 시 결과1/ 업데이트가 이미 되어있는 상태일 경우 0
            },
          ),
        ),
      ],
    ),
    decoration: _decorations(),
  );
}

// 모니터링
Widget _mainMonitoring(String weather, String temperNumber, String soilNumber) {
  final controller = Get.put(CounterController());
  return Container(
    height: Get.height * 0.07,
    width: Get.width * 0.9,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      controller.getWeather(stream.exttemp_1),
      controller.getWeatherStatus(stream.exttemp_1),
      Text(" 토양 전도도 $soilNumber cm/μs",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff222222))),
    ]),
    decoration: _decoration(Color(0xffFFFFFF)),
  );
}

// 내부/토양 모니터링
Widget _subMonitoring(dynamic icon, String mainText, String _mainText,
    dynamic _icon, String subText, String _subText) {
  return Container(
      height: Get.height * 0.09,
      width: Get.width * 0.425,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(icon, color: Color(0xff222222), scale: 5),
              Text(mainText,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              Text(_mainText,
                  style: _textStyle(Color(0xff222222), FontWeight.w600, 15)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(_icon, color: Color(0xff222222), scale: 5),
              Text(subText,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              Text(_subText,
                  style: _textStyle(Color(0xff222222), FontWeight.w600, 15)),
            ],
          ),
        ],
      ),
      decoration: _decoration(Color(0xffFFFFFF)));
}

// TextStyle widget
TextStyle _textStyle(dynamic _color, dynamic _weight, double _size) {
  return TextStyle(color: _color, fontWeight: _weight, fontSize: _size);
}

// BoxDecoration (with box shadow)
BoxDecoration _decoration(dynamic color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2,
        offset: Offset(3, 5), // changes position of shadow
      ),
    ],
  );
}

// BoxDecoration widget (without box shadow)
BoxDecoration _decorations() {
  return BoxDecoration(
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(20),
  );
}

// Padding widget
Padding _fromLTRBPadding({child}) {
  return Padding(padding: new EdgeInsets.fromLTRB(15, 10, 15, 5), child: child);
}

Padding _edgeLeftPadding(double left, {child}) {
  return Padding(padding: new EdgeInsets.only(left: left), child: child);
}

Padding _edgeRightPadding(double right, {child}) {
  return Padding(padding: new EdgeInsets.only(right: right), child: child);
}

Padding _topBottomPadding(double top, double bottom, {child}) {
  return Padding(
      padding: new EdgeInsets.only(top: top, bottom: bottom), child: child);
}

Container _marginContainer({child, dynamic height, decoration}) {
  return Container(
    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
    height: height,
    child: child,
    decoration: decoration,
  );
}
