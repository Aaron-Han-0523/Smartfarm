import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plms_start/punch_main/sensor_page.dart';
import '../globals/stream.dart' as stream;

import 'package:plms_start/punch_main/punch_main.dart';

/*
* name : Home
* description : home page
* writer : john
* create date : 2021-09-30
* last update : 2021-09-30
* */

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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // cctv page
    stream.cctvs = [];
    stream.cctv_url = [];

    // soilControl page
    stream.pumps = [];
    stream.pump_name = [];
    stream.valves = [];
    stream.valve_name = [];

    stream.sensors = [];
    stream.sensor_id = []; // pump1, pump2
    stream.sensorStatus = []; // pump1's on/off, pump2's on/off

    stream.pumpStatus = [];

    getData();
    super.initState();
  }

  // getData
  Future<dynamic> getData() async {
    if (mounted) {
      // cctvs
      final getCctvs = await dio.get('$url/$userId/site/$siteId/cctvs');
      stream.cctvs = getCctvs.data;
      print('##### homePage GET CCTV List from stream: ${stream.cctvs}');
      print('##### homePage GET CCTV List length: ${stream.cctvs.length}');
      stream.cctv_url = [];
      for (var i = 0; i < stream.cctvs.length; i++) {
        var cctvUrl = stream.cctvs[i]['cctv_url'];
        stream.cctv_url.add(cctvUrl);
      }
      print('##### homePage GET CCTV Url List: ${stream.cctv_url}');

      // pumps
      final getPumps =
          await dio.get('$url/$userId/site/$siteId/controls/pumps');
      stream.pumps = getPumps.data;
      print('##### homePage GET Pumps LIST: ${stream.pumps}');
      print('##### homePage Pumps LIST length: ${stream.pumps.length}');
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

      // valves
      final getValves =
          await dio.get('$url/$userId/site/$siteId/controls/valves');
      stream.valves = getValves.data;
      print('##### homePage GET Valves LIST: ${stream.valves}');
      print('##### homePage GET Valves LIST length: ${stream.valves.length}');
      stream.valve_name = [];
      for (var i = 0; i < stream.valves.length; i++) {
        var valveName = stream.valves[i]['cctv_url'];
        stream.valve_name.add(valveName);
      }

      // get pump1, pump2 = sensorId
      final getSensorId = await dio.get('$url/$userId/site/$siteId/sensors');
      stream.sensors = getSensorId.data;
      print('##### homePage GET Sensors LIST: ${stream.sensors}');
      print('##### homePage Sensors LIST length: ${stream.sensors.length}');
      stream.sensor_id = [];
      for (var i = 0; i < stream.sensors.length; i++) {
        String sensorId = stream.sensors[i]['sensor_id'];
        if (sensorId.contains('pump') == true) {
          stream.sensor_id.add(sensorId);
          print('$i) 이 sensorId($sensorId)는 pump가 맞습니다.');
        } else {
          print('$i) 이 sensorId($sensorId)는 pump가 아닙니다.');
        }
        print('##### homePage sensorId LIST: ${stream.sensor_id}');
      }
    }
    Get.offNamed('/sensor');
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 1);
  }
}
