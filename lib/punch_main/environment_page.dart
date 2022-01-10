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
var uris = '$api/farm';

var dio = Dio();

class EnvironmentPage extends StatefulWidget {
  const EnvironmentPage({Key? key}) : super(key: key);

  @override
  _EnvironmentState createState() => _EnvironmentState();
}

class _EnvironmentState extends State<EnvironmentPage> {
// globalKey
  var innerTemp = stream.temp_1; // 내부온도
  var extTemp = stream.exttemp_1; // 외부온도
  var soilTemp = stream.soiltemp_1; // 토양온도
  var innerHumid = stream.humid_1; // 내부습도
  var extHumid = stream.humid_1; // 외부습도
  var soilHumid = stream.soilhumid_1; // 토양습도

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


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F9FC),
        body: Column(children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _mainMonitoring(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _subMonitoring(
                          context,
                          Icons.device_thermostat,
                          "내부 온도",
                          '$innerTemp°C',
                          Icons.invert_colors_on,
                          "내부 습도",
                          '$innerHumid%'),
                      _subMonitoring(context, Icons.speed_sharp, "풍향", "남동향",
                          Icons.speed_sharp, "풍속", "1.2m/s"),
                    ],
                  )
                ]),
          ),
          Flexible(
            child: ListView(
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
            ),
          ),
        ]));
  }
}

// 현재 상태 모니터링
Widget _mainMonitoring(BuildContext context) {
  return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.wb_sunny, color: Colors.black54, size: 40),
          SizedBox(width: 5),
          Text("맑음/12.5°C",
              style: _textStyle(Colors.grey, FontWeight.w600, 16)),
          SizedBox(width: 10),
          Icon(Icons.arrow_upward_sharp, color: Colors.black54, size: 25),
          Text("07:32", style: _textStyle(Colors.grey, FontWeight.w600, 16)),
          Icon(Icons.arrow_downward_sharp, color: Colors.black54, size: 25),
          Text("18:08", style: _textStyle(Colors.grey, FontWeight.w600, 16)),
        ],
      ),
      decoration: _decoration());
}

// 내/외부 모니터링
Widget _subMonitoring(BuildContext context, dynamic icon, String mainText,
    String _mainText, dynamic _icon, String subText, String _subText) {
  return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.425,
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
                    Icon(icon, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(mainText,
                        style: _textStyle(Colors.grey, FontWeight.w600, 16)),
                  ],
                ),
                Text(_mainText,
                    style: _textStyle(Colors.grey, FontWeight.w600, 16)),
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
                    Icon(_icon, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(subText,
                        style: _textStyle(Colors.grey, FontWeight.w600, 16)),
                  ],
                ),
                Text(_subText,
                    style: _textStyle(
                        Colors.grey, FontWeight.w600, 16)), //"23.8°C"
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
