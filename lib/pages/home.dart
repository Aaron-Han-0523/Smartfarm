import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plms_start/pages/sensor_page.dart';
import '../globals/stream.dart' as stream;

/*
* name : Home (get Data page)
* description : get Data
* writer : sherry
* create date : 2022-01-10
* last update : 2022-01-12
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

    // environment page
    stream.sideMotors = [];
    stream.topMotors = [];
    stream.motor_name = [];

    // soilControl page
    stream.pumps = [];
    stream.pump_name = [];
    stream.valves = [];
    stream.valve_name = [];

    stream.sensors = [];
    stream.sensor_id = []; // pump1, pump2
    stream.sensorStatus = []; // pump1's on/off, pump2's on/off

    stream.pumpStatus = [];
    stream.motorStatus = [];

    getData();
    super.initState();
  }

  // getData
  Future<dynamic> getData() async {
    if (mounted) {
      // put fcm token
      var fcmtoken = stream.fcmtoken;
      var data = {'uid': userId, 'fcmtoken': fcmtoken};
      final postToken =
          await dio.put('$api/farm/$userId/pushAlarm', data: data);
      print('##### postToken: $postToken');

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

      // motors
      final getSideMotors =
          await dio.get('$url/$userId/site/$siteId/controls/side/motors');
      stream.sideMotors = getSideMotors.data['data'];
      print('##### homePage GET sideMotors list : ${stream.sideMotors}');
      print(
          '##### homePage sideMotors List length : ${stream.sideMotors.length}');
      stream.motor_name = [];
      for (var i = 0; i < stream.sideMotors.length; i++) {
        var sideMotorName = stream.sideMotors[i]['motor_name'];
        stream.motor_name.add(sideMotorName);
      }

      final getTopMotors =
          await dio.get('$url/$userId/site/$siteId/controls/top/motors');
      stream.topMotors = getTopMotors.data['data'];
      print('##### homePage GET topMotors list : ${stream.topMotors}');
      print(
          '##### homePage topMotors List length : ${stream.topMotors.length}');
      stream.motor_name = [];
      for (var i = 0; i < stream.topMotors.length; i++) {
        var topMotorName = stream.topMotors[i]['motor_name'];
        stream.motor_name.add(topMotorName);
      }

      stream.motorStatus = [
        stream.motor_1 == 'on' ? 1 : 0,
        stream.motor_2 == 'on' ? 1 : 0,
        stream.motor_3 == 'on' ? 1 : 0,
        stream.motor_4 == 'on' ? 1 : 0,
        stream.motor_5 == 'on' ? 1 : 0,
        stream.motor_6 == 'on' ? 1 : 0,
        stream.motor_6 == 'on' ? 1 : 0, // motor 7개
        stream.pump_1 == 'on' ? 1 : 0,
        stream.pump_1 == 'on' ? 1 : 0, // on/off pump ㅇㅇ
        stream.pump_2 == 'on' ? 1 : 0,
      ];
      print('motorStatus: ${stream.motorStatus}');

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

      stream.pumpStatus = [
        stream.pump_1 == 'on' ? 1 : 0,
        stream.pump_2 == 'on' ? 1 : 0,
      ];
      print('pumpStatus: ${stream.pumpStatus}');

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

      // List<int> valveStatus = [
      //   stream.valve_1 == 'on' ? 1 : 0,
      //   stream.valve_2 == 'on' ? 1 : 0
      // ];
      // print('valveStatus: $valveStatus');
      // stream.valveStatus = valveStatus;

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
