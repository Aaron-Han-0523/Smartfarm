import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dio/dio.dart';

import '../globals/stream.dart' as stream;

/*
* name : Environment Page
* description : Environment Control Page
* writer : mark
* create date : 2021-12-24
* last update : 2021-12-29
* */

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

  // onChange(bool _visibles){
  //   setState(() {
  //     _visibles = !_visibles;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.grey[350], //색상변경 필요
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
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.grey[350],
                  child: ExpansionTile(
                    backgroundColor: Colors.grey[350],
                    title: Text('측창 개폐기 제어',
                        style: _textStyle(Colors.black, FontWeight.w500, 20)),
                    children: <Widget>[
                      Column(
                        children: [
                          _alltoggleSwitch('측창(전체)', 'side', 'test', 'sid'),
                          _toggleSwitch(
                            context,
                            '츨장 (전)',
                            'side',
                            'test',
                            'sid',
                            'a_side',
                            status1,
                          ),
                          _toggleSwitch(
                            context,
                            '측장 (후)',
                            'side',
                            'test',
                            'sid',
                            'd_side',
                            status2,
                          ),
                          _toggleSwitch(
                            context,
                            '측장 (좌)',
                            'side',
                            'test2',
                            'sid2',
                            'e_side',
                            status3,
                          ),
                          _toggleSwitch(
                            context,
                            '측장 (우)',
                            'side',
                            'test2',
                            'sid2',
                            'g_side',
                            status4,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.grey[350],
                  child: ExpansionTile(
                    backgroundColor: Colors.grey[350],
                    title: Text('천창 개폐기 제어',
                        style: _textStyle(Colors.black, FontWeight.w500, 20)),
                    children: <Widget>[
                      Column(
                        children: [
                          _alltoggleSwitch('천창(전체)', 'top', 'test', 'sid'),
                          _toggleSwitch(
                            context,
                            '천창 (#1)',
                            'top',
                            'test',
                            'sid',
                            'b_top',
                            status5,
                          ),
                          _toggleSwitch(
                            context,
                            '천창 (#2)',
                            'top',
                            'test2',
                            'sid2',
                            'f_top',
                            status6,
                          ),
                          _toggleSwitch(
                            context,
                            '천창 (#3)',
                            'top',
                            'test2',
                            'sid2',
                            'h_top',
                            status7,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.grey[350],
                  child: ExpansionTile(
                    backgroundColor: Colors.grey[350],
                    title: Text('기타제어',
                        style: _textStyle(Colors.black, FontWeight.w500, 20)),
                    children: <Widget>[
                      Column(
                        children: [
                          _toggleSwitch2(context, '환풍기 (#1)', status8),
                          _toggleSwitch2(context, '환풍기 (#2)', status9),
                          _toggleSwitch2(context, '외부 제어 (#1)', status10),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.grey[350],
                  child: ExpansionTile(
                    backgroundColor: Colors.grey[350],
                    title: Text('그래프',
                        style: _textStyle(Colors.black, FontWeight.w500, 20)),
                    children: <Widget>[_lineChart(_graph)],
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
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2,
        offset: Offset(3, 5), // changes position of shadow
      ),
    ],
  );
}

// Widget _card(String text) {
//   return Container(
//       margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
//       height: Get.width * 0.15,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//               padding: EdgeInsets.only(left: 15),
//               child: Text(text,
//                   style: _textStyle(Colors.grey, FontWeight.w600, 16))),
//           Padding(
//               padding: EdgeInsets.only(right: 5),
//               child: _alltoggleSwitch('측창(전체)', 'side', 'test', 'sid'))
//         ],
//       ),
//       decoration: _decoration());
// }

var api = dotenv.env['PHONE_IP'];
var uris = '$api/farm';

var dio = Dio();
Widget _alltoggleSwitch(String text, var positions, var userIds, var siteIds) {
  var position = positions;
  var userId = userIds;
  var siteId = siteIds;
  return Visibility(
    visible: true,
    child: Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      height: Get.width * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(text,
                  style: _textStyle(Colors.grey, FontWeight.w600, 16))),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ToggleSwitch(
              minWidth: 50.0,
              cornerRadius: 50.0,
              activeBgColors: [
                [Colors.green],
                [Colors.orangeAccent],
                [Colors.black54]
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey[400],
              inactiveFgColor: Colors.white,
              initialLabelIndex: 1,
              totalSwitches: 3,
              labels: ['전체열림', '전체정지', '전체닫힘'],
              radiusStyle: true,
              onToggle: (value) async {
                // visibles = !visibles;
                print('switched to: $value');
                var response = await dio.put(
                    '$uris/$userId/site/$siteId/controls/$position/motors',
                    data: {'motor_name': '$value'});
                // .get('https://github.com/flutterchina/dio/tree/master/example');
                var datas = jsonDecode(response.toString());
                print(datas);
                // print(datas['data'][0]);
              },
            ),
          )
        ],
      ),
      decoration: _decoration(),
    ),
  );
}

Widget _toggleSwitch(BuildContext context, String text, var positions,
    var userIds, var siteIds, var motorIds, bool visibles) {
  var position = positions;
  var userId = userIds;
  var siteId = siteIds;
  var motorId = motorIds;
  return Visibility(
    visible: visibles,
    child: Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      height: MediaQuery.of(context).size.width * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(text,
                  style: _textStyle(Colors.grey, FontWeight.w600, 16))),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ToggleSwitch(
              minWidth: 50.0,
              cornerRadius: 50.0,
              activeBgColors: [
                [Colors.green],
                [Colors.orangeAccent],
                [Colors.black54]
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey[400],
              inactiveFgColor: Colors.white,
              initialLabelIndex: 1,
              totalSwitches: 3,
              labels: ['열림', '정지', '닫힘'],
              radiusStyle: true,
              onToggle: (value) async {
                // visibles = !visibles;
                print('switched to: $value');
                var response = await dio.put(
                    '$uris/$userId/site/$siteId/controls/$position/motors/$motorId',
                    data: {'motor_name': '$value'});
                // .get('https://github.com/flutterchina/dio/tree/master/example');
                var datas = jsonDecode(response.toString());
                print(datas);
                // print(datas['data'][0]);
              },
            ),
          )
        ],
      ),
      decoration: _decoration(),
    ),
  );
}

@override
Widget _toggleSwitch2(BuildContext context, String text, bool visibles) {
  return Visibility(
    visible: visibles,
    child: Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      height: MediaQuery.of(context).size.width * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(text,
                  style: _textStyle(Colors.grey, FontWeight.w600, 16))),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ToggleSwitch(
              minWidth: 50.0,
              cornerRadius: 50.0,
              activeBgColors: [
                [Colors.green],
                [Colors.orangeAccent]
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey[400],
              inactiveFgColor: Colors.white,
              initialLabelIndex: 1,
              totalSwitches: 2,
              labels: ['ON', 'OFF'],
              radiusStyle: true,
              onToggle: (index) {
                print('switched to: $index');
              },
            ),
          )
        ],
      ),
      decoration: _decoration(),
    ),
  );
}

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
    child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries<_SalesData, String>>[
          LineSeries<_SalesData, String>(
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.year,
              yValueMapper: (_SalesData sales, _) => sales.sales,
              name: 'Sales',
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: false)),
          LineSeries<_SalesData, String>(
              dataSource: subData,
              xValueMapper: (_SalesData sales, _) => sales.year,
              yValueMapper: (_SalesData sales, _) => sales.sales,
              name: 'Sales',
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: false))
        ]),
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
