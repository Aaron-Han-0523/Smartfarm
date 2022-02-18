import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

// 작업 진행중 ----------------------------------------------

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
// var siteId = '${stream.siteId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// dio APIs
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 60 * 1000,
  receiveTimeout: 60 * 1000,
);
Dio dio = Dio(options);

class _InnerTempData {
  _InnerTempData(this.dateTime, this.tempValue);

  final String dateTime;
  final double tempValue;
}

// 그래프 데이터 관련
List<_InnerTempData> data = [];


class GetAllData {

  // get site id function
  Future<dynamic> getSiteData(var userId) async {

    // Site Id 전체 가져와서 담기
    final getSiteIds = await dio.get('$url/$userId/sites');
    stream.siteInfo = getSiteIds.data;
    print('##### [homepage] Site Info는  : ${stream.siteInfo}');

    // Site names 가져오기
    stream.siteNames =
        stream.siteInfo.map((e) => e["site_name"].toString()).toList();
    print('## [homepage] Site Ids는 가져오기: ${stream.siteNames}');

  }

  // put fcm token function
  Future<dynamic> putFcmData(var userId) async {
    var fcmtoken = stream.fcmtoken;
    var data = {'uid': userId, 'fcmtoken': fcmtoken};
    final postToken =
    await dio.put('$api/farm/$userId/pushAlarm', data: data);
    print('##### [homepage] postToken: $postToken');
    await Get.offAllNamed('/sensor');
  }


  // get trends temp data function
  Future<dynamic> getTrendsTempData() async { //var userId, var siteId

    await Future.delayed(const Duration(milliseconds: 500), () async {
      final getInnerTemp =
      await dio.get('$url/$userId/site/$siteId/innerTemps');
      stream.chartData = getInnerTemp.data['data'];

      if (stream.chartData.length != 0) {

        print('##### [homepage] getInnerTemp: ${getInnerTemp.data['data']}');
        print(
            '##### [homepage] getInnerTemp 최근 내부온도 시간: ${getInnerTemp.data['data'][0]['time_stamp']}');

        var date = getInnerTemp.data['data'][0]['time_stamp'];
        var yyyyMMddE = date.substring(0, 10);
        yyyyMMddE = yyyyMMddE.replaceAll('-', '');
        yyyyMMddE = DateFormat('yyyy년 MM월 dd일')
            .format(DateTime.parse(yyyyMMddE))
            .toString();
        var hhMMss = date.substring(11, 19);

        print(
            '##### [homepage] getInnerTemp 최근 내부온도 온도: ${getInnerTemp.data['data'][0]['value']}');


        int innerTempLength = getInnerTemp.data['data'].length;
        print('[homepage] innerTempLength: $innerTempLength');
        print('[차트 데이터 확인] : ${stream.chartData}');

        for (var i = 0; i < stream.chartData.length; i++) {
          data.add(_InnerTempData(stream.chartData[i]['time_stamp'],
              double.parse(stream.chartData[i]['value'])));
        }
      }
    });
  }

  // cctv
  // get trends temp data function
  Future<dynamic> getCctvData() async { //var userId, var siteId
    final getCctvs = await dio.get('$url/$userId/site/$siteId/cctvs');
    stream.cctvs = getCctvs.data;
    print('##### [homepage] GET CCTV List from stream: ${stream.cctvs}');
    print('##### [homepage] GET CCTV List length: ${stream.cctvs.length}');
    stream.cctv_url = [];
    for (var i = 0; i < stream.cctvs.length; i++) {
      var cctvUrl = stream.cctvs[i]['cctv_url'];
      stream.cctv_url.add(cctvUrl);
    }
    print('##### [homepage] GET CCTV Url List: ${stream.cctv_url}');
  }

  Future<dynamic> getSideMotorData(var motorTypeVariable,
      var streamMotorType,
      var streamMotorName,
      var streamMotorStatus,
      var streamMotorId,
      var motorNameVariable,
      var motorIdVariable
      ) async {

    await Future.delayed(const Duration(milliseconds: 500), () async {
      motorTypeVariable =
      await dio.get('$url/$userId/site/$siteId/controls/side/motors');
      streamMotorType = motorTypeVariable.data['data'];
      print('##### [homePage] GET sideMotors list : $streamMotorType');

      // side motor name 가져오기
      streamMotorName =
          streamMotorType.map((e) => e["motor_name"].toString()).toList();
      print('## [homepage] side motor name 가져오기: $streamMotorName');

      // DB에서 side motor 상태 가져오기
      streamMotorStatus = streamMotorType
          .map((e) => int.parse(e["motor_action"].toString()))
          .toList();
      print('## [homepage] side motor status 가져오기: $streamMotorStatus');

      // DB에서 side motors id 가져오기
      // for문으로 가져오지 않은 이유? 앱을 새로 실행할 때마다 for문이 돌면서 값을 지속적으로 추가시키는 문제 발생
      streamMotorId =
          streamMotorType.map((e) => e["motor_id"].toString()).toList();
      print('## [homepage] side motor id 가져오기: $streamMotorId');

      // mqtt로 보낼 id 값 파싱
      for (var i = 0; i < streamMotorId.length; i++) {
        // stream.sideMotorId.clear();
        motorNameVariable = (streamMotorId[i]['motor_id']).toString();
        motorIdVariable = motorNameVariable.substring(6);
        streamMotorId.add(motorIdVariable);
        print('## [homepage] side motor id 가져오기: $streamMotorId');
      }}
    );
  }
  }