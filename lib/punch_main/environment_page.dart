import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:plms_start/mqtt/mqtt.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dio/dio.dart';

import '../globals/stream.dart' as stream;

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

List motors = stream.motors;
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

// getData()
void _getMotorData() async {
  // pumps
  final getMotor = await dio.get('$url/$userId/site/$siteId/controls/motors');
  stream.motors = getMotor.data;
  print('motor list : ${stream.motors}');
  print('motor length : ${stream.motors.length}');
  stream.motor_name = [];
  for (var i = 0; i < stream.motors.length; i++) {
    var motorName = stream.motors[i]['motor_name'];
    stream.motor_name.add(motorName);
  }

  List<bool> motorStatus = [
    stream.pump_1 == 'on' ? true : false,
    stream.pump_2 == 'on' ? true : false
  ];
  print('motorStatus: $motorStatus');
  stream.motorStatus = motorStatus;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F9FC),
        body: CustomScrollView(
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
                    style: TextStyle(color: Color(0xff2E8953), fontSize: 25),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('siteDropdown',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
                SizedBox(height : Get.height * 0.05),
                Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _mainMonitoring(context),
                        SizedBox(height: Get.height * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _subMonitoring(
                                context,
                                'assets/images/icon_temp.png',
                                "내부 온도",
                                '$innerTemp°C',
                                'assets/images/icon_humid.png',
                                "내부 습도",
                                '$innerHumid%'),
                            _subMonitoring(context,
                                'assets/images/icon_wind.png', "풍향", "남동향",
                                'assets/images/icon_windsp.png', "풍속", "1.2m/s"),
                          ],
                        )
                      ]),
                ),
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
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            margin: new EdgeInsets.fromLTRB(5, 10, 10, 5),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Color(0xff2E8953),
                              child: Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  // backgroundColor: Color(0xff2E8953),
                                  trailing: Icon(
                                      _customTileExpanded
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded
                                  ),
                                  onExpansionChanged: (bool expanded) {
                                    setState(() {
                                      _customTileExpanded = expanded;
                                    });
                                  },
                                  title: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text('측창 개폐기 제어',
                                        style: _textStyle(
                                            Color(0xffFFFFFF), FontWeight.w500, 20)),
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 15, bottom: 15),
                                      child: Column(
                                        children: [
                                          _alltoggleSwitch('측창(전체)', 'side', 'test', 'sid'),
                                          SizedBox(height: Get.height * 0.01),
                                          _toggleSwitch(
                                            context,
                                            '츨장 (전)',
                                            status1,
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                          _toggleSwitch(
                                            context,
                                            '측장 (후)',
                                            status2,
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                          _toggleSwitch(
                                            context,
                                            '측장 (좌)',
                                            status3,
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                          _toggleSwitch(
                                            context,
                                            '측장 (우)',
                                            status4,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5,10,10,5),
                            child: Card(
                              color: Color(0xff2E8953),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text('천창 개폐기 제어',
                                        style: _textStyle(Color(0xffFFFFFF), FontWeight.w500, 20)),
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 15, bottom: 15),
                                      child: Column(
                                        children: [
                                          _alltoggleSwitch('천창(전체)', 'top', 'test', 'sid'),
                                          SizedBox(height: Get.height * 0.01),
                                          _toggleSwitch(
                                            context,
                                            '천창 (#1)',
                                            status5,
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                          _toggleSwitch(
                                            context,
                                            '천창 (#2)',
                                            status6,
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                          _toggleSwitch(
                                            context,
                                            '천창 (#3)',
                                            status7,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5,10,10,5),
                            child: Card(
                              color: Color(0xff2E8953),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text('기타제어',
                                        style: _textStyle(Color(0xffFFFFFF), FontWeight.w500, 20)),
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 15, bottom: 15),
                                      child: Column(
                                        children: [
                                          _toggleSwitch2(context, '환풍기 (#1)', status8),
                                          SizedBox(height: Get.height * 0.01),
                                          _toggleSwitch2(context, '환풍기 (#2)', status9),
                                          SizedBox(height: Get.height * 0.01),
                                          _toggleSwitch2(context, '외부 제어 (#1)', status10),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5,10,10,5),
                            child: Card(
                              color: Color(0xff2E8953),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text('그래프',
                                        style: _textStyle(Color(0xffFFFFFF), FontWeight.w500, 20)),
                                  ),
                                  children: <Widget>[_lineChart(_graph)],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                },
                childCount: 1,
              ),
            ),
          ],
        ));
  }
}

// 현재 상태 모니터링
Widget _mainMonitoring(BuildContext context) {
  return Container(
      height: Get.height * 0.1,
      // width: Get.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ImageIcon(AssetImage('assets/images/icon_shiny.png'), color: Color(0xff222222), size: 40),
          Text("맑음/12.5°C",
              style: _textStyle(Color(0xff222222), FontWeight.w600, 16)),
          ImageIcon(AssetImage('assets/images/icon_env_arrow_up.png'), color: Color(0xffffd5185),),
          Text("07:32", style: _textStyle(Color(0xff222222), FontWeight.w600, 16)),
          ImageIcon(AssetImage('assets/images/icon_env_arrow_down.png'), color: Color(0xfff656565),),
          Text("18:08", style: _textStyle(Color(0xff222222), FontWeight.w600, 16)),
        ],
      ),
      decoration: _decoration()
  );
}

// 내/외부 모니터링
Widget _subMonitoring(BuildContext context, dynamic icon, String mainText,
    String _mainText, dynamic _icon, String subText, String _subText) {
  return Container(
      height: Get.height * 0.15,
      width:Get.width* 0.425,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ImageIcon(AssetImage(icon), color: Color(0xff222222)),
                    SizedBox(width: 10),
                    Text(mainText,
                        style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
                  ],
                ),
                Text(_mainText,
                    style: _textStyle(Color(0xff222222), FontWeight.w600, 18)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ImageIcon(AssetImage(icon), color: Color(0xff222222)),
                    SizedBox(width: 10),
                    Text(subText,
                        style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
                  ],
                ),
                Text(_subText,
                    style: _textStyle(
                        Color(0xff222222), FontWeight.w600, 18)), //"23.8°C"
              ],
            ),
          ),
        ],
      ),
      decoration: _decoration());
}

TextStyle _textStyle(dynamic _color, dynamic _weight, double _size) {
  return TextStyle(color: _color, fontWeight: _weight, fontSize: _size);
}

BoxDecoration _decoration() {
  return BoxDecoration(
    color: Colors.white,
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
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 16))),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ToggleSwitch(
              minWidth: 75.0,
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
      decoration: _decoration(),
    ),
  );
}


// 측창 개폐기 제어
Widget _toggleSwitch(BuildContext context, String text, bool visibles) {
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
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 16))),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ToggleSwitch(
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
              initialLabelIndex: 1,
              totalSwitches: 3,
              labels: ['열림', '정지', '닫힘'],
              radiusStyle: true,
              onToggle: (motor_1) async {
                String _switch = '';

                if (motor_1 == 0) {
                  _switch = 'open';
                }
                if (motor_1 == 1) {
                  _switch = 'stop';
                }
                if (motor_1 == 2) {
                  _switch = 'close';
                }
                print('toggle value는 : $motor_1');
                print('toggle type은 : ${motor_1.runtimeType}');
                print('value는 : $_switch');
                _mqttClass.ctlSet('did', '1', 'dact', _switch,
                    '/sf/e0000001/req/motor', '/sf/e0000001/req/motor');
              },
            ),
          )
        ],
      ),
      decoration: _decoration(),
    ),
  );
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
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 16))),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ToggleSwitch(
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
      decoration: _decoration(),
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

//RaisedButton Widget

Widget _raisedButoon(dynamic color, String text) {
  return Container(
    child: RaisedButton(
      onPressed: () async {
        print('hi111111111111');
      },
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    ),
  );
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
