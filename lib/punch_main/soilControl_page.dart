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
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Card(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _weatherIcon(),
                  _temperature(),
                  Text("토양 전도도"),
                  Text("7860 cm/μs")
                ],
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _monitoring(
                          Icons.device_thermostat, "내부온도", "23.8°C"),
                      _monitoring(
                          Icons.invert_colors_on, "내부 습도", "69.2%"),
                    ],
                  )),
            ),
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _monitoring(
                          Icons.device_thermostat, "내부 온도", "23.8°C"),
                      _monitoring(
                          Icons.invert_colors_on, "내부 습도", "69.2%"),
                    ],
                  )),
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
            Visibility(
                visible: _visibility1,
                child: _cards('펌프 (#1)', _visibility1, status1)
            ),
            Visibility(
                visible: _visibility2,
                child: _cards('펌프 (#2)', _visibility2, status2)
            ),
          ],
        ),
      ],
    );
  }
  Widget _cards(var title, bool visibles, bool status){
    return  Visibility(
      visible: visibles,
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title),
                FlutterSwitch(
                  activeColor: Colors.green,
                  inactiveColor: Colors.orange,
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  value: status,
                  showOnOff: true,
                  onToggle: (val) {
                    setState(() {
                      status = val;
                    });
                  },
                ),
              ],
            )),
      ),
    );
  }
}

// 밸브 제어
class MyAccordian3 extends StatefulWidget {
  const MyAccordian3({Key? key}) : super(key: key);

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
            Visibility(
                visible: _visibility3,
                child: _cards('밸브 (#1)', _visibility3, status3)
            ),
            Visibility(
              visible: _visibility4,
              child: _cards('밸브 (#2)', _visibility4, status4)
            ),
          ],
        ),
      ],
    );
  }
  Widget _cards(var title, bool visibles, bool status){
    return  Visibility(
      visible: visibles,
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title),
                FlutterSwitch(
                  activeColor: Colors.green,
                  inactiveColor: Colors.orange,
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  value: status,
                  showOnOff: true,
                  onToggle: (val) {
                    setState(() {
                      status = val;
                    });
                  },
                ),
              ],
            )),
      ),
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
      Icon(icon, size: 20),
      SizedBox(width: 10),
      Text(text),
      SizedBox(width: 20),
      Text(temperText)
    ],
  );
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
