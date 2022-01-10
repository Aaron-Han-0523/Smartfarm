import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:plms_start/mqtt/mqtt.dart';
import 'package:plms_start/punch_main/mqtt.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:dio/dio.dart';
import '../globals/stream.dart' as stream;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// TODO: valveStatus는 pump 값으로 하고있음

/*
* name : Soil Control Page
* description : Soil Control Page
* writer : sherry
* create date : 2021-12-24    
* last update : 2022-01-07
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
List pump_name = stream.pump_name;
List valves = stream.valves;
List valve_name = stream.valve_name;

List sensor_id = stream.sensor_id;

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

// MQTT
MqttClass _mqttClass = MqttClass();
String statusText = "Status Text";
bool isConnected = false;
final MqttServerClient client =
    MqttServerClient('broker.mqttdashboard.com', '');

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

  List<bool> pumpStatus = [
    stream.pump_1 == 'on' ? true : false,
    stream.pump_2 == 'on' ? true : false
  ];
  print('pumpStatus: $pumpStatus');
  stream.pumpStatus = pumpStatus;
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

  // List<bool> valveStatus = [
  //   stream.valve_1 == 'on' ? true : false,
  //   stream.valve_2 == 'on' ? true : false
  // ];
  // print('##### 사실은 pump1, pump2인 valveStatus: $valveStatus');
  // stream.valveStatus = valveStatus;
}

class SoilControlPage extends StatefulWidget {
  SoilControlPage({Key? key}) : super(key: key);

  @override
  _SoilControlPageState createState() => _SoilControlPageState();
}

class _SoilControlPageState extends State<SoilControlPage> {
  @override
  void initState() {
    _getPumpData();
    _getValveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Scaffold(
        backgroundColor: Color(0xFFE6E6E6),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              toolbarHeight: 250.0,
              backgroundColor: Color(0xffF5F9FC),
              title: Align(
                alignment: Alignment.topLeft,
                child: Column(children: [
                  Text(
                    'Farm in Earth',
                    style: TextStyle(color: Color(0xff2E8953), fontSize: 25),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text('siteDropdown',
                          style: TextStyle(color: Colors.black, fontSize: 18))),
                  MyWeather(),
                ]),
              ),
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
                      // color: Color(0xffF5F9FC),
                      child: Column(
                        children: [
                          MyPumps(),
                          MyValves(),
                          MyGraph(),
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
                    _firstCard(Icons.wb_sunny_rounded, "맑음", "12.5", "7860"),
                  ],
                )),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
  }

  List<bool> pumpStatus = stream.pumpStatus;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Color(0xff2E8953),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text('  관수 펌프 제어',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              textColor: Colors.white,
              collapsedTextColor: Colors.white,
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              backgroundColor: Color(0xff2E8953),
              collapsedBackgroundColor: Color(0xff2E8953),
              tilePadding: EdgeInsets.all(8.0),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: pumps.length,
                      itemBuilder: (BuildContext context, var index) {
                        return Container(
                          padding: EdgeInsets.all(8.0),
                          child: Visibility(
                            visible: visibility[index],
                            child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("  펌프 (#${index + 1})",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Spacer(),
                                      FlutterSwitch(
                                        activeColor: Colors.green,
                                        inactiveColor: Colors.orange,
                                        activeTextColor: Colors.white,
                                        inactiveTextColor: Colors.white,
                                        value: pumpStatus[index],
                                        showOnOff: true,
                                        onToggle: (value) {
                                          setState(() {
                                            pumpStatus[index] = value;
                                            String switchStatus = '';
                                            switchStatus =
                                                value == true ? 'on' : 'off';
                                            _mqttClass.ctlSet(
                                                'did',
                                                "${index + 1}",
                                                'dact',
                                                switchStatus,
                                                '/sf/e0000001/req/pump',
                                                '/sf/e0000001/req/pump');
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
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
  List<bool> valveStatus = [true, true];
  List<bool> visibility = [true, true];

  @override
  void initState() {
    super.initState();
  }

  // List<bool> valveStatus = stream.valveStatus;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ExpansionTile(
          title: Text('밸브 제어',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          textColor: Colors.white,
          collapsedTextColor: Colors.white,
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          backgroundColor: Color(0xff2E8953),
          collapsedBackgroundColor: Color(0xff2E8953),
          tilePadding: EdgeInsets.all(8.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: valves.length,
                  itemBuilder: (BuildContext context, var index) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: visibility[index],
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("밸브 (#${index + 1})"),
                                  Spacer(),
                                  FlutterSwitch(
                                    activeColor: Colors.green,
                                    inactiveColor: Colors.orange,
                                    activeTextColor: Colors.white,
                                    inactiveTextColor: Colors.white,
                                    value: valveStatus[index],
                                    showOnOff: true,
                                    onToggle: (value) {
                                      setState(() {
                                        valveStatus[index] = value;
                                        // String switchStatus = '';
                                        // switchStatus =
                                        //     value == true ? 'on' : 'off';
                                        // _mqttClass.ctlSet(
                                        //     'did',
                                        //     "${index + 1}",
                                        //     'dact',
                                        //     switchStatus,
                                        //     '/sf/e0000001/req/valve',
                                        //     '/sf/e0000001/req/valve');
                                      });
                                    },
                                  ),
                                ],
                              )),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
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
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Column(children: <Widget>[
        ExpansionTile(
          title: Text('그래프',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          textColor: Colors.white,
          collapsedTextColor: Colors.white,
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          backgroundColor: Color(0xff2E8953),
          collapsedBackgroundColor: Color(0xff2E8953),
          tilePadding: EdgeInsets.all(8.0),
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SfCartesianChart(
                    margin: EdgeInsets.all(8.0),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      ]),
    );
  }
}

Widget _firstCard(
    dynamic icon, String weather, String temperNumber, String soilNumber) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
    Icon(
      icon,
      size: 45,
    ),
    Text(" $weather/$temperNumber°C ",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    Text(" 토양 전도도 $soilNumber cm/μs",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  ]);
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
