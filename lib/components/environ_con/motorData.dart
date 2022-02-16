// necessary to build app
import 'package:edgeworks/data/get_data.dart';

// dio
import 'package:dio/dio.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// global
import 'package:edgeworks/globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;
import 'package:edgeworks/globals/siteConfig.dart' as sites;


/*
* name : Motor Data (get Data page)
* description : get motor Data
* writer : mark
* create date : 2022-02-15
* last update : 2022-02-15
* */

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// get all data
GetAllData _getAllData = GetAllData();

// mqtt
int clientPort = 1883;
var setSubTopic = '/sf/$siteId/res/cfg';
var setPubTopic = '/sf/$siteId/req/cfg';

// dio APIs
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

class GetMotorData {
  Future<dynamic> getSideMotorData() async {

    final getSideMotors =
    await dio.get('$url/$userId/site/$siteId/controls/side/motors');
    stream.sideMotors = getSideMotors.data['data'];
    print('##### [homePage] GET sideMotors list : ${stream.sideMotors}');
    print(
        '##### [homePage] sideMotors List length : ${stream.sideMotors.length}');

    // side motor name 가져오기
    stream.side_motor_name =
        stream.sideMotors.map((e) => e["motor_name"].toString()).toList();
    print('## [homepage] side motor name 가져오기: ${stream.side_motor_name}');

    // DB에서 side motor 상태 가져오기
    stream.sideMotorStatus = stream.sideMotors
        .map((e) => int.parse(e["motor_action"].toString()))
        .toList();
    print('## [homepage] side motor status 가져오기: ${stream.sideMotorStatus}');

    // DB에서 side motors id 가져오기
    // for문으로 가져오지 않은 이유? 앱을 새로 실행할 때마다 for문이 돌면서 값을 지속적으로 추가시키는 문제 발생
    stream.side_motor_id =
        stream.sideMotors.map((e) => e["motor_id"].toString()).toList();
    print('## [homepage] side motor id 가져오기: ${stream.side_motor_id}');

    // mqtt로 보낼 id 값 파싱
    for (var i = 0; i < stream.sideMotors.length; i++) {
      // stream.sideMotorId.clear();
      var sideMotorName = (stream.sideMotors[i]['motor_id']).toString();
      var sideMotorId = sideMotorName.substring(6);
      stream.sideMotorId.add(sideMotorId);
      print('## [homepage] side motor id 가져오기: ${stream.sideMotorId}');
    }
  }

}
