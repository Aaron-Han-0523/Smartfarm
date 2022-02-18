// [DB UPDATE] Side/Top/Etc motor 업데이트

// Necessary to build app
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Global
import '../../globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// Dio
Dio dio = Dio();


class UpdateSideTopEtcToggleData {

  // [Function] Update DB - 전체 Side/Top 데이터
  Future<void> updateAllMotorData(
      var motorAction,
      var updateMotorType) async {

    var params = {
      'motor_action': motorAction,
    };

    var response = await dio.put(
        '$url/$userId/site/$siteId/controls/$updateMotorType/motors',
        data: params);

    print('[environment page] 사이드 전체 모터 타입 변경 완료 : $response');
  }

  Future<void> updateSideTopMotorData(
      var motorName,
      var motorType,
      var motorAction,
      var updateMotorType,
      var motorId) async {

    var params = {
      'motor_name': motorName,
      'motor_type': motorType,
      'motor_action': motorAction,
    };

    var response = await dio.put(
        '$url/$userId/site/$siteId/controls/$updateMotorType/motors/$motorId',
        data: params);

    print('[environment page] 모터 타입 변경 완료 : $response');
    // 변경 완료 시 응답 결과 : 1
    // 변경 되어 있을 경우 응답 결과 : 0
  }

  // [Function] Update DB - Etc motor 개별 데이터
  Future<void> updateEtcMotorData(
      var motorAction,
      var motorId) async {

    var params = {
      // 'motor_name': motorName,
      'actuator_action': motorAction,
    };

    var response = await dio.put(
        '$url/$userId/site/$siteId/controls/actuators/$motorId',
        data: params);
    print('[environment page] etc 모터 타입 변경 완료 : $response');
  }

}