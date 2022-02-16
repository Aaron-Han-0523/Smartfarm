// ** SIDE/TOP/ETC MOTOR CONTROLLER PAGE **

// necessary to build app
import 'package:get/get.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// dio
import 'package:dio/dio.dart';

// global
import 'package:edgeworks/globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;


/*
* name : Motor Controller Page
* description : Motor Controller Page (get motor data from DB)
* writer : mark
* create date : 2021-12-28
* last update : 2022-02-16
* */


// mqtt
int clientPort = 1883;
var setTopic = '/sf/$siteId/data';

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// Dio
var dio = Dio();

class MotorController extends GetxController {

  // side motor
  var sideMotors = [].obs;
  var sideMotorName = [].obs;
  var sideMotorStatus = [].obs;
  var sideMotorId = [].obs;
  var sideMotorId2 = [].obs; // DB로 보낼 아이디
  var sideMotorNameVariable = '';
  var sideMotorIdVariable = '';

  // top motor
  var topMotors = [].obs;
  var topMotorName = [].obs;
  var topMotorStatus = [].obs;
  var topMotorId = [].obs;
  var topMotorId2 = [].obs; // DB로 보낼 아이디
  var topMotorNameVariable = '';
  var topMotorIdVariable = '';

  // etc motor
  var etcMotors = [].obs;
  var etcMotorName = [].obs;
  var etcMotorStatus = [].obs;
  var etcMotorId = [].obs;
  var etcMotorId2 = [].obs; // DB로 보낼 motor 아이디
  var etcMotorNameVariable = '';
  var etcMotorIdVariable = '';


  Future<dynamic> getMotorsData() async {
    final getSideMotors =
    await dio.get('$url/$userId/site/$siteId/controls/side/motors');
    sideMotors.value = getSideMotors.data['data'];
    print('##### [homePage] GET sideMotors list : $sideMotors');
    print('##### [homePage] sideMotors List length : ${sideMotors.length}');

    // side motor name 가져오기
    sideMotorName.value = sideMotors.map((e) => e["motor_name"].toString()).toList();
    print('## [homepage] side motor name 가져오기: $sideMotorName');

    // DB에서 side motor 상태 가져오기
    sideMotorStatus.value = sideMotors
        .map((e) => int.parse(e["motor_action"].toString()))
        .toList();
    print('## [homepage] side motor status 가져오기: $sideMotorStatus');

    sideMotorId.value =
        sideMotors.map((e) => e["motor_id"].toString()).toList();
    print('## [homepage] side motor id 가져오기: $sideMotorId');

    // DB로 보낼 ID 추출
    sideMotorId2.value =
        sideMotors.map((e) => e["motor_id"].toString()).toList();
    print('## [homepage] side motor id 가져오기: $sideMotorId2');


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

  Future<dynamic> getTopMotorsData() async {
    final getTopMotors =
    await dio.get('$url/$userId/site/$siteId/controls/top/motors');
    topMotors.value = getTopMotors.data['data'];
    print('##### [homePage] GET sideMotors list : $topMotors');
    print('##### [homePage] sideMotors List length : ${topMotors.length}');

    // side motor name 가져오기
    topMotorName.value = topMotors.map((e) => e["motor_name"].toString()).toList();
    print('## [homepage] side motor name 가져오기: $topMotorName');

    // DB에서 side motor 상태 가져오기
    topMotorStatus.value = topMotors
        .map((e) => int.parse(e["motor_action"].toString()))
        .toList();
    print('## [homepage] side motor status 가져오기: $topMotorStatus');

    topMotorId.value =
        topMotors.map((e) => e["motor_id"].toString()).toList();
    print('## [homepage] side motor id 가져오기: $topMotorId');

    // DB로 보낼 ID 추출
    topMotorId2.value =
        topMotors.map((e) => e["motor_id"].toString()).toList();
    print('[lib/components/environmentController_page/motorController] top motor id 가져오기: $topMotorId2');

    // mqtt로 보낼 id 값 파싱
    topMotorId.clear();
    for (var i = 0; i < topMotors.length; i++) {
      // stream.sideMotorId.clear();
      topMotorNameVariable = (topMotors[i]['motor_id']).toString();
      topMotorIdVariable = topMotorNameVariable.substring(6);
      topMotorId.add(topMotorIdVariable);
      print('## [homepage] side motor id 가져오기: $topMotorId');
    }
  }

  Future<dynamic> getEtcMotorData() async {
    // ## etc 상태 가져오기
    final getEtcMotors =
    await dio.get('$url/$userId/site/$siteId/controls/actuators');
    etcMotors.value = getEtcMotors.data;
    // DB에서 etc motor name 가져오기
    etcMotorName.value =
        etcMotors.map((e) => e["actuator_name"].toString()).toList();
    print('## [homepage] etc motor name 가져오기: $etcMotorName');
    // DB에서 etc motor 상태 가져오기
    etcMotorStatus.value = etcMotors
        .map((e) => int.parse(e["actuator_action"].toString()))
        .toList();
    print('## [homepage] etc motor status 가져오기: ${stream.etcMotorStatus}');

    // DB에서 etc motor id 가져오기
    etcMotorId.value =
        etcMotors.map((e) => e["motor_id"].toString()).toList();
    print('## [homepage] etc motor id 가져오기: $etcMotorId');

    // DB로 보낼 ID 추출
    etcMotorId2.value =
        etcMotors.map((e) => e["motor_id"].toString()).toList();
    print('[lib/components/environmentController_page/motorController] top motor id 가져오기: $etcMotorId2');

    // mqtt로 보낼 id 값 파싱
    etcMotorId.clear();
    for (var i = 0; i < etcMotors.length; i++) {
      // stream.sideMotorId.clear();
      etcMotorNameVariable = (etcMotors[i]['motor_id']).toString();
      etcMotorIdVariable = etcMotorNameVariable.substring(6);
      etcMotorId.add(etcMotorIdVariable);
      print('## [homepage] etc motor id 가져오기: $etcMotorId');
    }
  }
}