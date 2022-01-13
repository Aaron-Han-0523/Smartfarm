import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


/*
* name : MQTT class
* description : MQTT class
* writer : mark
* create date : 2021-01-07
* last update : 2021-01-07
* */

class MqttClass {

  // MQTT
  String statusText = "Status Text";
  // bool isConnected = false;
  final MqttServerClient client =
  MqttServerClient('broker.mqttdashboard.com', '');

  //MQTT SITE CONFIG SET - subscribe



  //MQTT MOTOR & PUMP CTRL - publish
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
  Future<dynamic> test (String alarm, var alarmValue, String highTemp, String highTempValue, String lowTemp, String lowTempValue, String timer, String timerValue, var subscibeTopic, var publishTopic) async {

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
    builder.addString('{"rt" : "set", "$alarm" : $alarmValue}');
    builder.addString('{"rt" : "set", "$highTemp" : $highTempValue}');
    builder.addString('{"rt" : "set", "$lowTemp" : $lowTempValue}');
    builder.addString('{"rt" : "set", "$timer" : $timerValue}');

    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    // client.publishMessage(publishTopic, MqttQos.atLeastOnce, builder.payload!);

    return true;
  }







}