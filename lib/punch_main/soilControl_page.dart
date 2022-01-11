import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:plms_start/mqtt/mqtt.dart';
import 'package:plms_start/punch_main/mqtt.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:dio/dio.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../globals/stream.dart' as stream;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// TODO: valveStatus는 아직 없음

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

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Scaffold(
        backgroundColor: Color(0xFFE6E6E6),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              toolbarHeight: 220.0,
              backgroundColor: Color(0xffF5F9FC),
              title: Align(
                alignment: Alignment.topLeft,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Farm in Earth',
                        style:
                            TextStyle(color: Color(0xff2E8953), fontSize: 25),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text('siteDropdown',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18))),
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
                      child: Column(
                        children: [
                          MyPumps(),
                          MyValves(),
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
      // alignment: Alignment.center,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          // padding: const EdgeInsets.only(left: 10, right: 10),
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _firstCard(
                        'assets/images/icon_shiny.png', "맑음", "12.5", "7860"),
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
                      _monitoring('assets/images/icon_temp.png', "내부 온도",
                          "$innerTemp" + "°C"),
                      _monitoring('assets/images/icon_temp.png', "내부 습도",
                          "$innerHumid" + "%"),
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
                      _monitoring('assets/images/icon_temp.png', "토양 온도",
                          "$soilTemp°C"),
                      _monitoring('assets/images/icon_temp.png', "토양 습도",
                          "$soilHumid%"),
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

  List<int> pumpStatus = stream.pumpStatus;
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
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 10),
                          height: Get.height * 0.09,
                          child: Visibility(
                            visible: visibility[index],
                            child: Card(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("  펌프 (#${index + 1})",
                                          style: TextStyle(
                                              color: Color(0xff222222),
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal)),
                                      Spacer(),
                                      ToggleSwitch(
                                        minWidth: 60.0,
                                        cornerRadius: 80.0,
                                        activeBgColors: [
                                          [Color(0xffe3fbed)],
                                          [Color(0xfff2f2f2)]
                                        ],
                                        activeFgColor: Color(0xff222222),
                                        inactiveBgColor: Color(0xffFFFFFF),
                                        inactiveFgColor: Color(0xff222222),
                                        initialLabelIndex: pumpStatus[
                                            index], // 시뮬레이터에서 현재 상태를 불러오질 못하고 있음, default=0
                                        totalSwitches: 2,
                                        labels: ['ON', 'OFF'],
                                        radiusStyle: true,
                                        onToggle: (value) async {
                                          pumpStatus[index] = value;
                                          String switchStatus = '';

                                          if (value == 0) {
                                            switchStatus = 'on';
                                          } else if (value == 1) {
                                            switchStatus = 'off';
                                          }

                                          // pumpStatus[index] = value;

                                          print(
                                              '### Pump${index + 1} toggle value는 : $value');
                                          print(
                                              '### Pump${index + 1} toggle type은 : ${value.runtimeType}');
                                          print(
                                              '### Pump${index + 1} value는 : $switchStatus');

                                          _mqttClass.ctlSet(
                                              'did',
                                              "${index + 1}",
                                              'dact',
                                              switchStatus,
                                              '/sf/e0000001/req/pump',
                                              '/sf/e0000001/req/pump');
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
  List<int> valveStatus = [0, 0];
  List<bool> visibility = [true, true];

  @override
  void initState() {
    super.initState();
  }

  // List<int> valveStatus = stream.valveStatus;
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
              title: Text('  밸브 제어',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              textColor: Colors.white,
              collapsedTextColor: Colors.white,
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
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
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 10),
                          height: Get.height * 0.09,
                          child: Visibility(
                            visible: visibility[index],
                            child: Card(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("  밸브 (#${index + 1})",
                                          style: TextStyle(
                                              color: Color(0xff222222),
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal)),
                                      Spacer(),
                                      ToggleSwitch(
                                        minWidth: 60.0,
                                        cornerRadius: 80.0,
                                        activeBgColors: [
                                          [Color(0xffe3fbed)],
                                          [Color(0xfff2f2f2)]
                                        ],
                                        activeFgColor: Color(0xff222222),
                                        inactiveBgColor: Color(0xffFFFFFF),
                                        inactiveFgColor: Color(0xff222222),
                                        initialLabelIndex: valveStatus[
                                            index], // 시뮬레이터에서 현재 상태를 불러오질 못하고 있음, default=0
                                        totalSwitches: 2,
                                        labels: ['ON', 'OFF'],
                                        radiusStyle: true,
                                        onToggle: (value) async {
                                          valveStatus[index] = value;
                                          String switchStatus = '';

                                          if (value == 0) {
                                            switchStatus = 'on';
                                          } else if (value == 1) {
                                            switchStatus = 'off';
                                          }

                                          // valveStatus[index] = value;

                                          print(
                                              '### Valve${index + 1} toggle value는 : $value');
                                          print(
                                              '### Valve${index + 1} toggle type은 : ${value.runtimeType}');
                                          print(
                                              '### Valve${index + 1} value는 : $switchStatus');

                                          // _mqttClass.ctlSet(
                                          //     'did',
                                          //     "${index + 1}",
                                          //     'dact',
                                          //     switchStatus,
                                          //     '/sf/e0000001/req/valve',
                                          //     '/sf/e0000001/req/valve');
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

Widget _firstCard(
    String icon, String weather, String temperNumber, String soilNumber) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    Image.asset(
      icon,
      scale: 2,
    ),
    Text(" $weather/$temperNumber°C ",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    Text(" 토양 전도도 $soilNumber cm/μs",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  ]);
}

Widget _monitoring(String assets, String text, String temperText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Image.asset(
        assets,
        scale: 4,
      ),
      SizedBox(width: 10),
      Text(text),
      SizedBox(width: 20),
      Text(temperText)
    ],
  );
}
