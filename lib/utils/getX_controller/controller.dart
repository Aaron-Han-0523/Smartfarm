// necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
// mqtt
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// global
import '/globals/stream.dart' as stream;

//Api's
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// mqtt
int clientPort = 1883;
var setTopic = '/sf/$siteId/data';


class CounterController extends GetxController {
  String statusText = "Status Text";
  bool isConnected = false;
  final MqttServerClient client =
      MqttServerClient('14.46.231.48', '');
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
            color: Color(0xff222222), scale: 15);
  }

  getWeatherStatus(var streamExtTemp_1){
    var extTemp = streamExtTemp_1; // 외부온도
    var temp = int.parse(extTemp);
    return temp > 20
        ? Text('맑음/$streamExtTemp_1°C',
        style: _textStyle(Color(0xff222222), FontWeight.w600, 16))
        : Text('흐림/$streamExtTemp_1°C',
        style: _textStyle(Color(0xff222222), FontWeight.w600, 16));
  }

  // text
  TextStyle _textStyle(dynamic _color, dynamic _weight, double _size) {
    return TextStyle(color: _color, fontWeight: _weight, fontSize: _size);
  }

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
    var topic = setTopic;
    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final mqttReceivedMessages = c;
      final recMess = mqttReceivedMessages[0].payload as MqttPublishMessage;

      var streamData =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      var streamDatas = jsonDecode(streamData);

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
    });
    return true;
  }

  // 날씨 데이터에 따라 이미지 변화
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
