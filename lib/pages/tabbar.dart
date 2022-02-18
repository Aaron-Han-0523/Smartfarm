// ** TAB BAR WIDGET PAGE **

// Necessary to build app
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// GetX
import 'package:edgeworks/utils/getX_controller/sensorController.dart';

// Pages
import 'package:edgeworks/pages/cctv_page.dart';
import 'package:edgeworks/pages/sensor_page.dart';
import 'package:edgeworks/pages/soilControl_page.dart';
import 'package:edgeworks/pages/environment_page.dart';

// Global
import 'package:edgeworks/globals/stream.dart' as stream;


/*
* name : Home
* description : home page
* writer : walter
* create date : 2021-12-28
* last update : 2022-02-18
* */

// SiteDropdown button global variable
var siteDropdown =
stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;

// GetX Controller
final controller = Get.put(SensorController());

// Define Global Variable
int _selectedIndex = 0;

// TextEditingController
TextEditingController idTextController = TextEditingController();

// Drawer close global key
GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

// TabBar List
List<Widget> _widgetOptions = <Widget>[
  SensorPage(),
  EnvironmentPage(),
  SoilControlPage(),
  CCTVPage(),
];

// KakaoChannel Url
var kakaoChannelUrl = 'http://pf.kakao.com/_xledxfb';


class Sensor extends StatelessWidget {
  const Sensor({Key? key}) : super(key: key);

  static const String _title = 'FarmInUs';

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


  @override
  void initState() {
    controller.connect();
    _widgetOptions;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 뒤로가기 버튼 제어
      onWillPop: () async {
        if (_key.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
          // 카카오 채널 연결 drawer
          key: _key,
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
                    leading: Image.asset('assets/images/kakao_channel.png',
                        scale: 3),
                    title: Text('카카오 채널 연결'),
                    onTap: _launchKakaoURL),
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
                    child:
                        Image.asset('assets/images/icon_setting.png', scale: 3),
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
          bottomNavigationBar: bottomBar(_selectedIndex)),
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

  // bottom bar
  Widget bottomBar(int index) {
    print('화면 번호 index : $index');
    return ConvexAppBar(
      elevation: 0.0,
      initialActiveIndex: index,
      items: [
        TabItem(
          icon: Image.asset(
            "assets/images/icon_sensor.png",
            color: index == 0 ? Color(0xff222222) : Color(0xffFFFFFF),
            scale: 3,
          ),
        ),
        TabItem(
          icon: Image.asset(
            "assets/images/icon_env.png",
            color: index == 1 ? Color(0xff222222) : Color(0xffFFFFFF),
            scale: 3,
          ),
        ),
        TabItem(
          icon: Image.asset(
            "assets/images/icon_soil.png",
            color: index == 2 ? Color(0xff222222) : Color(0xffFFFFFF),
            scale: 3,
          ),
        ),
        TabItem(
          icon: Image.asset(
            "assets/images/icon_cctv.png",
            color: index == 3 ? Color(0xff222222) : Color(0xffFFFFFF),
            scale: 3,
          ),
        ),
      ],

      backgroundColor: Color(0xff2E6645),
      onTap: _onItemTapped,
      top: 0,
      color: Color(0xffFFFFFF),
    );
  }

  // KakaoChannel Url Launcher
  _launchKakaoURL() async {
    if (await canLaunch(kakaoChannelUrl)) {
      await launch(kakaoChannelUrl);
    } else {
      throw 'Could not launch $kakaoChannelUrl';
    }
  }
}
