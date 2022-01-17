import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:plms_start/pages/cctv_page.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals/stream.dart' as stream;
import '../pages/environment_page.dart';
import 'components/getx_controller/controller.dart';
import 'sensor_page.dart';
import 'soilControl_page.dart';
import 'dart:async';

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
  final controller = Get.put(CounterController());
  @override
  void initState() {
    controller.connect();
    // _connect();
    // });

    super.initState();
  }

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

  // var trap = 0;
  var siteDropdown =
      stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 카카오 채널 연결 drawer
      drawer: Drawer(
        backgroundColor: Color(0xffF5F9FC),
        child: ListView(
          children: [
            Container(
              height: Get.height * 0.08,
              child: DrawerHeader(
                child: Text(
                  "더보기",
                  style: TextStyle(color: Color(0xff318A55), fontSize: 20),
                ),
                decoration: BoxDecoration(color: Color(0xffF5F9FC)),
              ),
            ),
            ListTile(
                leading:
                    Image.asset('assets/images/kakao_channel.png', scale: 3),
                title: Text('카카오 채널 연결'),
                onTap: _launchURL),
          ],
        ),
      ),
      backgroundColor: Color(0xff2E6645),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xff222222)),
        elevation: 0.0,
        backgroundColor: Color(0xffF5F9FC),
        // 타이틀
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset('assets/images/icon_setting.png', scale: 3),
                foregroundColor: Colors.teal,
              ),
              onTap: () {
                Get.toNamed('/setting');
              },
            ),
          ),
        ],
      ),
      body: bodySteam(),
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
        stream: controller.client.updates,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
              color: Color(0xffF5F9FC),
              child: Center(
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff318A55)),
                ),
              ),
            );
          else {
            return Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            );
          }
        },
      ),
    );
  }

  _launchURL() async {
    const url = 'http://pf.kakao.com/_xledxfb';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
