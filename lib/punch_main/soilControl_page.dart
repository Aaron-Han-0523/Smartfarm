import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_switch/flutter_switch.dart';

/*
* name : Soil Control Page
* description : Soil Control Page
* writer : sherry
* create date : 2021-12-24
* last update : 2021-12-24
* */

class SoilControlPage extends StatefulWidget {
  SoilControlPage({Key? key}) : super(key: key);

  @override
  _SoilControlPageState createState() => _SoilControlPageState();
}

class _SoilControlPageState extends State<SoilControlPage> {
  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Container(
        color: Color(0xFFE6E6E6),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            MyAccordian1(), // 날씨
            MyAccordian2(), // 관수 펌프 제어
            MyAccordian3(), // 밸브 제어
            MyAccordian4(), // 그래프
          ],
        ));
  }
}

// 날씨
class MyAccordian1 extends StatefulWidget {
  const MyAccordian1({Key? key}) : super(key: key);

  @override
  State<MyAccordian1> createState() => _MyAccordian1State();
}

class _MyAccordian1State extends State<MyAccordian1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 200, //mediaquery로 변경하기
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          alignment: Alignment.center,
          color: Colors.white,
          height: 60,
          width: 350,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _weatherIcon(),
              _temperature(),
              Text("토양 전도도"),
              Text("7860 cm/μs")
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 70,
              width: 160,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _monitoring(
                      Icons.device_thermostat, "내부온도", "23.8°C"), //아이콘 변경해주기
                  _monitoring(Icons.opacity, "내부 습도", "69.2%"), //아이콘 변경해주기
                ],
              ),
            ),
            Container(
              height: 70,
              width: 160,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _monitoring(
                      Icons.device_thermostat, "내부 온도", "23.8°C"), //아이콘 변경해주기
                  _monitoring(Icons.opacity, "내부 습도", "69.2%"), //아이콘 변경해주기
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}

// 관수 펌프 제어
class MyAccordian2 extends StatefulWidget {
  const MyAccordian2({Key? key}) : super(key: key);

  @override
  State<MyAccordian2> createState() => _MyAccordian2State();
}

class _MyAccordian2State extends State<MyAccordian2> {
  bool status1 = false;
  bool status2 = false;
  bool _visibility1 = true;
  bool _visibility2 = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text('관수 펌프 제어'),
          children: <Widget>[
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('펌프 (#1)'),
                      FlutterSwitch(
                        activeColor: Colors.green,
                        inactiveColor: Colors.orange,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.white,
                        value: status1,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            status1 = val;
                          });
                        },
                      ),
                    ],
                  )),
            ),
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('펌프 (#2)'),
                      FlutterSwitch(
                        activeColor: Colors.green,
                        inactiveColor: Colors.orange,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.white,
                        value: status2,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            status2 = val;
                          });
                        },
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}

// 밸브 제어
class MyAccordian3 extends StatefulWidget {
  // const MyAccordian3({Key? key}) : super(key: key);

  @override
  State<MyAccordian3> createState() => _MyAccordian3State();
}

class _MyAccordian3State extends State<MyAccordian3> {
  bool status3 = false;
  bool status4 = false;
  bool _visibility3 = true;
  bool _visibility4 = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text('밸브 제어'),
          children: <Widget>[
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('밸브 (#1)'),
                      FlutterSwitch(
                        activeColor: Colors.green,
                        inactiveColor: Colors.orange,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.white,
                        value: status3,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            status3 = val;
                          });
                        },
                      ),
                    ],
                  )),
            ),
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('밸브 (#2)'),
                      FlutterSwitch(
                        activeColor: Colors.green,
                        inactiveColor: Colors.orange,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.white,
                        value: status4,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            status4 = val;
                          });
                        },
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}

// 그래프
class MyAccordian4 extends StatefulWidget {
  const MyAccordian4({Key? key}) : super(key: key);

  @override
  State<MyAccordian4> createState() => _MyAccordian4State();
}

class _MyAccordian4State extends State<MyAccordian4> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('내부 온도', 12),
      _ChartData('내부 습도', 15),
      _ChartData('토양 온도', 30),
      _ChartData('토양 습도', 6.4),
      _ChartData('토양 전도도', 14)
    ];

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ExpansionTile(
        title: Text('그래프'),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 40, interval: 10),
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<_ChartData, String>>[
                    BarSeries<_ChartData, String>(
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        name: '내부 온도',
                        color: Color.fromRGBO(8, 142, 255, 1))
                  ]),
            ),
          ),
        ],
      ),
    ]);
  }
}

Widget _weatherIcon() {
  return Icon(
    Icons.wb_sunny_rounded,
    size: 40,
  );
}

Widget _temperature() {
  return Text("맑음/12.5°C");
}

Widget _sun(dynamic icon, String text) {
  return Row(
    children: [
      Icon(
        icon,
        size: 30,
      ),
      Text(
        text,
      )
    ],
  );
}

Widget _monitoring(dynamic icon, String text, String temperText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Icon(
        icon,
        size: 20
      ),
      SizedBox(width: 10),
      Text(
        text
      ),
      SizedBox(width: 20),
      Text(
        temperText
      )
    ],
  );
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
