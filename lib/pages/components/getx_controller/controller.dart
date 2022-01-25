import 'package:get/get.dart';
import '/globals/stream.dart' as stream;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class CounterController extends GetxController {
  String statusText = "Status Text";
  bool isConnected = false;
  final MqttServerClient client =
      MqttServerClient('broker.mqttdashboard.com', '');
  var innerTemp = ''.obs;
  var extTemp = ''.obs;
  var soilTemp = ''.obs;
  var innerHumid = ''.obs;
  var extHumid = ''.obs;
  var soilHumid = ''.obs;

  getWeather(var streamExtTemp_1) {
    var extTemp = streamExtTemp_1; // 외부온도
    var temp = int.parse(extTemp);
    return temp > 20
        ? Image.asset('assets/images/icon_shiny.png',
            color: Color(0xff222222), scale: 3)
        : Image.asset('assets/images/icon_windy.png',
            color: Color(0xff222222), scale: 3);
  }

  //Api's
  var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

  connect() async {
    isConnected = await mqttConnect('test');
  }

  _disconnect() {
    client.disconnect();
  }

  Future<bool> mqttConnect(String uniqueId) async {
    // setStatus("Connecting MQTT Broker");

    client.logging(on: true);
    // client.keepAlivePeriod = 20;
    client.port = 1883;
    client.secure = false;
    // client.onConnected = onConnected;
    // client.onDisconnected = onDisconnected;
    // client.pongCallback = pong;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }
    var topic = '/sf/$siteId/data';
    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final mqttReceivedMessages = c;
      // print('img width = ${mqttReceivedMessages}');
      // print('img width = ${mqttReceivedMessages.runtimeType}');
      // print('img width = ${mqttReceivedMessages![0]}');
      final recMess = mqttReceivedMessages[0].payload as MqttPublishMessage;

      // print('recMess = ${recMess}');
      // print('recMess = ${recMess.runtimeType}');
      // print('recMess = ${recMess}');
      var streamData =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      var streamDatas = jsonDecode(streamData);

      // Mqtt 상에서 motor id 추출을 위해 map으로 묶고, key 추출
      var data = jsonDecode(streamData);
      Map map = data;
      var map_key = map.keys;
      print("##### Data의 key는 : $map_key");

      // motor_id가 아닌 것은 삭제
      map.remove('s');
      map.remove('t');
      map.remove('temp_1');
      map.remove('humid_1');
      map.remove('exttemp_1');
      map.remove('soiltemp_1');
      map.remove('soilhumid_1');
      map.remove('soiltemp_2');
      map.remove('soilhumid_1');
      map.remove('soilhumid_2');
      map.remove('valve_1');
      map.remove('pump_1');
      map.remove('pump_2');
      // motor_id만 저장된 data를 리스트로 변환
      print("##### motor_id만 추출 : ${map_key.toList()}");

      // 추출한 motor_id를 stream 폴더에 motor_id 리스트에 넣어줌
      stream.motor_id = map_key.toList();
      print("##### 저장된 motor_id 리스트 가져오기 : ${stream.motor_id}");
      print('!!!!!!!!!!!!!!');

      innerTemp.value = streamDatas['temp_1'].toString();
      extTemp.value = streamDatas['exttemp_1'].toString();
      soilTemp.value = streamDatas['soiltemp_1'].toString();
      innerHumid.value = streamDatas['soiltemp_2'].toString();
      extHumid.value = streamDatas['soilhumid_1'].toString();
      soilHumid.value = streamDatas['soilhumid_2'].toString();
      stream.temp_1 = streamDatas['temp_1'].toString();
      stream.humid_1 = streamDatas['humid_1'].toString();
      stream.exttemp_1 = streamDatas['exttemp_1'].toString();
      stream.soiltemp_1 = streamDatas['soiltemp_1'].toString();
      stream.soiltemp_2 = streamDatas['soiltemp_2'].toString();
      stream.soilhumid_1 = streamDatas['soilhumid_1'].toString();
      stream.soilhumid_2 = streamDatas['soilhumid_2'].toString();
      stream.valve_1 = streamDatas['valve_1'].toString();
      stream.pump_1 = streamDatas['pump_1'].toString();
      stream.pump_2 = streamDatas['pump_2'].toString();
      stream.motor_1 = streamDatas['motor_1'].toString();
      stream.motor_2 = streamDatas['motor_2'].toString();
      stream.motor_3 = streamDatas['motor_3'].toString();
      stream.motor_4 = streamDatas['motor_4'].toString();
      stream.motor_5 = streamDatas['motor_5'].toString();
      stream.motor_6 = streamDatas['motor_6'].toString();

      // motor_id global key로 저장
      // stream.motor_id =

      // trap = 1;
      // }


      print('stream.temp_1 = ${stream.temp_1}');
      print('innerTemp = ${innerTemp}');
    });

    return true;
  }

  // 날씨 데이터에 따라 이미지지 변화
  // getWearther() {
  //   var temp = int.parse(stream.exttemp_1);
  //
  //   temp > 20
  //       ? Image.asset('assets/images/icon_shiny.png',
  //       color: Color(0xff222222), scale: 3)
  //       : Image.asset('assets/images/icon_windy.png',
  //       color: Color(0xff222222), scale: 3);
  // }

}
