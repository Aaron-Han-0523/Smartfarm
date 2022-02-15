// necessary to build app
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// getX controller
import '../utils/getX_controller/controller.dart';

// pages
import 'package:edgeworks/pages/cctv_page.dart';
import 'package:edgeworks/pages/sensor_page.dart';
import 'package:edgeworks/pages/soilControl_page.dart';

// global
import '../globals/stream.dart' as stream;
import '../pages/environment_page.dart';

/*
* name : Home
* description : home page
* writer : walter
* create date : 2021-12-28
* last update : 2022-02-14
* */

// 카카오 채널 url
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
  int _selectedIndex = 0;
  final controller = Get.put(CounterController());
  @override
  void initState() {
    controller.connect();
    _widgetOptions;
    _pageController = PageController(initialPage: _selectedIndex);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }
  // TextEditingController
  TextEditingController idTextController = TextEditingController();

  // drawer close global key
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  final _page1 = GlobalKey<NavigatorState>();
  final _page2 = GlobalKey<NavigatorState>();
  final _page3 = GlobalKey<NavigatorState>();
  final _page4 = GlobalKey<NavigatorState>();
  final _page5 = GlobalKey<NavigatorState>();

  // siteDropdown button global variable
  var siteDropdown =
  stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;

  PageController? _pageController;

  List<Widget> _widgetOptions = <Widget>[
    SensorPage(),
    EnvironmentPage(),
    SoilControlPage(),
    CCTVPage(),
  ];

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // _pageController!.jumpToPage(_selectedIndex);
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
                  leading:
                      Image.asset('assets/images/kakao_channel.png', scale: 3),
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
        bottomNavigationBar: bottomBar(_selectedIndex)
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
              // child: PageView(
              //   controller: _pageController,
              //   children: _widgetOptions
              // ),
              child: _widgetOptions.elementAt(_selectedIndex),
             // child : IndexedStack(
             //    index: _selectedIndex,
             //    children: <Widget>[
             //      Navigator(
             //        key: _page1,
             //        onGenerateRoute: (route) => MaterialPageRoute(
             //          settings: route,
             //          builder: (context) => SensorPage(),
             //        ),
             //      ),
             //      Navigator(
             //        key: _page2,
             //        onGenerateRoute: (route) => MaterialPageRoute(
             //          settings: route,
             //          builder: (context) => EnvironmentPage(),
             //        ),
             //      ),
             //      Navigator(
             //        key: _page3,
             //        onGenerateRoute: (route) => MaterialPageRoute(
             //          settings: route,
             //          builder: (context) => SoilControlPage(),
             //        ),
             //      ),
             //      Navigator(
             //        key: _page4,
             //        onGenerateRoute: (route) => MaterialPageRoute(
             //          settings: route,
             //          builder: (context) => CCTVPage(),
             //        ),
             //      ),
             //    ],
             //  ),
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
            color:
            index == 0 ? Color(0xff222222) : Color(0xffFFFFFF),
            scale: 3,
          ),
          // title: '센서',
        ),
        TabItem(
          icon: Image.asset(
            "assets/images/icon_env.png",
            color:
            index == 1 ? Color(0xff222222) : Color(0xffFFFFFF),
            scale: 3,
          ),
          // title: '환경제어',
        ),
        TabItem(
          icon: Image.asset(
            "assets/images/icon_soil.png",
            color:
            index == 2 ? Color(0xff222222) : Color(0xffFFFFFF),
            scale: 3,
          ),
          // title: '토양제어',
        ),
        TabItem(
          icon: Image.asset(
            "assets/images/icon_cctv.png",
            color:
            index == 3 ? Color(0xff222222) : Color(0xffFFFFFF),
            scale: 3,
          ),
          // title: '',
        ),
      ],
      // selectedItemColor: Colors.black,
      // unselectedItemColor: Colors.white,
      backgroundColor: Color(0xff2E6645),
      onTap: _onItemTapped,
      top: 0,
      color: Color(0xffFFFFFF),
      // activeColor: Color(0xff222222),
    );
  }

  //카카오 채널 url launcher
  _launchKakaoURL() async {
    if (await canLaunch(kakaoChannelUrl)) {
      await launch(kakaoChannelUrl);
    } else {
      throw 'Could not launch $kakaoChannelUrl';
    }
  }
}
