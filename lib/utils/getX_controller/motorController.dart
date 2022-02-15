// necessary to build app
import 'dart:convert';

import 'package:get/get.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// dio
import 'package:dio/dio.dart';

// global
import 'package:edgeworks/globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

// mqtt
int clientPort = 1883;
var setTopic = '/sf/$siteId/data';

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
// var siteId = '${stream.siteId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// Dio
var dio = Dio();

class MotorController extends GetxController {
  List<dynamic> sideMotors = [].obs;
  List sideMotorName = [].obs;
  List<int> sideMotorStatus = RxList([]);
  List sideMotorId = [].obs;

  var sideMotorNameVariable = '';
  var sideMotorIdVariable = '';

  Future<dynamic> getMotorsData() async {
    final getSideMotors =
    await dio.get('$url/$userId/site/$siteId/controls/side/motors');
    sideMotors = getSideMotors.data['data'];
    print('##### [homePage] GET sideMotors list : $sideMotors');
    print('##### [homePage] sideMotors List length : ${sideMotors.length}');

    // side motor name 가져오기
    sideMotorName = sideMotors.map((e) => e["motor_name"].toString()).toList();
    print('## [homepage] side motor name 가져오기: $sideMotorName');

    // DB에서 side motor 상태 가져오기
    sideMotorStatus = sideMotors
        .map((e) => int.parse(e["motor_action"].toString()))
        .toList();
    print('## [homepage] side motor status 가져오기: $sideMotorStatus');

    sideMotorId =
        sideMotors.map((e) => e["motor_id"].toString()).toList();
    print('## [homepage] side motor id 가져오기: $sideMotorId');

    // mqtt로 보낼 id 값 파싱
    sideMotorId.clear();
    for (var i = 0; i < sideMotors.length; i++) {
      // stream.sideMotorId.clear();
      sideMotorNameVariable = (sideMotors[i]['motor_id']).toString();
      sideMotorIdVariable = sideMotorNameVariable.substring(6);
      sideMotorId.add(sideMotorIdVariable);
      print('## [homepage] side motor id 가져오기: $sideMotorId');
    }
  }

}