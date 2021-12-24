import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            MyAccordian1(),
            MyAccordian2(),
            MyAccordian3(),
            MyAccordian4(),
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
    return Column(
      children: <Widget>[
        Row(children: [_cards('햇님', '햇님'), _cards('토양 전도도', '7860 cm/us')]),
        Row(children: <Widget>[
          Column(children: [_cards('내부 온도', '23.8'), _cards('내부 습도', '69.2%')]),
          Column(children: [_cards('토양 온도', '15.3'), _cards('토양 습도', '78.6%')])
        ]
        )
      ],
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          initiallyExpanded: true,
          title: Text('관수 펌프 제어'),
          children: <Widget>[
            Row(children: [_cards('외부온도', '12.5'), _cards('외부습도', '12.5')]),
            Row(children: [_cards('강우', '12.5'), _cards('풍향', '12.5')])
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text('밸브 제어'),
          children: <Widget>[
            Row(children: [_cards('내부온도', '12.5'), _cards('내부습도', '12.5')]),
            Row(children: [_cards('토양온도', '12.5'), _cards('토양온도', '12.5')])
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
    return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text('그래프'),
            children: <Widget>[
              Column(children: [
                //Initialize the chart widget
                SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
                    tooltipBehavior: _tooltip,
                    series: <ChartSeries<_ChartData, String>>[
                      BarSeries<_ChartData, String>(
                          dataSource: data,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: '내부 온도',
                          color: Color.fromRGBO(8, 142, 255, 1))
                    ]),
              ],
              ),
            ],
          ),
        ]
    );
  }
}

Widget _cards(var title, var subtitle) {
  return Container(
      height: 70,
      width: 90,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Column(children: [
            Text(title),
            Text(subtitle),
          ]),
          Icon(Icons.wb_sunny)
        ],
      ));
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
