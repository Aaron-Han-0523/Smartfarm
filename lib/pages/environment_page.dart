import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:plms_start/mqtt/mqtt.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dio/dio.dart';

import '../globals/stream.dart' as stream;
import 'components/getx_controller/controller.dart';

/*
* name : Environment Page
* description : Environment Control Page
* writer : mark
* create date : 2021-12-24
* last update : 2021-01-10
* */

// MQTT class
MqttClass _mqttClass = MqttClass();

//Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = 'test';
var siteId = 'sid';

var dio = Dio();

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
List motor_name = stream.motor_name;
List switchId = stream.switch_id;

// visibility
bool status1 = true;
bool status2 = true;
bool status3 = true;
bool status4 = true;
bool status5 = true;
bool status6 = true;
bool status7 = true;
bool status8 = true;
bool status9 = true;
bool status10 = true;
bool status11 = true;

//graph visibility
bool _graph = true;

// expanded tile
bool _customTileExpanded = false;

// temp
var temp = int.parse(extTemp);

// // getData()
// void _getMotorData() async {
//   // motors
//   final getMotor = await dio.get('$url/$userId/site/$siteId/controls/motors');
//   stream.motors = getMotor.data;
//   print('motor list : ${stream.motors}');
//   print('motor length : ${stream.motors.length}');
//   stream.motor_name = [];
//   for (var i = 0; i < stream.motors.length; i++) {
//     var motorName = stream.motors[i]['motor_name'];
//     stream.motor_name.add(motorName);
//   }

//   List<bool> motorStatus = [
//     stream.pump_1 == 'on' ? true : false,
//     stream.pump_2 == 'on' ? true : false
//   ];
//   print('motorStatus: $motorStatus');
//   stream.motorStatus = motorStatus;
// }

class EnvironmentPage extends StatefulWidget {
  const EnvironmentPage({Key? key}) : super(key: key);

  @override
  _EnvironmentState createState() => _EnvironmentState();
}

class _EnvironmentState extends State<EnvironmentPage> {
  void getStatus() async {
    String _switchStatus = await motor_1;
    print('toggle motor는 : $motor_1');

    setState(() {
      if (_switchStatus == 'open') {
      } else if (_switchStatus == 'stop') {
      } else if (_switchStatus == 'close') {}
    });
  }

  void initState() {
    super.initState();
  }

  var siteDropdown =
      stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounterController());
    return Scaffold(
        backgroundColor: Color(0xff2E6645),
        body: Obx(
          () => Container(
            // width: Get.width * 6,
            decoration: BoxDecoration(
              color: Color(0xffF5F9FC),
              borderRadius: BorderRadius.circular(40),
            ),
            child: CustomScrollView(
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
                            style: TextStyle(
                                color: Color(0xff2E8953), fontSize: 25),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(siteDropdown,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18)),
                        ),
                        SizedBox(height: Get.height * 0.05),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _mainMonitoring(context),
                              SizedBox(height: Get.height * 0.03),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _subMonitoring(
                                      context,
                                      'assets/images/icon_temp.png',
                                      "내부 온도",
                                      '${controller.innerTemp.value}°C',
                                      'assets/images/icon_humid.png',
                                      "내부 습도",
                                      '${controller.innerHumid.value}%'),
                                  _subMonitoring(
                                      context,
                                      'assets/images/icon_wind.png',
                                      "풍향",
                                      "남동향",
                                      'assets/images/icon_windsp.png',
                                      " 풍속",
                                      "1.2m/s"),
                                ],
                              )
                            ]),
                      ]),
                ),
                SliverList(
                  // itemExtent: 3.0,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF5F9FC),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: new EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: Container(
                                  decoration: _decoration(Color(0xff2E8953)),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
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
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text('측창 개폐기 제어',
                                            style: _textStyle(Color(0xffFFFFFF),
                                                FontWeight.w500, 20)),
                                      ),
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Column(
                                            children: [
                                              _alltoggleSwitch('측창(전체)', 'side',
                                                  'test', 'sid'),
                                              SizedBox(
                                                  height: Get.height * 0.01),
                                              _sideControlSwitch()
                                              // _toggleSwitch(
                                              //   context,
                                              //   '측장 (전)',
                                              //   status1,
                                              // ),
                                              // SizedBox(height: Get.height * 0.01),
                                              // _toggleSwitch(
                                              //   context,
                                              //   '측장 (후)',
                                              //   status2,
                                              // ),
                                              // SizedBox(height: Get.height * 0.01),
                                              // _toggleSwitch(
                                              //   context,
                                              //   '측장 (좌)',
                                              //   status3,
                                              // ),
                                              // SizedBox(height: Get.height * 0.01),
                                              // _toggleSwitch(
                                              //   context,
                                              //   '측장 (우)',
                                              //   status4,
                                              // ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: new EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: Container(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text('천창 개폐기 제어',
                                            style: _textStyle(Color(0xffFFFFFF),
                                                FontWeight.w500, 20)),
                                      ),
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Column(
                                            children: [
                                              _alltoggleSwitch('천창(전체)', 'top',
                                                  'test', 'sid'),
                                              SizedBox(
                                                  height: Get.height * 0.01),
                                              _topControlSwitch()
                                              // _toggleSwitch(
                                              //   context,
                                              //   '천창 (#1)',
                                              //   status5,
                                              // ),
                                              // SizedBox(height: Get.height * 0.01),
                                              // _toggleSwitch(
                                              //   context,
                                              //   '천창 (#2)',
                                              //   status6,
                                              // ),
                                              // SizedBox(height: Get.height * 0.01),
                                              // _toggleSwitch(
                                              //   context,
                                              //   '천창 (#3)',
                                              //   status7,
                                              // ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  decoration: _decoration(Color(0xff2E8953)),
                                ),
                              ),
                              Padding(
                                padding: new EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: Container(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text('기타제어',
                                            style: _textStyle(Color(0xffFFFFFF),
                                                FontWeight.w500, 20)),
                                      ),
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Column(
                                            children: [
                                              _toggleSwitch2(
                                                context,
                                                '환풍기 (#1)',
                                                status8,
                                              ),
                                              SizedBox(
                                                  height: Get.height * 0.01),
                                              _toggleSwitch2(
                                                context,
                                                '환풍기 (#2)',
                                                status9,
                                              ),
                                              SizedBox(
                                                  height: Get.height * 0.01),
                                              _toggleSwitch2(
                                                context,
                                                '외부 제어 (#1)',
                                                status10,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  decoration: _decoration(Color(0xff2E8953)),
                                ),
                              ),
                            ],
                          ));
                    },
                    childCount: 1,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// 현재 상태 모니터링
Widget _mainMonitoring(BuildContext context) {
  final controller = Get.put(CounterController());
  return Obx(
    () => Container(
        height: Get.height * 0.1,
        // width: Get.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            temp > 20
                ? Image.asset('assets/images/icon_shiny.png',
                    color: Color(0xff222222), scale: 3)
                : Image.asset('assets/images/icon_windy.png',
                    color: Color(0xff222222), scale: 3),
            // temp == 20 && extHumid=='5'? ImageIcon(AssetImage('assets/images/icon_shiny.png'), color: Color(0xff222222), size: 40): innerHumid=='50'? ImageIcon(AssetImage('assets/images/icon_shiny.png'), color: Color(0xff222222), size: 40):,
            Text("맑음/${controller.extTemp.value}°C",
                style: _textStyle(Color(0xff222222), FontWeight.w600, 16)),
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
        decoration: _decoration(Color(0xffFFFFFF))),
  );
}

// 내/외부 모니터링
Widget _subMonitoring(BuildContext context, dynamic icon, String mainText,
    String _mainText, dynamic _icon, String subText, String _subText) {
  return Container(
      height: Get.height * 0.13,
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
                  style: _textStyle(Color(0xff222222), FontWeight.w600, 18)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(_icon, color: Color(0xff222222), scale: 5),
              Text(subText,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              Text(_subText,
                  style: _textStyle(Color(0xff222222), FontWeight.w600, 18)),
            ],
          ),
        ],
      ),
      decoration: _decoration(Color(0xffFFFFFF)));
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

// 측창 개폐기 제어 전체
Widget _alltoggleSwitch(String text, var positions, var userIds, var siteIds) {
  return Visibility(
    visible: true,
    child: Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      height: Get.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(text,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15))),
          Padding(
            padding: EdgeInsets.only(right: 10),
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
              initialLabelIndex: 1,
              totalSwitches: 3,
              labels: ['전체열림', '전체정지', '전체닫힘'],
              radiusStyle: true,
              onToggle: (value) async {
                String _switch = '';

                if (value == 0) {
                  _switch = 'open';
                }
                if (value == 1) {
                  _switch = 'stop';
                }
                if (value == 2) {
                  _switch = 'close';
                }
                print('toggle value는 : $value');
                print('toggle type은 : ${value.runtimeType}');
                print('value는 : $_switch');
              },
            ),
          )
        ],
      ),
      decoration: _decorations(),
    ),
  );
}

// 측장 개폐기 제어
Widget _sideControlSwitch() {
  List<bool> visibility = [true, true, true];
  String _sideType = '';

  if (stream.sideMotors[0]['motor_name'] == '측장(좌)') {
    _sideType = '좌';
  } else if (stream.sideMotors[0]['motor_name'] == '측장(우)') {
    _sideType = '우';
  }

  return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: sideMotors.length,
      itemBuilder: (BuildContext context, var index) {
        return Visibility(
          visible: visibility[index],
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            height: Get.height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("${stream.sideMotors[0]['motor_name']}",
                        style: _textStyle(
                            Color(0xff222222), FontWeight.normal, 15))),
                Padding(
                  padding: EdgeInsets.only(right: 10),
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
                    initialLabelIndex: stream.motorStatus[index + 4],
                    // statusIndex == 0
                    //     ? 0
                    //     : statusIndex == 1
                    //         ? 1
                    //         : 2,
                    totalSwitches: 3,
                    labels: ['열림', '정지', '닫힘'],
                    radiusStyle: true,
                    onToggle: (value) async {
                      String _switch = '';

                      if (value == 0) {
                        _switch = 'open';
                        stream.motorStatus[index] = 0;
                      }
                      if (value == 1) {
                        _switch = 'stop';
                        stream.motorStatus[index] = 1;
                      }
                      if (value == 2) {
                        _switch = 'close';
                        stream.motorStatus[index] = 2;
                      }
                      print('toggle value는 : $value');
                      print('toggle motor는 : $motor_1');

                      print('### Motor${index + 1} toggle value는 : $value');
                      print(
                          '### Motor${index + 1} toggle type은 : ${value.runtimeType}');
                      print('### Motor${index + 1} value는 : $_switch');

                      _mqttClass.ctlSet('did', "${index + 1}", 'dact', _switch,
                          '/sf/e0000001/req/motor', '/sf/e0000001/req/motor');
                    },
                  ),
                )
              ],
            ),
            decoration: _decorations(),
          ),
        );
      });
}

// 천창 개폐기 제어
Widget _topControlSwitch() {
  List<bool> visibility = [true, true, true];

  return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: topMotors.length,
      itemBuilder: (BuildContext context, var index) {
        return Visibility(
          visible: visibility[index],
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            height: Get.height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("천창 (#${index + 1})",
                        style: _textStyle(
                            Color(0xff222222), FontWeight.normal, 15))),
                Padding(
                  padding: EdgeInsets.only(right: 10),
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
                    initialLabelIndex: stream.sideMotorStatus[index],
                    // statusIndex == 0
                    //     ? 0
                    //     : statusIndex == 1
                    //         ? 1
                    //         : 2,
                    totalSwitches: 3,
                    labels: ['열림', '정지', '닫힘'],
                    radiusStyle: true,
                    onToggle: (value) async {
                      String _switch = '';

                      if (value == 0) {
                        _switch = 'open';
                        stream.sideMotorStatus[index] = 0;
                      }
                      if (value == 1) {
                        _switch = 'stop';
                        stream.sideMotorStatus[index] = 1;
                      }
                      if (value == 2) {
                        _switch = 'close';
                        stream.sideMotorStatus[index] = 2;
                      }
                      print('toggle value는 : $value');
                      print('toggle motor는 : $motor_1');

                      print('### Motor${index + 1} toggle value는 : $value');
                      print(
                          '### Motor${index + 1} toggle type은 : ${value.runtimeType}');
                      print('### Motor${index + 1} value는 : $_switch');
                      print(
                          '### Motor${index + 1} stream index는 : ${stream.sideMotorStatus[index]}');

                      _mqttClass.ctlSet('did', "${index + 5}", 'dact', _switch,
                          '/sf/e0000001/req/motor', '/sf/e0000001/req/motor');
                    },
                  ),
                )
              ],
            ),
            decoration: _decorations(),
          ),
        );
      });
}

//기타제어
Widget _toggleSwitch2(BuildContext context, String text, bool visibles) {
  return Visibility(
    visible: visibles,
    child: Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      height: Get.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(text,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15))),
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
              initialLabelIndex: 1,
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
              },
            ),
          )
        ],
      ),
      decoration: _decorations(),
    ),
  );
}

// 그래프
Widget _lineChart(bool _visibles) {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

  List<_SalesData> subData = [
    _SalesData('Jan', 20),
    _SalesData('Feb', 50),
    _SalesData('Mar', 30),
    _SalesData('Apr', 40),
    _SalesData('May', 28)
  ];

  return Visibility(
    visible: _visibles,
    child: Padding(
      padding: EdgeInsets.all(15),
      child: SfCartesianChart(
          backgroundColor: Color(0xffFFFFFF),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<_SalesData, String>>[
            LineSeries<_SalesData, String>(
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                dataLabelSettings: DataLabelSettings(isVisible: false)),
            LineSeries<_SalesData, String>(
                dataSource: subData,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                dataLabelSettings: DataLabelSettings(isVisible: false))
          ]),
    ),
  );
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
