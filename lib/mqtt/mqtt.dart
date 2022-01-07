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
  bool isConnected = false;
  final MqttServerClient client =
  MqttServerClient('broker.mqttdashboard.com', '');


  //MQTT publish
  Future<dynamic> mqttConnect(String dic, var dact, var subscibeTopic, var publishTopic) async {

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
    builder.addString('{"$dic" : $dact}');

    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    // client.publishMessage(publishTopic, MqttQos.atLeastOnce, builder.payload!);

    return true;
  }



}