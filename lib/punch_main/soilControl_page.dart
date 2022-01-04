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
* last update : 2022-01-04
* */

// globalKey
var innerTemp = stream.temp_1; // 내부온도
var extTemp = stream.exttemp_1; // 외부온도
var soilTemp = stream.soiltemp_1; // 토양온도
var innerHumid = stream.humid_1; // 내부습도
var extHumid = stream.humid_1; // 외부습도
var soilHumid = stream.soilhumid_1; // 토양습도

List pumps = stream.pumps;
List pump_name = stream.pump_name;
List valves = stream.valves;
List valve_name = stream.valve_name;

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = 'test';
var siteId = 'sid';

// dio APIs
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

// getData()
void _getPumpData() async {
  // pumps
  final getPumps = await dio.get('$url/$userId/site/$siteId/controls/pumps');
  stream.pumps = getPumps.data;
  print('##### soilPage GET Pumps LIST: ${stream.pumps}');
  print('##### soilPage GET Pumps LIST length: ${stream.pumps.length}');
  stream.pump_name = [];
  for (var i = 0; i < stream.pumps.length; i++) {
    var pumpName = stream.pumps[i]['pump_name'];
    stream.pump_name.add(pumpName);
  }
}

void _getValveData() async {
  // valves
  final getValves = await dio.get('$url/$userId/site/$siteId/controls/valves');
  stream.valves = getValves.data;
  print('##### soilPage GET Valves LIST: ${stream.valves}');
  print('##### soilPage GET Valves LIST length: ${stream.valves.length}');
  stream.valve_name = [];
  for (var i = 0; i < stream.valves.length; i++) {
    var valveName = stream.valves[i]['valve_name'];
    stream.valve_name.add(valveName);
  }
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
          MyWeather(), // 날씨, 고정
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                MyPumps(), // 관수 펌프 제어
                MyValves(), // 밸브 제어
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
    super.initState();
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

// 관수 펌프 제어
class MyPumps extends StatefulWidget {
  const MyPumps({Key? key}) : super(key: key);

  @override
  State<MyPumps> createState() => _MyPumpsState();
}

class _MyPumpsState extends State<MyPumps> {
  List<bool> status = [true, true];
  List<bool> visibility = [true, true];

  @override
  void initState() {
    _getPumpData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ExpansionTile(
          initiallyExpanded: true,
          title: Text('관수 펌프 제어'),
          children: <Widget>[
            Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: pumps.length,
                  itemBuilder: (BuildContext context, var index) {
                    return Container(
                      child: Visibility(
                        visible: visibility[index],
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("펌프 (#" + "${index + 1}" + ")"),
                                  Spacer(),
                                  FlutterSwitch(
                                      activeColor: Colors.green,
                                      inactiveColor: Colors.orange,
                                      activeTextColor: Colors.white,
                                      inactiveTextColor: Colors.white,
                                      value: status[index],
                                      showOnOff: true,
                                      onToggle: (newValue) async {
                                        var pumpId = pumps[index]['pump_id'];
                                        var pumpType = newValue; // on/off 바뀐 값
                                        var pumpName = pump_name[index];
                                        final pumpReset = await dio.put(
                                            '$url/$userId/site/$siteId/controls/pumps/$pumpId',
                                            data: {
                                              'pump_type': pumpType,
                                              'pump_name': pumpName,
                                            });
                                        print('$pumpName : $pumpName');
                                        setState(() {
                                          status[index] = newValue;
                                        });
                                        print('##### 바뀜 $pumpName : $newValue');
                                        print(
                                            '##### 바뀜 $pumpName : $pumpReset');
                                      }),
                                ],
                              )),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ]),
    );
  }
}

// 밸브 제어
class MyValves extends StatefulWidget {
  const MyValves({Key? key}) : super(key: key);

  @override
  State<MyValves> createState() => _MyValvesState();
}

class _MyValvesState extends State<MyValves> {
  List<bool> status = [true, true];
  List<bool> visibility = [true, true];

  @override
  void initState() {
    _getValveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ExpansionTile(
          title: Text('밸브 제어'),
          children: <Widget>[
            Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: valves.length,
                  itemBuilder: (BuildContext context, var index) {
                    return Container(
                      child: Visibility(
                        visible: visibility[index],
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("밸브 (#" + "${index + 1}" + ")"),
                                  Spacer(),
                                  FlutterSwitch(
                                      activeColor: Colors.green,
                                      inactiveColor: Colors.orange,
                                      activeTextColor: Colors.white,
                                      inactiveTextColor: Colors.white,
                                      value: status[index],
                                      showOnOff: true,
                                      onToggle: (newValue) async {
                                        var valveId = valves[index]['valve_id'];
                                        var valveType = newValue; // on/off 바뀐 값
                                        var valveName = valve_name[index];
                                        final valveReset = await dio.put(
                                            '$url/$userId/site/$siteId/controls/valves/$valveId',
                                            data: {
                                              'valve_type': valveType,
                                              'valve_name': valveName,
                                            });
                                        print('$valveName : $valveName');
                                        setState(() {
                                          status[index] = newValue;
                                        });
                                        print(
                                            '##### 바뀜 $valveName : $newValue');
                                        print(
                                            '##### 바뀜 $valveName : $valveReset');
                                      }),
                                ],
                              )),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ]),
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
