import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:edgeworks/mqtt/mqtt.dart';
import 'package:edgeworks/globals/toggle.dart' as toggle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dio/dio.dart';

import '../globals/stream.dart' as stream;
import 'components/getx_controller/controller.dart';

/*
* name : Environment Page
* description : Environment Control Page
* writer : mark
* create date : 2021-12-24
* last update : 2021-01-25
* */

// MQTT class
MqttClass _mqttClass = MqttClass();

// Dio
var dio = Dio();

//Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = 'test';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// globalKey
var innerTemp = stream.temp_1; // 내부온도
var extTemp = stream.exttemp_1; // 외부온도
var soilTemp = stream.soiltemp_1; // 토양온도
var innerHumid = stream.humid_1; // 내부습도
var extHumid = stream.humid_1; // 외부습도
var soilHumid = stream.soilhumid_1; // 토양습도
var motor_1 = stream.motor_1;
var motor_2 = stream.motor_2;
var motor_3 = stream.motor_3;
var motor_4 = stream.motor_4;
var motor_5 = stream.motor_5;
var motor_6 = stream.motor_6;

List sideMotors = stream.sideMotors;
List topMotors = stream.topMotors;
List motorName = stream.top_motor_name;
List switchId = stream.switch_id;

List sideStatus = stream.sideMotorStatus;
List topStatus = stream.topMotorStatus;

int? getToggleStatus;
int? getTopToggleStatus;
int? allSideToggleInit;
int? allTopToggleInit;

// expanded tile
bool _customTileExpanded = false;

// temp
var temp = int.parse(extTemp);

// Update DB function
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
  print('### 모터 타입 변경 완료 : $response');
}

Future<void> _updateAllMotorData(var motorAction, var updateMotorType) async {
  var params = {
    'motor_action': motorAction,
  };
  var response = await dio.put(
      '$url/$userId/site/$siteId/controls/$updateMotorType/motors',
      data: params);
  print('### 사이드 전체 모터 타입 변경 완료 : $response');
}

class EnvironmentPage extends StatefulWidget {
  const EnvironmentPage({Key? key}) : super(key: key);

  @override
  _EnvironmentState createState() => _EnvironmentState();
}

class _EnvironmentState extends State<EnvironmentPage> {
  void initState() {
    super.initState();
  }

  var siteDropdown =
      stream.sitesDropdownValue == '' ? '${stream.siteNames[0]}' : stream.sitesDropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff2E6645),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                toolbarHeight: Get.height * 0.45,
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
                      SizedBox(height: Get.height * 0.05),
                      MyWeather(),
                    ]),
              ),
              SliverList(
                  // itemExtent: 3.0,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                            child: Column(
                              children: [
                                SideMotor(),
                                TopMotor(),
                                EtcMotor(),
                              ],
                            ),
                          );
                    },
                    childCount: 1,
                  ),
                ),
            ],
          ),
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

// 날씨
class MyWeather extends StatefulWidget {
  const MyWeather({Key? key}) : super(key: key);

  @override
  State<MyWeather> createState() => _MyWeatherState();
}

class _MyWeatherState extends State<MyWeather> {
  @override
  void initState() {
    // var innerTemp = stream.temp_1; // 내부온도
    // var extTemp = stream.exttemp_1; // 외부온도
    // var soilTemp = stream.soiltemp_1; // 토양온도
    // var innerHumid = stream.humid_1; // 내부습도
    // var extHumid = stream.humid_1; // 외부습도
    // var soilHumid = stream.soilhumid_1; // 토양습도
    print("innerTemp");
    print(innerTemp);
    print(stream.temp_1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounterController());
    return Obx(
      () => Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _mainMonitoring(),
          SizedBox(height: Get.height * 0.03),
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
                  decoration: _decoration(Color(0xffFFFFFF)),
                ),
              ),
              Container(
                height: Get.height * 0.13,
                width: Get.width * 0.425,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _subMonitoring(
                        'assets/images/icon_wind.png',
                        "풍향",
                        // "${controller.soilTemp.value}°C",
                        "남동향",
                        'assets/images/icon_windsp.png',
                        "풍속",
                        // "${controller.soilHumid.value}%"),
                        "12.5m/s"),
                  ],
                ),
                decoration: _decoration(Color(0xffFFFFFF)),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

// 현재 상태 모니터링
Widget _mainMonitoring() {
  final controller = Get.put(CounterController());
  return Container(
        height: Get.height * 0.1,
        width: Get.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            controller.getWeather(stream.exttemp_1),
            // temp == 20 && extHumid=='5'? ImageIcon(AssetImage('assets/images/icon_shiny.png'), color: Color(0xff222222), size: 40): innerHumid=='50'? ImageIcon(AssetImage('assets/images/icon_shiny.png'), color: Color(0xff222222), size: 40):,
            controller.getWeatherStatus(stream.exttemp_1),
            Image.asset('assets/images/icon_env_arrow_up.png',
                color: Color(0xffffd5185), scale: 3),
            Text("07:32",
                style: _textStyle(Color(0xff222222), FontWeight.w600, 16)),
            Image.asset('assets/images/icon_env_arrow_down.png',
                color: Color(0xfff656565), scale: 3),
            Text("18:08",
                style: _textStyle(Color(0xff222222), FontWeight.w600, 16)),
          ],
        ),
        decoration: _decoration(Color(0xffFFFFFF)));
}

// 내/외부 모니터링
Widget _subMonitoring(dynamic icon, String mainText, String _mainText,
    dynamic _icon, String subText, String _subText) {
  return Container(
      height: Get.height * 0.13,
      width: Get.width * 0.425,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 5),
                  child: Image.asset(icon, color: Color(0xff222222), scale: 5)),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 20),
                child: Text(mainText,
                    style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              ),
              Text(_mainText,
                  style: _textStyle(Color(0xff222222), FontWeight.w600, 15)),
            ],
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 15, right: 5),
                  child: Image.asset(_icon, color: Color(0xff222222), scale: 5)),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 20),
                child: Text(subText,
                    style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              ),
              Text(_subText,
                  style: _textStyle(Color(0xff222222), FontWeight.w600, 15)),
            ],
          ),
        ],
      ),
      decoration: _decoration(Color(0xffFFFFFF)));
}

class SideMotor extends StatefulWidget {
  const SideMotor({Key? key}) : super(key: key);

  @override
  _SideMotorState createState() => _SideMotorState();
}

class _SideMotorState extends State<SideMotor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _fromLTRBPadding(
          child: Container(
            decoration: _decoration(Color(0xff2E8953)),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                trailing: Icon(_customTileExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded),
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _customTileExpanded = expanded;
                  });
                },
                title: _edgeLeftPadding(
                  15,
                  child: Text('측창 개폐기 제어',
                      style:
                          _textStyle(Color(0xffFFFFFF), FontWeight.w500, 20)),
                ),
                children: <Widget>[
                  _topBottomPadding(
                    15,
                    15,
                    child: Column(
                      children: [
                        _allSideToggleSwitch('측창(전체)', 'side', 'test', 'sid'),
                        _sideControlSwitch()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _allSideToggleSwitch(
      String text, var positions, var userIds, var siteIds) {
    return _marginContainer(
      height: Get.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _edgeLeftPadding(20,
              child: Text(text,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15))),
          _edgeRightPadding(
            10,
            child: ToggleSwitch(
              fontSize: 12,
              minWidth: 65.0,
              cornerRadius: 80.0,
              activeBgColors: [
                [Color(0xffe3fbed)],
                [Color(0xffFFD6D6)],
                [Color(0xfff2f2f2)]
              ],
              activeFgColor: Color(0xff222222),
              inactiveBgColor: Color(0xffFFFFFF),
              inactiveFgColor: Color(0xff222222),
              initialLabelIndex: getToggleStatus,
              totalSwitches: 3,
              labels: ['전체열림', '전체정지', '전체닫힘'],
              radiusStyle: true,
              onToggle: (value) async {
                getToggleStatus = value;
                String _switch = '';

                if (value == 0) {
                  setState(() {
                    for (int i = 0; i < sideStatus.length; i++,) {
                      sideStatus[i] = value;
                    }
                  });
                  _switch = 'open';
                }
                if (value == 1) {
                  _switch = 'stop';
                  setState(() {
                    for (int i = 0; i < sideStatus.length; i++,) {
                      sideStatus[i] = value;
                    }
                  });
                }
                if (value == 2) {
                  _switch = 'close';
                  setState(() {
                    for (int i = 0; i < sideStatus.length; i++,) {
                      sideStatus[i] = value;
                    }
                  });
                }
                print('toggle value는 : $value');
                print('toggle type은 : ${value.runtimeType}');
                print('value는 : $_switch');
                // mqtt
                _mqttClass.allSet(
                    'did',
                    stream.sideMotorId.length,
                    'dact',
                    _switch,
                    '/sf/$siteId/req/motor',
                    '/sf/$siteId/req/motor',
                    stream.sideMotorId);
                // DB 변동
                _updateAllMotorData(value, "side");
                // shared preferences
                toggle.saveAllSideToggle(value);
              },
            ),
          )
        ],
      ),
      decoration: _decorations(),
    );
  }

  Widget _sideControlSwitch() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: sideMotors.length,
        itemBuilder: (BuildContext context, int index) {
          return _marginContainer(
            height: Get.height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _edgeLeftPadding(20,
                    child: Text(
                        "${stream.side_motor_name[index]}", //${stream.sideMotors[0]['motor_name']
                        style: _textStyle(
                            Color(0xff222222), FontWeight.normal, 15))),
                _edgeRightPadding(
                  10,
                  child: ToggleSwitch(
                    fontSize: 12,
                    minWidth: 60.0,
                    cornerRadius: 80.0,
                    activeBgColors: [
                      [Color(0xffe3fbed)],
                      [Color(0xffFFD6D6)],
                      [Color(0xfff2f2f2)]
                    ],
                    activeFgColor: Color(0xff222222),
                    inactiveBgColor: Color(0xffFFFFFF),
                    inactiveFgColor: Color(0xff222222),
                    initialLabelIndex: sideStatus[index],
                    // stream.topMotors[index],
                    totalSwitches: 3,
                    labels: ['열림', '정지', '닫힘'],
                    radiusStyle: true,
                    onToggle: (value) async {
                      String _switch = '';

                      if (value == 0) {
                        _switch = 'open';
                        // stream.topMotors[index] = 0;
                      }
                      if (value == 1) {
                        _switch = 'stop';
                        // stream.topMotors[index] = 1;
                      }
                      if (value == 2) {
                        _switch = 'close';
                        // stream.topMotors[index] = 2;
                      }
                      print('### Motor${index + 1} toggle value는 : $value');
                      print(
                          '### Motor${index + 1} toggle type은 : ${value.runtimeType}');
                      print('### Motor${index + 1} value는 : $_switch');
                      print(
                          '### Motor name index 뽑기 : ${stream.sideMotors[0]['motor_name']}');
                      // MQTT 통신
                      _mqttClass.ctlSet(
                          'did',
                          "${stream.sideMotorId[index]}",
                          'dact',
                          _switch,
                          '/sf/$siteId/req/motor',
                          '/sf/$siteId/req/motor');
                      // DB 업데이트
                      _updateMotorData(
                          "${stream.side_motor_name[index]}",
                          "side",
                          "$value",
                          "side",
                          "${stream.side_motor_id[index]}"); // update를 하면 이름도 전부 update 됨 -> 해결 필요
                    },
                  ),
                )
              ],
            ),
            decoration: _decorations(),
          );
        });
  }
}

class TopMotor extends StatefulWidget {
  const TopMotor({Key? key}) : super(key: key);

  @override
  _TopMotorState createState() => _TopMotorState();
}

class _TopMotorState extends State<TopMotor> {
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

  @override
  void initState() {
    super.initState();
    getToggleStatus;
    getTopToggleStatus;
    getSideSharedPrefs();
    getTopSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return _fromLTRBPadding(
      child: Container(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            title: _edgeLeftPadding(
              15,
              child: Text('천창 개폐기 제어',
                  style: _textStyle(Color(0xffFFFFFF), FontWeight.w500, 20)),
            ),
            children: <Widget>[
              _topBottomPadding(
                15,
                15,
                child: Column(
                  children: [
                    _allTopToggleSwitch('천창(전체)', 'top', 'test', 'sid'),
                    _topControlSwitch()
                  ],
                ),
              )
            ],
          ),
        ),
        decoration: _decoration(Color(0xff2E8953)),
      ),
    );
  }

  //천장 개폐기 제어 전체
  Widget _allTopToggleSwitch(
      String text, var positions, var userIds, var siteIds) {
    return _marginContainer(
      height: Get.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _edgeLeftPadding(20,
              child: Text(text,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15))),
          _edgeRightPadding(
            10,
            child: ToggleSwitch(
              fontSize: 12,
              minWidth: 65.0,
              cornerRadius: 80.0,
              activeBgColors: [
                [Color(0xffe3fbed)],
                [Color(0xffFFD6D6)],
                [Color(0xfff2f2f2)]
              ],
              activeFgColor: Color(0xff222222),
              inactiveBgColor: Color(0xffFFFFFF),
              inactiveFgColor: Color(0xff222222),
              initialLabelIndex: getTopToggleStatus, // 상태 반영 안돼서 확인 필요함
              totalSwitches: 3,
              labels: ['전체열림', '전체정지', '전체닫힘'],
              radiusStyle: true,
              onToggle: (value) async {
                getTopToggleStatus = value;
                String _switch = '';

                if (value == 0) {
                  setState(() {
                    for (int i = 0; i < topStatus.length; i++,) {
                      topStatus[i] = 0;
                    }
                  });
                  _switch = 'open';
                }
                if (value == 1) {
                  _switch = 'stop';
                  setState(() {
                    for (int i = 0; i < topStatus.length; i++,) {
                      topStatus[i] = value;
                    }
                  });
                }
                if (value == 2) {
                  _switch = 'close';
                  setState(() {
                    for (int i = 0; i < topStatus.length; i++,) {
                      topStatus[i] = value;
                    }
                  });
                }
                print('toggle value는 : $value');
                print('toggle type은 : ${value.runtimeType}');
                print('value는 : $_switch');
                // mqtt
                _mqttClass.allSet(
                    'did',
                    topMotors.length,
                    'dact',
                    _switch,
                    '/sf/$siteId/req/motor',
                    '/sf/$siteId/req/motor',
                    stream.topMotorId);
                // DB 변동
                _updateAllMotorData(value, "top");
                // shared preferencs
                toggle.saveAllTopToggle(value);
              },
            ),
          )
        ],
      ),
      decoration: _decorations(),
    );
  }

  // 천창 개폐기 제어
  Widget _topControlSwitch() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: topMotors.length,
        itemBuilder: (BuildContext context, int index) {
          return _marginContainer(
            height: Get.height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _edgeLeftPadding(20,
                    child: Text(
                        "${stream.top_motor_name[index]})", //DB에 있는 motor_name 반영
                        style: _textStyle(
                            Color(0xff222222), FontWeight.normal, 15))),
                _edgeRightPadding(
                  10,
                  child: ToggleSwitch(
                    fontSize: 12,
                    minWidth: 60.0,
                    cornerRadius: 80.0,
                    activeBgColors: [
                      [Color(0xffe3fbed)],
                      [Color(0xffFFD6D6)],
                      [Color(0xfff2f2f2)]
                    ],
                    activeFgColor: Color(0xff222222),
                    inactiveBgColor: Color(0xffFFFFFF),
                    inactiveFgColor: Color(0xff222222),
                    initialLabelIndex: stream.topMotorStatus[index],
                    // stream.topMotors[index],
                    totalSwitches: 3,
                    labels: ['열림', '정지', '닫힘'],
                    radiusStyle: true,
                    onToggle: (value) async {
                      String _switch = '';

                      if (value == 0) {
                        _switch = 'open';
                        // stream.topMotors[index] = 0;
                      }
                      if (value == 1) {
                        _switch = 'stop';
                        // stream.topMotors[index] = 1;
                      }
                      if (value == 2) {
                        _switch = 'close';
                        // stream.topMotors[index] = 2;
                      }
                      print('### Motor${index + 1} toggle value는 : $value');
                      print(
                          '### Motor${index + 1} toggle type은 : ${value.runtimeType}');
                      print('### Motor${index + 1} value는 : $_switch');
                      print(
                          '### Motor${index + 1} stream index는 : ${stream.topMotors[index]}');
                      // mqtt 업데이트
                      _mqttClass.ctlSet(
                          'did',
                          "${stream.topMotorId[index]}",
                          'dact',
                          _switch,
                          '/sf/$siteId/req/motor',
                          '/sf/$siteId/req/motor');
                      // DB 업데이트
                      _updateMotorData("${stream.top_motor_name[index]}", "top",
                          "$value", "top", "${stream.top_motor_id[index]}");
                    },
                  ),
                )
              ],
            ),
            decoration: _decorations(),
          );
        });
  }
}

class EtcMotor extends StatefulWidget {
  const EtcMotor({Key? key}) : super(key: key);

  @override
  _EtcMotorState createState() => _EtcMotorState();
}

class _EtcMotorState extends State<EtcMotor> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _fromLTRBPadding(
      child: Container(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            title: _edgeLeftPadding(
              15,
              child: Text('기타제어',
                  style: _textStyle(Color(0xffFFFFFF), FontWeight.w500, 20)),
            ),
            children: <Widget>[
              _topBottomPadding(
                15,
                15,
                child: Column(
                  children: [
                    _etcSwitch(),
                  ],
                ),
              )
            ],
          ),
        ),
        decoration: _decoration(Color(0xff2E8953)),
      ),
    );
  }
}

TextStyle _textStyle(dynamic _color, dynamic _weight, double _size) {
  return TextStyle(color: _color, fontWeight: _weight, fontSize: _size);
}

// decoration (with box shadow)
BoxDecoration _decoration(dynamic color) {
  return BoxDecoration(
    color: color,
    // color: Color(0xffFFFFFF),
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

// decoration(without box shadow)
BoxDecoration _decorations() {
  return BoxDecoration(
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(20),
  );
}

// ##### 기타제어
Widget _etcSwitch() {
  return ListView.builder(
      scrollDirection: Axis.vertical,
      primary: false,
      shrinkWrap: true,
      itemCount: stream.etcMotors.length,
      itemBuilder: (BuildContext context, int index) {
        return _marginContainer(
          height: Get.height * 0.09,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _edgeLeftPadding(20,
                  child: Text("${stream.etc_motor_name[index]}",
                      style: _textStyle(
                          Color(0xff222222), FontWeight.normal, 15))),
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
                  initialLabelIndex: stream.etcMotorStatus[index],
                  // statusIndex == 0 ? 1 : 0,
                  totalSwitches: 2,
                  labels: ['ON', 'OFF'],
                  radiusStyle: true,
                  onToggle: (value) async {
                    String _switch = '';

                    if (value == 0) {
                      _switch = 'open';
                    }
                    if (value == 1) {
                      _switch = 'stop';
                    }
                    print('toggle value는 : $value');
                    print('toggle type은 : ${value.runtimeType}');
                    print('value는 : $_switch');
                    // _mqttClass.ctlSet('did', '1', 'dact', _switch,
                    //     '/sf/e0000001/req/motor', '/sf/e0000001/req/motor');
                    _updateMotorData("${stream.etc_motor_name[index]}", "etc",
                        "$value", "etc", "${stream.etcMotorId[index]}");
                  },
                ),
              )
            ],
          ),
          decoration: _decorations(),
        );
      });
}

// padding widget
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
