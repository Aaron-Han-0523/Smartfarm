// ** MQTT **

// Env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Mqtt
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// Global
import 'package:edgeworks/globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;

/*
* name : MQTT class
* description : MQTT class
* writer : mark
* create date : 2021-01-07
* last update : 2021-02-18
* */

//Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';
var mqttIP = dotenv.env['MQTT_IP'];

// mqtt
// int clientPort = 1883;
int clientPort = int.parse('${dotenv.env['MQTT_PORT']}');
final MqttServerClient client = MqttServerClient('$mqttIP', '');

class ConnectMqtt {
  // MQTT
  String statusText = "Status Text";
  // bool isConnected = false;
  _disconnect() {
    client.disconnect();
  }

  //MQTT SITE CONFIG SET - subscribe
  void getSiteConfig() async {
    client.logging(on: true);
    client.port = clientPort;
    client.secure = false;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier('3').startClean();
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to Successfully!");
    } else {
      print(false);
    }
    var topic = '/sf/$siteId/res/cfg';
    client.subscribe(topic, MqttQos.atMostOnce);
    var pubTopic = '/sf/$siteId/req/cfg';
    final builder = MqttClientPayloadBuilder();
    builder.addString('{"rt" : "get"}');
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    _disconnect();
    print(true);
  }

  //MQTT MOTOR & PUMP CTRL - publish
  Future<dynamic> setAll(var did, var len, var dact, String dactValue,
      var subscibeTopic, var publishTopic, var motorTypeId) async {
    client.logging(on: true);
    client.port = clientPort;
    client.secure = false;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('3') // '3' ????????? ?????????
        .startClean(); // userid??? global??? ???????????? shared ?????? ??????????????? id ??? ????????? ????????? ????????? ????????????
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to Successfully!");
    } else {
      return false;
    }

    var topic = subscibeTopic;
    client.subscribe(topic, MqttQos.atMostOnce);

    var pubTopic = publishTopic;
    final builder = MqttClientPayloadBuilder();

    // publish data
    for (int i = 0; i < len; i++) {
      builder.clear();
      builder.addString(
          '{"rt" : "set", "$did" : ${motorTypeId[i]}, "$dact" : "$dactValue"}');
      client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
      // client.publishMessage(publishTopic, MqttQos.atLeastOnce, builder.payload!);
    }

    return true;
  }

  Future<dynamic> setControl(var did, var dicValue, var dact, String dactValue,
      var subscibeTopic, var publishTopic) async {
    client.logging(on: true);
    client.port = clientPort;
    client.secure = false;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('3')
        .startClean(); // userid??? global??? ???????????? shared ?????? ??????????????? id ??? ????????? ????????? ????????? ????????????
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
    } else {
      return false;
    }

    var topic = subscibeTopic;
    client.subscribe(topic, MqttQos.atMostOnce);

    var pubTopic = publishTopic;
    final builder = MqttClientPayloadBuilder();

    // publish data
    builder.addString(
        '{"rt" : "set", "$did" : $dicValue, "$dact" : "$dactValue"}');

    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    // client.publishMessage(publishTopic, MqttQos.atLeastOnce, builder.payload!);

    return true;
  }

  //MQTT SITE CONFIG SET - publish
  Future<dynamic> setConfig(var alarmValue, var highTempValue, var lowTempValue,
      var timerValue, var subscibeTopic, var publishTopic) async {
    client.logging(on: true);
    client.port = clientPort;
    client.secure = false;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('3')
        .startClean(); // userid??? global??? ???????????? shared ?????? ??????????????? id ??? ????????? ????????? ????????? ????????????
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to Successfully!");
    } else {
      return false;
    }

    var topic = subscibeTopic;
    client.subscribe(topic, MqttQos.atMostOnce);

    var pubTopic = publishTopic;
    final builder = MqttClientPayloadBuilder();

    // publish data
    builder.addString(
        '{"rt":"set", "alarm_en":$alarmValue, "alarm_high_temp":$highTempValue, "alarm_low_temp":$lowTempValue, "watering_timer":$timerValue}');
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    getSiteConfig();
    return true;
  }
}
