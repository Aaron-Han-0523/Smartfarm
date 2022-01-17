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
    const topic = '/sf/e0000001/data';
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
      // trap = 1;
      // }
      print('stream.temp_1 = ${stream.temp_1}');
      print('innerTemp = ${innerTemp}');
    });

    return true;
  }
}
