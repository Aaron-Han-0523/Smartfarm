import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EnvironmentPage extends StatefulWidget {
  const EnvironmentPage({Key? key}) : super(key: key);

  @override
  _EnvironmentState createState() => _EnvironmentState();
}

class _EnvironmentState extends State<EnvironmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.grey[350], //색상변경 필요
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _mainMonitoring(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _subMonitoring(context, Icons.add_circle_sharp, "내부 온도",
                          "23.8°C", Icons.add_circle_sharp, "내부 습도", "69.2%"),
                      _subMonitoring(context, Icons.add_circle_sharp, "풍향",
                          "남동향", Icons.add_circle_sharp, "풍속", "1.2m/s"),
                    ],
                  )
                ]),
          ),
          // 측창 개폐기 제어
          Container(
            margin: EdgeInsets.only(top: 10),
            color: Colors.grey[350],
            child: ExpansionTile(
              backgroundColor: Colors.grey[350],
              title: Text('측창 개폐기 제어'),
              children: <Widget>[
                Column(
                  children: [
                    _card('측장 (전체)'),
                    _toggleSwitch('츨장 (전)'),
                    _toggleSwitch('측장 (후)'),
                    _toggleSwitch('측장 (좌)'),
                    _toggleSwitch('측장 (우)'),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            color: Colors.grey[350],
            child: ExpansionTile(
              backgroundColor: Colors.grey[350],
              title: Text('천창 개폐기 제어'),
              children: <Widget>[
                Column(
                  children: [
                    _card('측장 (전체)'),
                    _toggleSwitch('츨장 (#1)'),
                    _toggleSwitch('측장 (#2)'),
                    _toggleSwitch('측장 (#3)'),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            color: Colors.grey[350],
            child: ExpansionTile(
              backgroundColor: Colors.grey[350],
              title: Text('기타제어'),
              children: <Widget>[
                Column(
                  children: [
                    _toggleSwitch2('환풍기 (#1)'),
                    _toggleSwitch2('환풍기 (#2)'),
                    _toggleSwitch2('외부 제어 (#1)'),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            color: Colors.grey[350],
            child: ExpansionTile(
              backgroundColor: Colors.grey[350],
              title: Text('그래프'),
              children: <Widget>[_lineChart()],
            ),
          ),
        ]),
      ),
    );
  }
}

// 현재 상태 모니터링
Widget _mainMonitoring(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    height: MediaQuery.of(context).size.height * 0.08,
    width: MediaQuery.of(context).size.width * 0.9,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.wb_sunny, color: Colors.black54, size: 40),
        SizedBox(width: 5),
        Text("맑음/12.5°C", style: _textStyle()),
        SizedBox(width: 10),
        Icon(Icons.arrow_upward_sharp, color: Colors.black54, size: 25),
        Text("07:32", style: _textStyle()),
        Icon(Icons.arrow_downward_sharp, color: Colors.black54, size: 25),
        Text("18:08", style: _textStyle()),
      ],
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 2,
          offset: Offset(3, 5), // changes position of shadow
        ),
      ],
    ),
  );
}

// 내/외부 모니터링
Widget _subMonitoring(BuildContext context, dynamic icon, String mainText,
    String _mainText, dynamic _icon, String subText, String _subText) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.1,
    width: MediaQuery.of(context).size.width * 0.425,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.black54),
                  SizedBox(width: 10),
                  Text(mainText, style: _textStyle()),
                ],
              ),
              Text(_mainText, style: _textStyle()),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_icon, color: Colors.black54),
                  SizedBox(width: 10),
                  Text(subText, style: _textStyle()),
                ],
              ),
              Text(_subText, style: _textStyle()), //"23.8°C"
            ],
          ),
        ),
      ],
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 2,
          offset: Offset(3, 5), // changes position of shadow
        ),
      ],
    ),
  );
}

TextStyle _textStyle() {
  return TextStyle(
      color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 15);
}

Widget _card(String text) {
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(text),
        Row(
          children: [
            _raisedButoon(Colors.green, '전체열림'),
            _raisedButoon(Colors.orangeAccent, '전체정지'),
            _raisedButoon(Colors.black54, '전체닫힘')
          ],
        )
      ],
    ),
  );
}

Widget _toggleSwitch(String text) {
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        ToggleSwitch(
          minWidth: 50.0,
          cornerRadius: 50.0,
          activeBgColors: [
            [Colors.green],
            [Colors.orangeAccent],
            [Colors.black54]
          ],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey[400],
          inactiveFgColor: Colors.white,
          initialLabelIndex: 1,
          totalSwitches: 3,
          labels: ['열림', '정지', '닫힘'],
          radiusStyle: true,
          onToggle: (index) {
            print('switched to: $index');
          },
        )
      ],
    ),
  );
}

Widget _toggleSwitch2(String text) {
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        ToggleSwitch(
          minWidth: 50.0,
          cornerRadius: 50.0,
          activeBgColors: [
            [Colors.green],
            [Colors.orangeAccent]
          ],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey[400],
          inactiveFgColor: Colors.white,
          initialLabelIndex: 1,
          totalSwitches: 2,
          labels: ['ON', 'OFF'],
          radiusStyle: true,
          onToggle: (index) {
            print('switched to: $index');
          },
        )
      ],
    ),
  );
}

Widget _lineChart() {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

  List<_SalesData> subData = [
    _SalesData('Jan', 20),
    _SalesData('Feb', 50),
    _SalesData('Mar', 30),
    _SalesData('Apr', 40),
    _SalesData('May', 28)
  ];

  return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      // Chart title
      // title: ChartTitle(text: 'Half yearly sales analysis'),
      // Enable legend
      legend: Legend(isVisible: true),
      // Enable tooltip
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries<_SalesData, String>>[
        LineSeries<_SalesData, String>(
            dataSource: data,
            xValueMapper: (_SalesData sales, _) => sales.year,
            yValueMapper: (_SalesData sales, _) => sales.sales,
            name: 'Sales',
            // Enable data label
            dataLabelSettings: DataLabelSettings(isVisible: false)),
        LineSeries<_SalesData, String>(
            dataSource: subData,
            xValueMapper: (_SalesData sales, _) => sales.year,
            yValueMapper: (_SalesData sales, _) => sales.sales,
            name: 'Sales',
            // Enable data label
            dataLabelSettings: DataLabelSettings(isVisible: false))
      ]);
}

//RaisedButton Widget
Widget _raisedButoon(dynamic color, String text) {
  return RaisedButton(
    onPressed: () {},
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(text),
  );
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
