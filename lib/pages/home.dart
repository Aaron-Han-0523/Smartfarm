// necessary to build app
import 'package:edgeworks/data/get_data.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// dio
import 'package:dio/dio.dart';
// env
import 'package:flutter_dotenv/flutter_dotenv.dart';
// mqtt
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// global
import '../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;
import '../globals/siteConfig.dart' as sites;

/*
* name : Home (get Data page)
* description : get Data
* writer : sherry
* create date : 2022-01-10
* last update : 2022-02-03
* */

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
// var siteId = '${stream.siteId}';
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

    Future.delayed(const Duration(milliseconds: 500), () async {
       _getAllData.getSiteData(userId);
        _getAllData.putFcmData(userId);
       await Get.offAllNamed('/sensor');
      // getData();
    });

    super.initState();
  }

  // getData -----------------------------> 작업 진행 중
  Future<dynamic> getData() async {
    if (mounted) {
      // // Site Id 가져오기
      // final getSiteId =
      // await dio.get('$url/$userId/sites');
      // stream.siteId = getSiteId.data[0]["sid"];
      print('##### [homepage] Site Id는  : ${stream.siteId}');
      print('##### [homepage] Site Id는  : ${siteId}');
      print('##### [homepage] Site Id는  : ${userId}');
      // Site Id 전체 가져와서 담기
      // final getSiteIds = await dio.get('$url/$userId/sites');
      // stream.siteInfo = getSiteIds.data;
      // print('##### [homepage] Site Info는  : ${stream.siteInfo}');
      // // Site names 가져오기
      // stream.siteNames =
      //     stream.siteInfo.map((e) => e["site_name"].toString()).toList();
      // print('## [homepage] Site Ids는 가져오기: ${stream.siteNames}');
      //
      // // put fcm token
      // var fcmtoken = stream.fcmtoken;
      // var data = {'uid': userId, 'fcmtoken': fcmtoken};
      // final postToken =
      // await dio.put('$api/farm/$userId/pushAlarm', data: data);
      // print('##### [homepage] postToken: $postToken');

      // // trends innerTemp
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
      }

      // cctvs
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

      //----------motor----------------------------------------------
      // ## side motor -----------
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

      // ## top motor --------
      final getTopMotors =
      await dio.get('$url/$userId/site/$siteId/controls/top/motors');
      stream.topMotors = getTopMotors.data['data'];
      print('##### [homePage] GET topMotors list : ${stream.topMotors}');
      print(
          '##### [homePage] topMotors List length : ${stream.topMotors.length}');

      // DB에서 top motor name 가져오기
      stream.top_motor_name =
          stream.topMotors.map((e) => e["motor_name"].toString()).toList();
      print('## [homepage] top motor name 가져오기: ${stream.top_motor_name}');

      // DB에서 top motor id 가져오기
      stream.top_motor_id =
          stream.topMotors.map((e) => e["motor_id"].toString()).toList();
      print('## [homepage] top motor id 가져오기: ${stream.top_motor_id}');

      // mqtt로 보낼 id 값 파싱
      for (var i = 0; i < stream.topMotors.length; i++) {
        // stream.sideMotorId.clear();
        var topMotor = (stream.topMotors[i]['motor_id']).toString();
        var topMotorId = topMotor.substring(6);
        stream.topMotorId.add(topMotorId);
        print('## [homepage] top motor id 가져오기: ${stream.topMotorId}');
      }

      // DB에서 top motor 상태 가져오기
      stream.topMotorStatus = stream.topMotors
          .map((e) => int.parse(e["motor_action"].toString()))
          .toList();
      print('## [homepage] top motor status 가져오기: ${stream.topMotorStatus}');

      // ## etc 상태 가져오기
      final getEtcMotors =
      await dio.get('$url/$userId/site/$siteId/controls/actuators');
      stream.etcMotors = getEtcMotors.data;
      // DB에서 etc motor name 가져오기
      stream.etc_motor_name =
          stream.etcMotors.map((e) => e["actuator_name"].toString()).toList();
      print('## [homepage] etc motor name 가져오기: ${stream.etc_motor_name}');
      // DB에서 etc motor 상태 가져오기
      // stream.etcMotorStatus.clear();
      stream.etcMotorStatus = stream.etcMotors
          .map((e) => int.parse(e["actuator_action"].toString()))
          .toList();
      print('## [homepage] etc motor status 가져오기: ${stream.etcMotorStatus}');

      // DB에서 etc motor id 가져오기
      stream.etcMotorId =
          stream.etcMotors.map((e) => e["motor_id"].toString()).toList();
      print('## [homepage] etc motor id 가져오기: ${stream.etcMotorId}');

      // for (var i = 0; i < stream.etcMotors.length; i++) {
      //   // stream.sideMotorId.clear();
      //   var etcMotor = (stream.etcMotors[i]['motor_id']).toString();
      //   var etcMotorId = etcMotor.substring(6);
      //   stream.etcMotorId.add(etcMotorId);
      //   stream.etcMotorId.clear();
      //
      //   print('## [homepage] etc motor id 가져오기: ${stream.etcMotorId}');
      // }

      //----------pumps----------------------------------------------
      final getPumps =
      await dio.get('$url/$userId/site/$siteId/controls/pumps');
      stream.pumps = getPumps.data;
      print('##### [homePage] GET Pumps LIST: ${stream.pumps}');
      print('##### [homePage] Pumps LIST length: ${stream.pumps.length}');

      // DB에서 pump 상태 가져오기
      stream.pumpStatus = stream.pumps
          .map((e) => int.parse(e["pump_action"].toString()))
          .toList();
      print('## [homepage] pump status 가져오기: ${stream.pumpStatus}');

      // DB에서 pump name 가져오기
      stream.pump_name =
          stream.pumps.map((e) => e["pump_name"].toString()).toList();
      print('## [homepage] pump name 가져오기: ${stream.pump_name}');

      // get pump1, pump2 = sensorId
      final getSensorId = await dio.get('$url/$userId/site/$siteId/sensors');
      stream.sensors = getSensorId.data;
      print('##### [homePage] GET Sensors LIST: ${stream.sensors}');
      print('##### [homePage] Sensors LIST length: ${stream.sensors.length}');
      stream.sensor_id = [];
      for (var i = 0; i < stream.sensors.length; i++) {
        String sensorId = stream.sensors[i]['sensor_id'];
        if (sensorId.contains('pump') == true) {
          stream.sensor_id.add(sensorId);
          print('$i) 이 sensorId($sensorId)는 pump가 맞습니다.');
        } else {
          print('$i) 이 sensorId($sensorId)는 pump가 아닙니다.');
        }
        print('##### [homePage] sensorId LIST: ${stream.sensor_id}');
      }

      //----------valves----------------------------------------------
      final getValves =
      await dio.get('$url/$userId/site/$siteId/controls/valves');
      stream.valves = getValves.data;
      print('##### [homePage] GET Valves LIST: ${stream.valves}');
      print('##### [homePage] GET Valves LIST length: ${stream.valves.length}');

      // DB에서 valve 상태 가져오기
      stream.valveStatus = stream.valves
          .map((e) => int.parse(e["valve_action"].toString()))
          .toList();
      print('## [homepage] valve status 가져오기: ${stream.pumpStatus}');

      // DB에서 valve name 가져오기
      stream.valve_name =
          stream.valves.map((e) => e["valve_name"].toString()).toList();
      print('## [homepage] valve name 가져오기: ${stream.valve_name}');

      connect();
    }

    return true;
  }

  String statusText = "Status Text";
  bool isConnected = false;
  final MqttServerClient client = MqttServerClient('14.46.231.48', '');

  connect() async {
    isConnected = await mqttConnect('test');
  }

  _disconnect() {
    client.disconnect();
  }

  Future<bool> mqttConnect(String uniqueId) async {
    client.logging(on: true);
    client.port = clientPort;
    client.secure = false;
    // client.onConnected = onConnected;
    // client.onDisconnected = onDisconnected;
    // client.pongCallback = pong;

    final MqttConnectMessage connMess =
    MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to Successfully!");
    } else {
      return false;
    }
    var topic = setSubTopic;
    client.subscribe(topic, MqttQos.atMostOnce);
    var pubTopic = setPubTopic;
    final builder = MqttClientPayloadBuilder();
    builder.addString('{"rt" : "get"}');
    // builder.addString('open');
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final mqttReceivedMessages = c;
      final recMess = mqttReceivedMessages[0].payload as MqttPublishMessage;

      var streamData =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      var streamDatas = jsonDecode(streamData);
      print('[homepage] streamDatas = ${streamDatas}');
      sites.status_alarm = streamDatas['alarm_en'] as bool;
      sites.low_temp = streamDatas['alarm_low_temp'].toString();
      sites.high_temp = streamDatas['alarm_high_temp'].toString();
      sites.set_timer = streamDatas['watering_timer'].toString();
      sites.site_name = streamDatas['sname'].toString();

      _disconnect();
      Get.offAllNamed('/sensor');
      // 카카오 채널 drawer 뒤로가기 제어를 위해 offAllNamed라고 설정해야함
    });

    return true;
  }

  Widget build(BuildContext context) {
    return Opacity(opacity: 0);
  }
}
