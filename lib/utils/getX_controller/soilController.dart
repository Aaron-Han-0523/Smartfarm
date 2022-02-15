// // necessary to build app
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:get/get.dart';
// import 'dart:convert';

// // global
// import '/globals/stream.dart' as stream;

// //Api's
// var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// // APIs
// var api = dotenv.env['PHONE_IP'];
// var url = '$api/farm';

// var options = BaseOptions(
//   baseUrl: '$url',
//   connectTimeout: 5000,
//   receiveTimeout: 3000,
// );
// Dio dio = Dio(options);

// class SoilController extends GetxController {
//   var innerTemp = ''.obs;
//   var extTemp = ''.obs;
//   var soilTemp = ''.obs;
//   var innerHumid = ''.obs;
//   var extHumid = ''.obs;
//   var soilHumid = ''.obs;

//   Future<void> soilHttp() async {
//     final getPumps =
//           await dio.get('$url/$userId/site/$siteId/controls/pumps');
//       stream.pumps = getPumps.data;
//       print('##### [homePage] GET Pumps LIST: ${stream.pumps}');
//       print('##### [homePage] Pumps LIST length: ${stream.pumps.length}');

//       // DB에서 pump 상태 가져오기
//       stream.pumpStatus = stream.pumps
//           .map((e) => int.parse(e["pump_action"].toString()))
//           .toList();
//       print('## [homepage] pump status 가져오기: ${stream.pumpStatus}');

//       // DB에서 pump name 가져오기
//       stream.pump_name =
//           stream.pumps.map((e) => e["pump_name"].toString()).toList();
//       print('## [homepage] pump name 가져오기: ${stream.pump_name}');

//       // get pump1, pump2 = sensorId
//       final getSensorId = await dio.get('$url/$userId/site/$siteId/sensors');
//       stream.sensors = getSensorId.data;
//       print('##### [homePage] GET Sensors LIST: ${stream.sensors}');
//       print('##### [homePage] Sensors LIST length: ${stream.sensors.length}');
//       stream.sensor_id = [];
//       for (var i = 0; i < stream.sensors.length; i++) {
//         String sensorId = stream.sensors[i]['sensor_id'];
//         if (sensorId.contains('pump') == true) {
//           stream.sensor_id.add(sensorId);
//           print('$i) 이 sensorId($sensorId)는 pump가 맞습니다.');
//         } else {
//           print('$i) 이 sensorId($sensorId)는 pump가 아닙니다.');
//         }
//         print('##### [homePage] sensorId LIST: ${stream.sensor_id}');
//       }
//   }
// }
