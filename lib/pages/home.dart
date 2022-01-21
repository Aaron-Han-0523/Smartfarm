import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../globals/stream.dart' as stream;

/*
* name : Home (get Data page)
* description : get Data
* writer : sherry
* create date : 2022-01-10
* last update : 2022-01-17
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
    stream.top_motor_name = [];

    // soilControl page
    stream.pumps = [];
    stream.pump_name = [];
    stream.valves = [];
    stream.valve_name = [];

    stream.sensors = [];
    stream.sensor_id = []; // pump1, pump2
    stream.sensorStatus = []; // pump1's on/off, pump2's on/off

    stream.pumpStatus = [];
    stream.valveStatus = [];
    stream.mqttTopMotorStatus = [];
    stream.mqttSideMotorStatus = [];


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

      // trends innerTemp
      final getInnerTemp =
          await dio.get('$url/$userId/site/$siteId/innerTemps');
      stream.chartData = getInnerTemp.data['data'];
      print('##### getInnerTemp: ${getInnerTemp.data['data']}');
      print(
          '##### getInnerTemp 최근 내부온도 시간: ${getInnerTemp.data['data'][0]['time_stamp']}');

      var date = getInnerTemp.data['data'][0]['time_stamp'];
      var yyyyMMddE = date.substring(0, 10);
      yyyyMMddE = yyyyMMddE.replaceAll('-', '');
      yyyyMMddE = DateFormat('yyyy년 MM월 dd일')
          .format(DateTime.parse(yyyyMMddE))
          .toString();
      var hhMMss = date.substring(11, 19);
      print('yyyy년 MM월 dd일 (E): $yyyyMMddE');
      print('hh시 MM분 ss초: $hhMMss');
      print(
          '##### getInnerTemp 최근 내부온도 온도: ${getInnerTemp.data['data'][0]['value']}');

      int innerTempLength = getInnerTemp.data['data'].length;
      print('innerTempLength: $innerTempLength');

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

      //----------motor----------------------------------------------
      // ## side motor -----------
      final getSideMotors = await dio.get('$url/$userId/site/$siteId/controls/side/motors');
      stream.sideMotors = getSideMotors.data['data'];
      print('##### homePage GET sideMotors list : ${stream.sideMotors}');
      print('##### homePage sideMotors List length : ${stream.sideMotors.length}');

      // side motor name 가져오기
      stream.side_motor_name  = stream.sideMotors.map((e) => e["motor_name"].toString()).toList();
      print('## [homepage] side motor name 가져오기: ${stream.side_motor_name}');

      // DB에서 side motor 상태 가져오기
      stream.sideMotorStatus = stream.sideMotors.map((e) => e["motor_action"].toString()).toList();
      print('## [homepage] side motor status 가져오기: ${stream.sideMotorStatus}');

      // DB에서 side motors id 가져오기
      // for문으로 가져오지 않은 이유? 앱을 새로 실행할 때마다 for문이 돌면서 값을 지속적으로 추가시키는 문제 발생
      stream.side_motor_id  = stream.sideMotors.map((e) => e["motor_id"].toString()).toList();
      print('## [homepage] side motor id 가져오기: ${stream.side_motor_id}');

      // ## top motor --------
      final getTopMotors = await dio.get('$url/$userId/site/$siteId/controls/top/motors');
      stream.topMotors = getTopMotors.data['data'];
      print('##### homePage GET topMotors list : ${stream.topMotors}');
      print('##### homePage topMotors List length : ${stream.topMotors.length}');

      // DB에서 top motor name 가져오기
      stream.top_motor_name  = stream.topMotors.map((e) => e["motor_name"].toString()).toList();
      print('## [homepage] top motor name 가져오기: ${stream.top_motor_name}');

      // DB에서 top motor id 가져오기
      stream.top_motor_id  = stream.topMotors.map((e) => e["motor_id"].toString()).toList();
      print('## [homepage] top motor id 가져오기: ${stream.top_motor_id}');

      // DB에서 top motor 상태 가져오기
      stream.topMotorStatus = stream.topMotors.map((e) => e["motor_action"].toString()).toList();
      print('## [homepage] top motor status 가져오기: ${stream.topMotorStatus}');

      stream.mqttTopMotorStatus = [
        stream.motor_1 == 'open'
            ? 0
            : stream.motor_1 == 'stop'
                ? 1
                : 2,
        stream.motor_2 == 'open'
            ? 0
            : stream.motor_2 == 'stop'
                ? 1
                : 2,
        stream.motor_3 == 'open'
            ? 0
            : stream.motor_3 == 'stop'
                ? 1
                : 2,
        // stream.motor_4 == 'open' ? 0 : stream.motor_4 == 'stop' ? 1 : 2,
        // stream.motor_5 == 'open' ? 0 : stream.motor_5 == 'stop' ? 1 : 2,
        // stream.motor_6 == 'open' ? 0 : stream.motor_6 == 'stop' ? 1 : 2,
        // stream.motor_6 == 'open' ? 1 : 0, // motor 7개
        stream.pump_1 == 'on' ? 1 : 0,
        stream.pump_1 == 'on' ? 1 : 0, // on/off pump ㅇㅇ
        stream.pump_2 == 'on' ? 1 : 0,
      ];

      stream.mqttSideMotorStatus = [
        stream.motor_4 == 'open'
            ? 0
            : stream.motor_4 == 'stop'
                ? 1
                : 2,
        stream.motor_5 == 'open'
            ? 0
            : stream.motor_5 == 'stop'
                ? 1
                : 2,
        stream.motor_6 == 'open'
            ? 0
            : stream.motor_6 == 'stop'
                ? 1
                : 2,
      ];
      print('motorStatus: ${stream.mqttTopMotorStatus}');

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
        stream.pump_1 == 'on' ? 0 : 1,
        stream.pump_2 == 'on' ? 0 : 1,
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

      stream.valveStatus = [
        stream.valve_1 == 'open' ? 0 : 1,
        // stream.valve_2 == 'on' ? 0 : 1,
      ];
      print('valveStatus: ${stream.valveStatus}');

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
    Get.offAllNamed('/sensor');
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 1);
  }
}
