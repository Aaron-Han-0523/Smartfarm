import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:plms_start/mqtt/mqtt.dart';
import 'package:dio/dio.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../globals/stream.dart' as stream;
import 'package:mqtt_client/mqtt_server_client.dart';
import 'components/getx_controller/controller.dart';

/*
* name : Soil Control Page
* description : Soil Control Page
* writer : sherry
* create date : 2021-12-24    
* last update : 2022-01-17
* */

// globalKey
var innerTemp = stream.temp_1; // 내부온도
var extTemp = stream.exttemp_1; // 외부온도
var soilTemp = stream.soiltemp_1; // 토양온도
var innerHumid = stream.humid_1; // 내부습도
var extHumid = stream.humid_1; // 외부습도
var soilHumid = stream.soilhumid_1; // 토양습도
var pump_1 = stream.pump_1; // pump_1의 on/off
var pump_2 = stream.pump_2; // pump_2의 on/off

List pumps = stream.pumps;
List pump_name = stream.pump_name;
List valves = stream.valves;
List valve_name = stream.valve_name;

List sensor_id = stream.sensor_id;

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = 'test';
var siteId = 'sid';

// dio APIs
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

// weather status
var temp = int.parse(extTemp);

// MQTT
MqttClass _mqttClass = MqttClass();
String statusText = "Status Text";
bool isConnected = false;
final MqttServerClient client =
    MqttServerClient('broker.mqttdashboard.com', '');

// decoration (with box shadow)
BoxDecoration _decoration(dynamic color) {
  return BoxDecoration(
    color: color,
    // color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2,
        offset: Offset(3, 5), // changes position of shadow
      ),
    ],
  );
}

// decoration(without box shadow)
BoxDecoration _decorations() {
  return BoxDecoration(
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(20),
  );
}

class SoilControlPage extends StatefulWidget {
  SoilControlPage({Key? key}) : super(key: key);

  @override
  _SoilControlPageState createState() => _SoilControlPageState();
}

class _SoilControlPageState extends State<SoilControlPage> {
  @override
  void initState() {
    super.initState();
  }

  var siteDropdown =
      stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Scaffold(
        backgroundColor: Color(0xff2E6645),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xffF5F9FC),
            borderRadius: BorderRadius.circular(40),
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                toolbarHeight: Get.height * 0.45,
                backgroundColor: Color(0xffF5F9FC),
                title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Farm in Earth',
                          style:
                              TextStyle(color: Color(0xff2E8953), fontSize: 25),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(siteDropdown,
                            style:
                                TextStyle(color: Colors.black, fontSize: 18)),
                      ),
                      SizedBox(height: Get.height * 0.05),
                      MyWeather(),
                    ]),
              ),
              SliverList(
                // itemExtent: 3.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Color(0xffF5F9FC),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MyPumps(),
                            MyValves(),
                          ],
                        ));
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ));
  }
}

// 날씨
class MyWeather extends StatefulWidget {
  const MyWeather({Key? key}) : super(key: key);

  @override
  State<MyWeather> createState() => _MyWeatherState();
}

class _MyWeatherState extends State<MyWeather> {
  @override
  void initState() {
    var innerTemp = stream.temp_1; // 내부온도
    var extTemp = stream.exttemp_1; // 외부온도
    var soilTemp = stream.soiltemp_1; // 토양온도
    var innerHumid = stream.humid_1; // 내부습도
    var extHumid = stream.humid_1; // 외부습도
    var soilHumid = stream.soilhumid_1; // 토양습도
    print("innerTemp");
    print(innerTemp);
    print(stream.temp_1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounterController());
    return Obx(
      () => Container(
        // alignment: Alignment.center,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
             _mainMonitoring("맑음", "${controller.extTemp.value}", "7860"),
             SizedBox(height: Get.height * 0.03),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    height: Get.height * 0.13,
                    width: Get.width * 0.425,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _subMonitoring(
                            'assets/images/icon_temp.png',
                            "내부 온도",
                            "${controller.innerTemp.value}" + "°C",
                            'assets/images/icon_humid.png',
                            "내부 습도",
                            "${controller.innerHumid.value}" + "%"),
                      ],
                    ),
                    decoration: _decoration(Color(0xffFFFFFF)),
                  ),
                ),
                Container(
                  height: Get.height * 0.13,
                  width: Get.width * 0.425,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _subMonitoring(
                          'assets/images/icon_soiltemp.png',
                          "토양 온도",
                          "${controller.soilTemp.value}°C",
                          'assets/images/icon_soilhumid.png',
                          "토양 습도",
                          "${controller.soilHumid.value}%"),
                    ],
                  ),
                  decoration: _decoration(Color(0xffFFFFFF)),
                ),
            ],
          ),
        ]),
      ),
    );
  }
}

// 관수 펌프 제어
class MyPumps extends StatefulWidget {
  const MyPumps({Key? key}) : super(key: key);

  @override
  State<MyPumps> createState() => _MyPumpsState();
}

class _MyPumpsState extends State<MyPumps> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _fromLTRBPadding(
        child: Container(
          decoration: _decoration(Color(0xff2E8953)),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: _edgeLeftPadding(
                15,
                child: Text('관수 펌프 제어',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFFFFFF))),
              ),
              textColor: Colors.white,
              collapsedTextColor: Colors.white,
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              // tilePadding: EdgeInsets.all(8.0),
              children: <Widget>[
                _topBottomPadding(
                  15,
                  15,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: stream.pumpStatus.length,
                      itemBuilder: (BuildContext context, var index) {
                        return _switchToggle(
                            index, '펌프', stream.pumpStatus, 'pump');
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

// 밸브 제어
class MyValves extends StatefulWidget {
  const MyValves({Key? key}) : super(key: key);

  @override
  State<MyValves> createState() => _MyValvesState();
}

class _MyValvesState extends State<MyValves> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _fromLTRBPadding(
        child: Container(
          decoration: _decoration(Color(0xff2E8953)),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: _edgeLeftPadding(
                15,
                child: Text('밸브 제어',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFFFFFF))),
              ),
              textColor: Colors.white,
              collapsedTextColor: Colors.white,
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              // tilePadding: EdgeInsets.all(8.0),
              children: <Widget>[
                _topBottomPadding(
                  15,
                  15,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: stream.valveStatus.length,
                      itemBuilder: (BuildContext context, var index) {
                        return _switchToggle2(
                            index, '밸브', stream.valveStatus, 'valve');
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

Widget _switchToggle(var index, var text, var streamStatus, var action) {
  return _marginContainer(
    height: Get.height * 0.09,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _edgeLeftPadding(
          20,
          child: Text("$text (#${index + 1})",
              style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: 15,
                  fontWeight: FontWeight.normal)),
        ),
        _edgeRightPadding(
          10,
          child: ToggleSwitch(
            fontSize: 12,
            minWidth: 60.0,
            cornerRadius: 80.0,
            activeBgColors: [
              [Color(0xffe3fbed)],
              [Color(0xfff2f2f2)]
            ],
            activeFgColor: Color(0xff222222),
            inactiveBgColor: Color(0xffFFFFFF),
            inactiveFgColor: Color(0xff222222),
            initialLabelIndex: streamStatus[index] == 1 ? 1 : 0,
            totalSwitches: 2,
            labels: ['ON', 'OFF'],
            radiusStyle: true,
            onToggle: (value) async {
              String switchStatus = '';

              if (value == 0) {
                switchStatus = 'on';
                streamStatus[index] = 0;
              } else if (value == 1) {
                switchStatus = 'off';
                streamStatus[index] = 1;
              }
              print('### $action${index + 1} toggle value는 : $value');
              print(
                  '### $action${index + 1} toggle type은 : ${value.runtimeType}');
              print('### $action${index + 1} value는 : $switchStatus');

              _mqttClass.ctlSet('did', "${index + 1}", 'dact', switchStatus,
                  '/sf/e0000001/req/$action', '/sf/e0000001/req/$action');

              // var pumpId = 'pump_${index + 1}';
              // var data = {
              //   'uid': userId,
              //   'sid': siteId,
              //   'pump_id': pumpId,
              //   'pump_action': value,
              // };
              // final putPumps = await dio.put(
              //     '$url/$userId/site/$siteId/controls/pumps/$pumpId',
              //     data: data);
              // print(putPumps);
            },
          ),
        ),
      ],
    ),
    decoration: _decorations(),
  );
}

Widget _switchToggle2(var index, var text, var streamStatus, var action) {
  return Container(
    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
    height: Get.height * 0.09,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("$text (#${index + 1})",
              style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: 15,
                  fontWeight: FontWeight.normal)),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: ToggleSwitch(
            fontSize: 12,
            minWidth: 60.0,
            cornerRadius: 80.0,
            activeBgColors: [
              [Color(0xffe3fbed)],
              [Color(0xfff2f2f2)]
            ],
            activeFgColor: Color(0xff222222),
            inactiveBgColor: Color(0xffFFFFFF),
            inactiveFgColor: Color(0xff222222),
            initialLabelIndex: streamStatus[index] == 0 ? 0 : 1,
            totalSwitches: 2,
            labels: ['OPEN', 'CLOSE'],
            radiusStyle: true,
            onToggle: (value) async {
              String switchStatus = '';

              if (value == 0) {
                switchStatus = 'open';
                streamStatus[index] = 0;
              } else if (value == 1) {
                switchStatus = 'close';
                streamStatus[index] = 1;
              }
              print('### $action${index + 1} toggle value는 : $value');
              print(
                  '### $action${index + 1} toggle type은 : ${value.runtimeType}');
              print('### $action${index + 1} value는 : $switchStatus');
              print(
                  '### $action${index + 1} $action Status는 : ${streamStatus[index]}');

              _mqttClass.ctlSet('did', "${index + 1}", 'dact', switchStatus,
                  '/sf/e0000001/req/$action', '/sf/e0000001/req/$action');

              // var valveId = 'valve_${index + 1}';
              // var data = {
              //   'uid': userId,
              //   'sid': siteId,
              //   'valve_id': valveId,
              //   'valve_action': value,
              // };
              // final putValves = await dio.put(
              //     '$url/$userId/site/$siteId/controls/valves/$valveId',
              //     data: data);
              // print(putValves);
            },
          ),
        ),
      ],
    ),
    decoration: _decorations(),
  );
}

Widget _mainMonitoring(String weather, String temperNumber, String soilNumber) {
  return Container(
    height: Get.height * 0.1,
    width: Get.width * 0.9,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      temp > 20
          ? Image.asset('assets/images/icon_shiny.png',
              color: Color(0xff222222), scale: 3)
          : Image.asset('assets/images/icon_windy.png',
              color: Color(0xff222222), scale: 3),
      Text(" $weather/$temperNumber°C ",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff222222))),
      Text(" 토양 전도도 $soilNumber cm/μs",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff222222))),
    ]),
    decoration: _decoration(Color(0xffFFFFFF)),
  );
}

TextStyle _textStyle(dynamic _color, dynamic _weight, double _size) {
  return TextStyle(color: _color, fontWeight: _weight, fontSize: _size);
}

Widget _subMonitoring(dynamic icon, String mainText, String _mainText,
    dynamic _icon, String subText, String _subText) {
  return Container(
      height: Get.height * 0.13,
      width: Get.width * 0.425,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(icon, color: Color(0xff222222), scale: 5),
              Text(mainText,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              Text(_mainText,
                  style: _textStyle(Color(0xff222222), FontWeight.w600, 18)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(_icon, color: Color(0xff222222), scale: 5),
              Text(subText,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              Text(_subText,
                  style: _textStyle(Color(0xff222222), FontWeight.w600, 18)),
            ],
          ),
        ],
      ),
      decoration: _decoration(Color(0xffFFFFFF)));
}

// padding widget
Padding _fromLTRBPadding({child}) {
  return Padding(padding: new EdgeInsets.fromLTRB(15, 10, 15, 5), child: child);
}

Padding _edgeLeftPadding(double left, {child}) {
  return Padding(padding: new EdgeInsets.only(left: left), child: child);
}

Padding _edgeRightPadding(double right, {child}) {
  return Padding(padding: new EdgeInsets.only(right: right), child: child);
}

Padding _topBottomPadding(double top, double bottom, {child}) {
  return Padding(
      padding: new EdgeInsets.only(top: top, bottom: bottom), child: child);
}

Container _marginContainer({child, dynamic height, decoration}) {
  return Container(
    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
    height: height,
    child: child,
    decoration: decoration,
  );
}
