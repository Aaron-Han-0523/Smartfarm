import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plms_start/punch_main/cctv_page.dart';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import "package:ndialog/ndialog.dart";

import 'package:url_launcher/url_launcher.dart';
import '../globals/login.dart' as login;
import '../globals/issue.dart' as issue;
import '../globals/photos.dart' as photos;

import '../globals/stream.dart' as stream;

import 'environment_page.dart';
import 'sensor_page.dart';
import 'soilControl_page.dart';

/*
* name : Home
* description : home page
* writer : john
* create date : 2021-09-30
* last update : 2021-09-30
* */

class Sensor extends StatelessWidget {
  const Sensor({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: SensorStatefulWidget(),
    );
  }
}

class SensorStatefulWidget extends StatefulWidget {
  const SensorStatefulWidget({Key? key}) : super(key: key);

  @override
  State<SensorStatefulWidget> createState() => _SensorStatefulWidgetState();
}

class _SensorStatefulWidgetState extends State<SensorStatefulWidget> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _connect();

    super.initState();
  }

  String statusText = "Status Text";
  bool isConnected = false;
  final MqttServerClient client =
      MqttServerClient('broker.mqttdashboard.com', '');
  TextEditingController idTextController = TextEditingController();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    SensorPage(),
    EnvironmentPage(),
    SoilControlPage(),
    CCTVPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var trap = 0;
  var siteDropdown =
      stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2E6645),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffF5F9FC),
        leading: Icon(Icons.message_outlined),
        // 타이틀
        actions: [
          IconButton(
              onPressed: _launchURL,
              icon: Image.asset('assets/images/kakao_channel.png')),
          InkWell(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              // backgroundImage: AssetImage('assets/images/gallery_button.png'),
              child: Image.asset('assets/images/icon_setting.png'),
              foregroundColor: Colors.teal,
            ),
            onTap: () {
              Get.toNamed('/setting');
            },
          ),
        ],
      ),
      body: bodySteam(),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.thermostat),
      //       label: '센서',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings_remote_outlined),
      //       label: '환경제어',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings_input_antenna),
      //       label: '토양제어',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.videocam),
      //       label: 'CCTV',
      //     ),
      //   ],
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Color(0xff2E6645),
      //   currentIndex: _selectedIndex,
      //   selectedIconTheme: IconThemeData(color: Colors.red),
      //   // selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.white,
      //   onTap: _onItemTapped,
      // ),
      bottomNavigationBar: ConvexAppBar(
        elevation: 0.0,
        items: [
          TabItem(
            icon: Image.asset(
              "assets/images/icon_sensor.png",
              color:
                  _selectedIndex == 0 ? Color(0xff222222) : Color(0xffFFFFFF),
              scale: 3,
            ),
            // title: '센서',
          ),
          TabItem(
            icon: Image.asset(
              "assets/images/icon_env.png",
              color:
                  _selectedIndex == 1 ? Color(0xff222222) : Color(0xffFFFFFF),
              scale: 3,
            ),
            // title: '환경제어',
          ),
          TabItem(
            icon: Image.asset(
              "assets/images/icon_soil.png",
              color:
                  _selectedIndex == 2 ? Color(0xff222222) : Color(0xffFFFFFF),
              scale: 3,
            ),
            // title: '토양제어',
          ),
          TabItem(
            icon: Image.asset(
              "assets/images/icon_cctv.png",
              color:
                  _selectedIndex == 3 ? Color(0xff222222) : Color(0xffFFFFFF),
              scale: 3,
            ),
            // title: '',
          ),
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.black,
        // unselectedItemColor: Colors.white,
        backgroundColor: Color(0xff2E6645),
        onTap: _onItemTapped,
        top: 0,
        color: Color(0xffFFFFFF),
        // activeColor: Color(0xff222222),
      ),
    );
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
            // print('img width = ${mqttReceivedMessages}');
            // print('img width = ${mqttReceivedMessages.runtimeType}');
            // print('img width = ${mqttReceivedMessages![0]}');
            final recMess =
                mqttReceivedMessages![0].payload as MqttPublishMessage;

            // print('recMess = ${recMess}');
            // print('recMess = ${recMess.runtimeType}');
            // print('recMess = ${recMess}');
            var streamData = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message);
            var streamDatas = jsonDecode(streamData);
            print('img width = ${streamDatas}');
            // print('img width = ${streamData.runtimeType}');
            print('temp_1 = ${streamDatas['temp_1'].runtimeType}');
            if (trap == 0) {
              stream.temp_1 = streamDatas['temp_1'].toString();
              stream.humid_1 = streamDatas['humid_1'].toString();
              stream.exttemp_1 = streamDatas['exttemp_1'].toString();
              stream.soiltemp_1 = streamDatas['soiltemp_1'].toString();
              stream.soiltemp_2 = streamDatas['soiltemp_2'].toString();
              stream.soilhumid_1 = streamDatas['soilhumid_1'].toString();
              stream.soilhumid_2 = streamDatas['soilhumid_2'].toString();
              stream.pump_1 = streamDatas['pump_1'].toString();
              stream.pump_2 = streamDatas['pump_2'].toString();
              stream.motor_1 = streamDatas['motor_1'].toString();
              stream.motor_2 = streamDatas['motor_2'].toString();
              stream.motor_3 = streamDatas['motor_3'].toString();
              stream.motor_4 = streamDatas['motor_4'].toString();
              stream.motor_5 = streamDatas['motor_5'].toString();
              stream.motor_6 = streamDatas['motor_6'].toString();
              trap = 1;
            }
            print('stream.temp_1 = ${stream.temp_1}');
            return Center(
              child: _widgetOptions.elementAt(_selectedIndex),
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
    // client.keepAlivePeriod = 20;
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

    const topic = '/sf/e0000001/data';
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

  _launchURL() async {
    const url = 'http://pf.kakao.com/_TAxfdb';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
