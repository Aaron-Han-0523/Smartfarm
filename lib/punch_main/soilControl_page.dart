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
            MyAccordian(), // 날씨, 관수 펌프 제어, 밸브 제어
            MyGraph(), // 그래프
          ],
        ));
  }
}

// 날씨, 관수 펌프 제어, 밸브 제어
class MyAccordian extends StatefulWidget {
  const MyAccordian({Key? key}) : super(key: key);

  @override
  State<MyAccordian> createState() => _MyAccordianState();
}

class _MyAccordianState extends State<MyAccordian> {
  // switch on off
  bool status1 = false;
  bool status2 = false;
  bool status3 = false;
  bool status4 = false;
  // visibiliby
  bool _visibility1 = true;
  bool _visibility2 = true;
  bool _visibility3 = true;
  bool _visibility4 = true;
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
                      _monitoring(Icons.device_thermostat, "내부 온도", "23.8°C"),
                      _monitoring(Icons.invert_colors_on, "내부 습도", "69.2%"),
                    ],
                  )),
            ),
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _monitoring(Icons.device_thermostat, "내부 온도", "23.8°C"),
                      _monitoring(Icons.invert_colors_on, "내부 습도", "69.2%"),
                    ],
                  )),
            ),
          ],
        ),
        // 관수 펌프 제어
        ExpansionTile(
          title: Text('관수 펌프 제어'),
          children: <Widget>[
            Visibility(
                visible: _visibility1,
                child: _cards('펌프 (#1)', _visibility1, status1)),
            Visibility(
                visible: _visibility2,
                child: _cards('펌프 (#2)', _visibility2, status2)),
          ],
        ),
        // 밸브 제어
        ExpansionTile(
          title: Text('밸브 제어'),
          children: <Widget>[
            Visibility(
                visible: _visibility3,
                child: _cards('밸브 (#1)', _visibility3, status3)),
            Visibility(
                visible: _visibility4,
                child: _cards('밸브 (#2)', _visibility4, status4)),
          ],
        ),
      ]),
    );
  }

  Widget _cards(var title, bool visibles, bool status) {
    return Visibility(
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
class MyGraph extends StatefulWidget {
  const MyGraph({Key? key}) : super(key: key);

  @override
  State<MyGraph> createState() => _MyGraphState();
}

class _MyGraphState extends State<MyGraph> {
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
