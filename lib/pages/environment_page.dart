// necessary to build app
import 'package:flutter/material.dart';
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

/*
* name : Environment Page
* description : Environment Control Page
* writer : mark
* create date : 2021-12-24
* last update : 2021-02-03
* */

// MQTT
ConnectMqtt _connectMqtt = ConnectMqtt();

// Dio
var dio = Dio();

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
    print('## [environment page] get all side value : $getToggleStatus');
    setState(() {
      allSideToggleInit = getToggleStatus;
    });
  }

  //shared preferences top toggle status
  Future<Null> getTopSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getTopToggleStatus = prefs.getInt('allTopValue') ?? 0;
    print('## [environment page] get all top value : $getTopToggleStatus');
    setState(() {
      allTopToggleInit = getTopToggleStatus;
    });
  }

  void initState() {
    super.initState();
    getSideSharedPrefs();
    getTopSharedPrefs();
  }

  // siteDropdown button global variable
  var siteDropdown = stream.sitesDropdownValue == ''
      ? '${stream.siteNames[0]}'
      : stream.sitesDropdownValue;

  @override
  Widget build(BuildContext context) {
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
                      _weather(context)
                      // MyWeather(),
                    ]),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      color: Color(0xffF5F9FC),
                      child: Column(
                        children: [
                          // 측창 개폐기 제어
                          toggleControl(
                              '측창 개폐기 제어',
                              sideMotors,
                              getToggleStatus,
                              '측창(전체)',
                              sideStatus,
                              stream.sideMotorId,
                              'side',
                              siteId,
                              toggle.saveAllSideToggle,
                              _allSideToggleSwitch(
                                  '측창(전체)',
                                  getToggleStatus, // 로컬에 전체 제어 된 상태 저장
                                  sideStatus,
                                  stream.sideMotorId,
                                  'side',
                                  siteId,
                                  toggle.saveAllSideToggle),
                              controlToggleSwitch(
                                  sideMotors,
                                  stream.side_motor_name,
                                  sideStatus,
                                  stream.sideMotorId,
                                  stream.side_motor_id,
                                  "side",
                                  siteId)),
                          // 천창 개폐기 제어
                          toggleControl(
                              '천창 개폐기 제어',
                              topMotors,
                              getTopToggleStatus,
                              '천창(전체)',
                              topStatus,
                              stream.topMotorId,
                              'top',
                              siteId,
                              toggle.saveAllTopToggle,
                              _allTopToggleSwitch(
                                  '천창(전체)',
                                  getTopToggleStatus,
                                  topStatus,
                                  stream.topMotorId,
                                  'top',
                                  siteId,
                                  toggle.saveAllTopToggle),
                              controlToggleSwitch(
                                  topMotors,
                                  stream.top_motor_name,
                                  topStatus,
                                  stream.topMotorId,
                                  stream.top_motor_id,
                                  "top",
                                  siteId)),
                          // TopMotor(),
                          _etcMotor(),
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

  Widget toggleControl(
      var mainName,
      var motors,
      var saveToggleStatus,
      var allToggleName,
      var motorStatus,
      var motorIds,
      var motorType,
      var siteIds,
      var setSharedToggle,
      Widget allToggleWidget,
      Widget toggleWidget) {
    return Column(
      children: [
        _fromLTRBPadding(
          child: Container(
            decoration: _decoration(Color(0xff2E8953)),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: IgnorePointer(
                ignoring: motors.length == 0 ? true : false,
                child: ExpansionTile(
                  initiallyExpanded: motors == sideMotors ? true : false,
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
                    child: Text(mainName,
                        style:
                            _textStyle(Color(0xffFFFFFF), FontWeight.w500, 20)),
                  ),
                  children: <Widget>[
                    _topBottomPadding(
                      15,
                      15,
                      child: Column(
                        children: [
                          // 전체 제어 토글 위젯
                          allToggleWidget,
                          // 개별 제어 토글 위젯
                          toggleWidget
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 전체 토글 상태 제어 [측창]
  Widget _allSideToggleSwitch(
      String text,
      var saveToggleVariable,
      var motorStatus,
      var motorIds,
      var motorType,
      var siteIds,
      setSharedToggle // 토글 상태 로컬에 저장시켜줌
      ) {
    return _marginContainer(
      height: Get.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _edgeLeftPadding(20,
              child: SizedBox(
                width: Get.width * 1 / 5,
                child: Text(text,
                    style:
                        _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              )),
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
                String _switch = '';
                setState(() {
                  getToggleStatus = value;
                });
                if (value == 0) {
                  _switch = 'open';
                  setState(() {
                    for (int i = 0; i < motorStatus.length; i++,) {
                      motorStatus[i] = value;
                    }
                  });
                }
                if (value == 1) {
                  _switch = 'stop';
                  setState(() {
                    for (int i = 0; i < motorStatus.length; i++,) {
                      motorStatus[i] = value;
                    }
                  });
                }
                if (value == 2) {
                  _switch = 'close';
                  setState(() {
                    for (int i = 0; i < motorStatus.length; i++,) {
                      motorStatus[i] = value;
                    }
                  });
                }
                // mqtt
                _connectMqtt.setAll(
                    'did',
                    motorIds.length,
                    'dact',
                    _switch,
                    '/sf/$siteIds/req/motor',
                    '/sf/$siteIds/req/motor',
                    motorIds);
                // DB 변동
                _updateAllMotorData(value, motorType);
                // shared preferences
                setSharedToggle(value);
              },
            ),
          )
        ],
      ),
      decoration: _decorations(),
    );
  }

  // 전체 토글 상태 제어 [측창]
  Widget _allTopToggleSwitch(
      String text,
      var saveToggleStatus,
      var motorStatus,
      var motorIds,
      var motorType,
      var siteIds,
      setSharedToggle // 토글 상태 로컬에 저장시켜줌
      ) {
    return _marginContainer(
      height: Get.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _edgeLeftPadding(20,
              child: SizedBox(
                width: Get.width * 1 / 5,
                child: Text(text,
                    style:
                        _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              )),
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
              initialLabelIndex: getTopToggleStatus,
              totalSwitches: 3,
              labels: ['전체열림', '전체정지', '전체닫힘'],
              radiusStyle: true,
              onToggle: (value) async {
                getTopToggleStatus = value;
                String _switch = '';

                if (value == 0) {
                  setState(() {
                    for (int i = 0; i < motorStatus.length; i++,) {
                      motorStatus[i] = value;
                    }
                  });
                  _switch = 'open';
                }
                if (value == 1) {
                  _switch = 'stop';
                  setState(() {
                    for (int i = 0; i < motorStatus.length; i++,) {
                      motorStatus[i] = value;
                    }
                  });
                }
                if (value == 2) {
                  _switch = 'close';
                  setState(() {
                    for (int i = 0; i < motorStatus.length; i++,) {
                      motorStatus[i] = value;
                    }
                  });
                }
                // mqtt
                _connectMqtt.setAll(
                    'did',
                    motorIds.length,
                    'dact',
                    _switch,
                    '/sf/$siteIds/req/motor',
                    '/sf/$siteIds/req/motor',
                    motorIds);
                // DB 변동
                _updateAllMotorData(value, motorType);
                // shared preferences
                setSharedToggle(value);
              },
            ),
          )
        ],
      ),
      decoration: _decorations(),
    );
  }

  // 측창/천창 토글 개별 제어
  Widget controlToggleSwitch(var motors, var motorName, var motorStatus,
      var motorIds, var motorIds2, var motorType, var siteIds) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: motors.length,
        itemBuilder: (BuildContext context, int index) {
          return _marginContainer(
            height: Get.height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _edgeLeftPadding(20,
                    child: SizedBox(
                      width: textSizedBox,
                      child: ExpandableText(
                        "${motorName[index]}", //${stream.sideMotors[0]['motor_name']
                        style: _textStyle(
                            Color(0xff222222), FontWeight.normal, 15),
                        maxLines: 2,
                        // expanded: true,
                        expandText: ' ',
                        // overflow: TextOverflow.fade,
                        // softWrap: true,
                      ),
                    )),
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
                    initialLabelIndex: motorStatus[index],
                    // stream.topMotors[index],
                    totalSwitches: 3,
                    labels: ['열림', '정지', '닫힘'],
                    radiusStyle: true,
                    onToggle: (value) async {
                      String _switch = '';

                      if (value == 0) {
                        _switch = 'open';
                        motorStatus[index] = value;
                        // stream.topMotors[index] = 0;
                      }
                      if (value == 1) {
                        _switch = 'stop';
                        motorStatus[index] = value;
                        // stream.topMotors[index] = 1;
                      }
                      if (value == 2) {
                        _switch = 'close';
                        motorStatus[index] = value;
                        // stream.topMotors[index] = 2;
                      }
                      // 개별 제어 motor name 확인
                      print(
                          '### [environment page] Motor name index 뽑기 : ${stream.sideMotors[0]['motor_name']}');
                      // MQTT 통신
                      _connectMqtt.setControl(
                          'did',
                          "${motorIds[index]}",
                          'dact',
                          _switch,
                          '/sf/$siteIds/req/motor',
                          '/sf/$siteIds/req/motor');
                      // DB 업데이트
                      _updateMotorData("${motorName[index]}", "side", "$value",
                          "side", "${motorIds2[index]}");
                    },
                  ),
                )
              ],
            ),
            decoration: _decorations(),
          );
        });
  }

  // 기타제어 etc motor
  @override
  Widget _etcMotor() {
    return _fromLTRBPadding(
      child: Container(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: IgnorePointer(
            ignoring: stream.etcMotors.length == 0 ? true : false,
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
        ),
        decoration: _decoration(Color(0xff2E8953)),
      ),
    );
  }

  // 기타제어 switch
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
                      // MQTT 통신
                      _connectMqtt.setControl(
                          'did',
                          "${stream.etcMotorId[index]}",
                          'dact',
                          _switch,
                          '/sf/$siteId/req/motor',
                          '/sf/$siteId/req/motor');
                      //DB 업데이트
                      _updateEtcMotorData(
                          "$value", "${stream.etcMotorId[index]}");
                    },
                  ),
                )
              ],
            ),
            decoration: _decorations(),
          );
        });
  }

  // 날씨
  Widget _weather(BuildContext context) {
    final controller = Get.put(CounterController());
    return Obx(
      () => Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _mainMonitoring(),
          // SizedBox(height: Get.height * 0.03),
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
                        'assets/images/icon_wind.png',
                        "풍향",
                        // "${controller.soilTemp.value}°C",
                        "남동향",
                        'assets/images/icon_windsp.png',
                        "  풍속",
                        // "${controller.soilHumid.value}%"),
                        "12.5m/s"),
                  ],
                ),
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
      height: Get.height * 0.07,
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
      height: Get.height * 0.09,
      width: Get.width * 0.425,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(icon, color: Color(0xff222222), scale: 5),
              Text(mainText,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              Text(_mainText,
                  style: _textStyle(Color(0xff222222), FontWeight.w600, 15)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

var textSizedBox = Get.width * 1 / 5;
var overflows = TextOverflow.ellipsis;

// text 스타일 widget 지정
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
