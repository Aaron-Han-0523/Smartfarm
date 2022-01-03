import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:dio/dio.dart';
import '../globals/stream.dart' as stream;

/*
* name : Soil Control Page
* description : Soil Control Page
* writer : sherry
* create date : 2021-12-24
* last update : 2022-01-03
* */

// globalKey
var innerTemp = stream.temp_1; // 내부온도
var extTemp = stream.exttemp_1; // 외부온도
var soilTemp = stream.soiltemp_1; // 토양온도
var innerHumid = stream.humid_1; // 내부습도
var extHumid = stream.humid_1; // 외부습도
var soilHumid = stream.soilhumid_1; // 토양습도

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';

// dio APIs
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class SoilControlPage extends StatefulWidget {
  SoilControlPage({Key? key}) : super(key: key);

  @override
  _SoilControlPageState createState() => _SoilControlPageState();
}

class _SoilControlPageState extends State<SoilControlPage> {
  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Scaffold(
      backgroundColor: Color(0xFFE6E6E6),
      body: Column(
        children: [
          MyWeather(), // 날씨
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                MyAccordian(), // 관수 펌프 제어, 밸브 제어
                MyGraph(), // 그래프
              ],
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
    var innerTemp = stream.temp_1; // 내부온도
    var extTemp = stream.exttemp_1; // 외부온도
    var soilTemp = stream.soiltemp_1; // 토양온도
    var innerHumid = stream.humid_1; // 내부습도
    var extHumid = stream.humid_1; // 외부습도
    var soilHumid = stream.soilhumid_1; // 토양습도
    print("innerTemp");
    print(innerTemp);
    print(stream.temp_1);

    _getData();

    super.initState();
  }

  void _getData() async {
    final response = await dio.get('$url/test/site/sid/controls/pumps');
    print('GET Pumps LIST: ${response.data}');
    var pump1 = response.data[0];
    var pump2 = response.data[1];

    final response1 = await dio.get('$url/test/site/sid/controls/valves');
    print('GET Valves LIST: ${response.data}');
    var valve1 = response.data[0];
    var valve2 = response.data[1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _weatherIcon(),
                    _temperature(),
                    Text("토양 전도도"),
                    Text("7860 cm/μs")
                  ],
                )),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _monitoring(Icons.device_thermostat, "내부 온도",
                          "$innerTemp" + "°C"),
                      _monitoring(
                          Icons.invert_colors_on, "내부 습도", "$innerHumid" + "%"),
                    ],
                  )),
            ),
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _monitoring(
                          Icons.device_thermostat, "토양 온도", "$soilTemp°C"),
                      _monitoring(
                          Icons.invert_colors_on, "토양 습도", "$soilHumid%"),
                    ],
                  )),
            ),
          ],
        ),
      ]),
    );
  }
}

// 관수 펌프 제어, 밸브 제어
class MyAccordian extends StatefulWidget {
  const MyAccordian({Key? key}) : super(key: key);

  @override
  State<MyAccordian> createState() => _MyAccordianState();
}

class _MyAccordianState extends State<MyAccordian> {
  // title
  List<String> title = ['펌프 (#1)', '펌프 (#2)', '밸브 (#1)', '밸브 (#2)'];
  // switch on off
  bool status1 = true;
  bool status2 = true;
  bool status3 = true;
  bool status4 = true;
  // visibiliby
  bool _visibility1 = true;
  bool _visibility2 = true;
  bool _visibility3 = true;
  bool _visibility4 = true;
  // switch value
  onChangeFunction1(bool newValue1) {
    setState(() {
      status1 = newValue1;
    });
  }

  onChangeFunction2(bool newValue2) {
    setState(() {
      status2 = newValue2;
    });
  }

  onChangeFunction3(bool newValue3) {
    setState(() {
      status3 = newValue3;
    });
  }

  onChangeFunction4(bool newValue4) {
    setState(() {
      status4 = newValue4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        // 관수 펌프 제어
        ExpansionTile(
          initiallyExpanded: true,
          title: Text('관수 펌프 제어'),
          children: <Widget>[
            Visibility(
                visible: _visibility1,
                child:
                    _cards(title[0], _visibility1, status1, onChangeFunction1)),
            Visibility(
                visible: _visibility2,
                child:
                    _cards(title[1], _visibility2, status2, onChangeFunction2)),
          ],
        ),
        // 밸브 제어
        ExpansionTile(
          title: Text('밸브 제어'),
          children: <Widget>[
            Visibility(
                visible: _visibility3,
                child:
                    _cards(title[2], _visibility3, status3, onChangeFunction3)),
            Visibility(
                visible: _visibility4,
                child:
                    _cards(title[3], _visibility4, status4, onChangeFunction4)),
          ],
        ),
      ]),
    );
  }

  Widget _cards(
      String title, bool visibles, bool val, Function onChangeMethod) {
    return Visibility(
      visible: visibles,
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title),
                Spacer(),
                FlutterSwitch(
                    activeColor: Colors.green,
                    inactiveColor: Colors.orange,
                    activeTextColor: Colors.white,
                    inactiveTextColor: Colors.white,
                    value: val,
                    showOnOff: true,
                    onToggle: (newValue) async {
                      if (title == title[0]) {
                        final response =
                            await dio.get('$url/test/site/sid/controls/pumps');
                        print('$title : ${response.data[0]}');

                        var pumpId = response.data[0]['pump_id'];
                        print(pumpId);
                        var pumpType = newValue; // on/off 바뀐 값
                        var pumpName = title;
                        final response1 = await dio.put(
                            '$url/test/site/sid/controls/pumps/$pumpId',
                            data: {
                              'pump_type': pumpType,
                              'pump_name': pumpName,
                            });
                        print('$title : $response1');
                        onChangeMethod(newValue);
                        print('##### 바뀜 $title : $newValue');
                        print('##### 바뀜 $title : $response1');
                      }
                      if (title == title[1]) {
                        final response =
                            await dio.get('$url/test/site/sid/controls/pumps');
                        print('$title : ${response.data[1]}');

                        var pumpId = response.data[1]['pump_id'];
                        print(pumpId);
                        var pumpType = newValue; // on/off 바뀐 값
                        var pumpName = title;
                        final response1 = await dio.put(
                            '$url/test/site/sid/controls/pumps/$pumpId',
                            data: {
                              'pump_type': pumpType,
                              'pump_name': pumpName,
                            });
                        print('$title : $response1');
                        onChangeMethod(newValue);
                        print('##### 바뀜 $title : $newValue');
                        print('##### 바뀜 $title : $response1');
                      }
                      if (title == title[2]) {
                        final response =
                            await dio.get('$url/test/site/sid/controls/valves');
                        print('$title : ${response.data}');

                        var valve_id = response.data[0]['valve_id'];
                        var valve_type = newValue; // on/off 바뀐 값
                        var valve_name = title;
                        final response1 = await dio.put(
                            '$url/test/site/sid/controls/valves/$valve_id',
                            data: {
                              'valve_type': valve_type,
                              'valve_name': valve_name,
                            });
                        print('$title : $response1');
                        onChangeMethod(newValue);
                        print('##### 바뀜 $title : $newValue');
                        print('##### 바뀜 $title : $response1');
                      } else {
                        final response =
                            await dio.get('$url/test/site/sid/controls/valves');
                        print('$title : ${response.data}');

                        var valve_id = response.data[1].valve_id;
                        var valve_type = newValue; // on/off 바뀐 값
                        var valve_name = title;
                        final response1 = await dio.put(
                            '$url/test/site/sid/controls/valves/$valve_id',
                            data: {
                              'valve_type': valve_type,
                              'valve_name': valve_name,
                            });
                        print('$title : $response1');
                        onChangeMethod(newValue);
                        print('##### 바뀜 $title : $newValue');
                        print('##### 바뀜 $title : $response1');
                      }
                    }),
              ],
            )),
      ),
    );
  }
}

// 그래프
class MyGraph extends StatefulWidget {
  const MyGraph({Key? key}) : super(key: key);

  @override
  State<MyGraph> createState() => _MyGraphState();
}

class _MyGraphState extends State<MyGraph> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('내부 온도', 12),
      _ChartData('내부 습도', 15),
      _ChartData('토양 온도', 30),
      _ChartData('토양 습도', 6.4),
      _ChartData('토양 전도도', 14)
    ];

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ExpansionTile(
        title: Text('그래프'),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 40, interval: 10),
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<_ChartData, String>>[
                    BarSeries<_ChartData, String>(
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        name: '내부 온도',
                        color: Color.fromRGBO(8, 142, 255, 1))
                  ]),
            ),
          ),
        ],
      ),
    ]);
  }
}

Widget _weatherIcon() {
  return Icon(
    Icons.wb_sunny_rounded,
    size: 40,
  );
}

Widget _temperature() {
  return Text("맑음/12.5°C");
}

Widget _monitoring(dynamic icon, String text, String temperText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Icon(icon, size: 20),
      SizedBox(width: 10),
      Text(text),
      SizedBox(width: 20),
      Text(temperText)
    ],
  );
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
