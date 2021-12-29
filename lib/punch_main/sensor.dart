import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plms_start/punch_main/cctv_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals/login.dart' as login;
import '../globals/issue.dart' as issue;
import '../globals/photos.dart' as photos;

import 'package:plms_start/punch_main/punch_main.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.message_outlined),
        title: const Text('Farm in Earth'), // 타이틀
        actions: [
          IconButton(onPressed: _launchURL,
              icon: Image.asset('assets/images/kakao_channel.png')),
          InkWell(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              // backgroundImage: AssetImage('assets/images/gallery_button.png'),
              child: Icon(Icons.person),
            ),
            onTap: () {
              Get.toNamed('/setting');
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: '센서',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_remote_outlined),
            label: '환경제어',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_input_antenna),
            label: '토양제어',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'CCTV',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  //카카오 채널 url launcher
  _launchURL() async {
    const url = 'http://pf.kakao.com/_TAxfdb';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

