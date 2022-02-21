// ** SETTING CONTROLLER **

// Necessary to build app
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

// Env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Dio
import 'package:dio/dio.dart';

// Mqtt
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// Global
import 'package:edgeworks/globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;

//Api's
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';
var userId = '${edgeworks.checkUserId}';

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var mqttIP = dotenv.env['MQTT_IP'];

// Dio
Dio dio = Dio();

// mqtt
// int clientPort = 1883;
int clientPort = int.parse('${dotenv.env['MQTT_PORT']}');
var setSubTopic = '/sf/$siteId/res/cfg';
var setPubTopic = '/sf/$siteId/req/cfg';

class SettingController extends GetxController {
  RxBool status_alarm = false.obs;
  var low_temp = ''.obs;
  var high_temp = ''.obs;
  var set_timer = ''.obs;
  var site_name = ''.obs; // DB에 저장된 valve status 가져오기

  String statusText = "Status Text";
  bool isConnected = false;
  final MqttServerClient client = MqttServerClient('$mqttIP', '');

  connect() async {
    isConnected = await mqttConnect('test');
  }

  _disconnect() {
    client.disconnect();
  }

  Future<bool> mqttConnect(String uniqueId) async {
    print('setting mqtt');

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
      status_alarm.value = streamDatas['alarm_en'];
      low_temp.value = streamDatas['alarm_low_temp'].toString();
      high_temp.value = streamDatas['alarm_high_temp'].toString();
      set_timer.value = streamDatas['watering_timer'].toString();
      site_name.value = streamDatas['sname'].toString();
      print('status_alarm.value ${set_timer.value}');
      _disconnect();
      // 카카오 채널 drawer 뒤로가기 제어를 위해 offAllNamed라고 설정해야함
    });

    return true;
  }
}
