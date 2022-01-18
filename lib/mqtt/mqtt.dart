import 'dart:convert';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../globals/stream.dart' as stream;

/*
* name : MQTT class
* description : MQTT class
* writer : mark
* create date : 2021-01-07
* last update : 2021-01-17
* */

class MqttClass {

  // MQTT
  String statusText = "Status Text";
  // bool isConnected = false;
  final MqttServerClient client =
  MqttServerClient('broker.mqttdashboard.com', '');

  // var alarm_en = ''.obs;
  // var alarm_high_temp = ''.obs;
  // var alarm_low_temp = ''.obs;
  // var watering_timer = ''.obs;


  //MQTT SITE CONFIG SET - subscribe
  Future<bool> getSiteConfig() async {

    client.logging(on: true);
    client.port = 1883;
    client.secure = false;

    final MqttConnectMessage connMess =
    MqttConnectMessage().withClientIdentifier('3').startClean();
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }
    const topic = '/sf/e0000001/res/cfg';
    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final mqttReceivedMessages = c;
      final recMess = mqttReceivedMessages[0].payload as MqttPublishMessage;

      var streamData =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      var streamDatas = jsonDecode(streamData);
      print('!!!!!!!!!!!!!!');
      print('setting data는 : $streamDatas');
      stream.alarm_en = streamDatas['alarm_en'].toString();
      stream.alarm_high_temp = streamDatas['alarm_high_temp'].toString();
      stream.alarm_low_temp = streamDatas['alarm_low_temp'].toString();
      stream.watering_timer = streamDatas['watering_timer'].toString();
    });
    return true;
  }


  //MQTT MOTOR & PUMP CTRL - publish
  Future<dynamic> allSet(var did, var len, var dact, String dactValue, var subscibeTopic, var publishTopic) async {

    client.logging(on: true);
    client.port = 1883;
    client.secure = false;
    final MqttConnectMessage connMess =
    MqttConnectMessage().withClientIdentifier('3').startClean(); // userid를 global에 저장하고 shared 해서 불러온다음 id 값 함수에 인자로 받아서 넣어주기
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }

    var topic = subscibeTopic;
    client.subscribe(topic, MqttQos.atMostOnce);

    var pubTopic = publishTopic;
    final builder = MqttClientPayloadBuilder();

    // publish data
    for (int i=0;i<len;i++ ){
      builder.clear();
      builder.addString('{"rt" : "set", "$did" : ${i + 1}, "$dact" : "$dactValue"}');

      client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
      // client.publishMessage(publishTopic, MqttQos.atLeastOnce, builder.payload!);
    }


    return true;
  }

  Future<dynamic> ctlSet(var did, var dicValue, var dact, String dactValue, var subscibeTopic, var publishTopic) async {

    client.logging(on: true);
    client.port = 1883;
    client.secure = false;
    final MqttConnectMessage connMess =
    MqttConnectMessage().withClientIdentifier('3').startClean(); // userid를 global에 저장하고 shared 해서 불러온다음 id 값 함수에 인자로 받아서 넣어주기
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }

    var topic = subscibeTopic;
    client.subscribe(topic, MqttQos.atMostOnce);

    var pubTopic = publishTopic;
    final builder = MqttClientPayloadBuilder();

    // publish data
    builder.addString('{"rt" : "set", "$did" : $dicValue, "$dact" : "$dactValue"}');

    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    // client.publishMessage(publishTopic, MqttQos.atLeastOnce, builder.payload!);

    return true;
  }


  //MQTT SITE CONFIG SET - publish
  Future<dynamic> configSet (String dact, var dactValue, var subscibeTopic, var publishTopic) async {

    client.logging(on: true);
    client.port = 1883;
    client.secure = false;
    final MqttConnectMessage connMess =
    MqttConnectMessage().withClientIdentifier('3').startClean();// userid를 global에 저장하고 shared 해서 불러온다음 id 값 함수에 인자로 받아서 넣어주기
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }

    var topic = subscibeTopic;
    client.subscribe(topic, MqttQos.atMostOnce);

    var pubTopic = publishTopic;
    final builder = MqttClientPayloadBuilder();

    // publish data
    builder.addString('{"rt" : "set", "$dact" : $dactValue}');

    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    // client.publishMessage(publishTopic, MqttQos.atLeastOnce, builder.payload!);

    return true;
  }


  //MQTT SITE CONFIG SET - publish
  Future<dynamic> setConfig (var alarmValue, var highTempValue, var lowTempValue, var timerValue, var subscibeTopic, var publishTopic) async {

    client.logging(on: true);
    client.port = 1883;
    client.secure = false;
    final MqttConnectMessage connMess =
    MqttConnectMessage().withClientIdentifier('3').startClean();// userid를 global에 저장하고 shared 해서 불러온다음 id 값 함수에 인자로 받아서 넣어주기
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }

    var topic = subscibeTopic;
    client.subscribe(topic, MqttQos.atMostOnce);

    var pubTopic = publishTopic;
    final builder = MqttClientPayloadBuilder();

    // publish data
    builder.addString('{"rt":"set", "alarm_en":$alarmValue, "alarm_high_temp":$highTempValue, "alarm_low_temp":$lowTempValue, "watering_timer":$timerValue}');
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);

    return true;
  }







}
