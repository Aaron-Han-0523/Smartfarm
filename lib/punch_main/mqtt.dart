import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import "package:ndialog/ndialog.dart";

//https://github.com/0015/ThatProject/blob/master/ESP32_MQTT/2_Flutter_MQTT_Client_App/mqtt_esp32cam_viewer_full_version/lib/main.dart
//https://www.youtube.com/watch?v=aY7i0xnQW54

class MQTTPage extends StatefulWidget {
  const MQTTPage({Key? key}) : super(key: key);

  @override
  State<MQTTPage> createState() => _MQTTPageState();
}

class _MQTTPageState extends State<MQTTPage> {
  String statusText = "Status Text";
  bool isConnected = false;
  final MqttServerClient client =
      MqttServerClient('broker.mqttdashboard.com', '');
  TextEditingController idTextController = TextEditingController();

  @override
  void initState() {
    _connect();
    super.initState();
  }

  // @override
  // void dispose() {
  //   idTextController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return bodySteam();
  }

  Widget bodySteam() {
    return Container(
      color: Colors.black,
      child: StreamBuilder(
        stream: client.updates,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          else {
            final mqttReceivedMessages =
                snapshot.data as List<MqttReceivedMessage<MqttMessage?>>?;

            final recMess =
                mqttReceivedMessages![0].payload as MqttPublishMessage;
            var streamData = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message);
            print('img width = ${streamData.runtimeType}');
            //  print('img width = ${streamData["temp_1"]}');

            return Text(
              streamData,
              style: const TextStyle(color: Colors.white),
            );
          }
        },
      ),
    );
  }

  _connect() async {
    isConnected = await mqttConnect('test');
  }

  _disconnect() {
    client.disconnect();
  }

  Future<bool> mqttConnect(String uniqueId) async {
    setStatus("Connecting MQTT Broker");

    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.port = 1883;
    client.secure = false;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;
    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    } else {
      return false;
    }

    const topic = '/sf/#';
    client.subscribe(topic, MqttQos.atMostOnce);

    return true;
  }

  void setStatus(String content) {
    setState(() {
      statusText = content;
    });
  }

  void onConnected() {
    setStatus("Client connection was successful");
  }

  void onDisconnected() {
    setStatus("Client Disconnected");
    isConnected = false;
  }

  void pong() {
    print('Ping response client callback invoked');
  }
}
