// necessary to build app
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

// global
import '/globals/stream.dart' as stream;
import "/globals/checkUser.dart" as edgeworks;

//Api's
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';
var userId = '${edgeworks.checkUserId}';

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';

var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

class SoilController extends GetxController {
  var pumps = [].obs;
  var sensors = [].obs;
  var sensor_id = [].obs;
  var pump_name = [].obs;
  var pumpStatus = [].obs; // DB에 저장된 pump status 가져오기
  var valves = [].obs;
  var valve_name = [].obs;
  var valveStatus = [].obs; // DB에 저장된 valve status 가져오기

  Future<void> pumpsHttp() async {
    final getPumps = await dio.get('$url/$userId/site/$siteId/controls/pumps');
    pumps.value = getPumps.data;
    print('##### [homePage] GET Pumps LIST: ${pumps}');
    print('##### [homePage] Pumps LIST length: ${pumps.length}');

    // DB에서 pump 상태 가져오기
    pumpStatus.value =
        pumps.map((e) => int.parse(e["pump_action"].toString())).toList();
    print('## [homepage] pump status 가져오기: ${pumpStatus}');

    // DB에서 pump name 가져오기
    pump_name.value = pumps.map((e) => e["pump_name"].toString()).toList();
    print('## [homepage] pump name 가져오기: ${pump_name}');

    // get pump1, pump2 = sensorId
    final getSensorId = await dio.get('$url/$userId/site/$siteId/sensors');
    sensors.value = getSensorId.data;
    print('##### [homePage] GET Sensors LIST: ${sensors}');
    print('##### [homePage] Sensors LIST length: ${sensors.length}');

    for (var i = 0; i < sensors.length; i++) {
      String sensorId = sensors[i]['sensor_id'];
      if (sensorId.contains('pump') == true) {
        sensor_id.add(sensorId);
        print('$i) 이 sensorId($sensorId)는 pump가 맞습니다.');
      } else {
        print('$i) 이 sensorId($sensorId)는 pump가 아닙니다.');
      }
      print('##### [homePage] sensorId LIST: ${sensor_id}');
    }
    update();
  }

  Future<void> valvesHttp() async {
    //----------valves----------------------------------------------
    final getValves =
        await dio.get('$url/$userId/site/$siteId/controls/valves');
    valves.value = getValves.data;
    print('##### [homePage] GET Valves LIST: ${valves}');
    print('##### [homePage] GET Valves LIST length: ${valves.length}');

    // DB에서 valve 상태 가져오기
    valveStatus.value =
        valves.map((e) => int.parse(e["valve_action"].toString())).toList();
    print('## [homepage] valve status 가져오기: ${pumpStatus}');

    // DB에서 valve name 가져오기
    valve_name.value = valves.map((e) => e["valve_name"].toString()).toList();
    print('## [homepage] valve name 가져오기: ${valve_name}');
    update();
  }
}
