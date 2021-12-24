import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.3, //mediaquery로 변경하기
                color: Colors.grey[350], //색상변경 필요
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 모니터링
                      _mainMonitoring(context),
                      _subMonitoring(context)
                    ]),
              ),
              SizedBox(height: 10),
              // 측창 개폐기 제어
              Container(
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
                  children: <Widget>[
                    _lineChart()
                  ],
                ),
              ),

            ]),
      ),
    );
  }
}

Widget _mainMonitoring(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    color: Colors.white,
    height: MediaQuery.of(context).size.height * 0.08,
    width: MediaQuery.of(context).size.width * 0.9,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _icon(Icons.wb_sunny, 40),
        _text('맑음/12.5°C', 16),
        SizedBox(width: 10),
        _icon(Icons.arrow_upward_sharp, 25),
        _text("07:32", 16),
        _icon(Icons.arrow_downward_sharp, 25),
        _text("18:08", 16),
      ],
    ),
  );
}

Widget _subMonitoring(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.4,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.add_circle_sharp, 25, "내부 온도", 15),
                _text("23.8°C", 15),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.add_circle_sharp, 25, "내부 습도", 15),
                _text("69.2%", 15),
              ],
            ),
          ],
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.4,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.compass_calibration_sharp, 25, "풍향", 15),
                _text("남동향", 15),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.window_sharp, 25, "풍속", 15),
                _text("1.2m/s", 15),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}



// 아이콘 위젯
Widget _icon(dynamic icon, double _size) {
  return Icon(
    icon,
    color: Colors.grey,
    size: _size,
  );
}

Widget _text(String text, double fontSize){
  return Text(
    text,
    style: TextStyle(
        color: Colors.grey,
        fontSize: fontSize,
        fontWeight: FontWeight.w600
    ),
  );
}

Widget _iconText(dynamic icon, double _size, String text, double fontSize) {
  return Padding(
    padding: EdgeInsets.only(left: 10),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: _size,
        ),
        Text(
          text,
          style: TextStyle(
              color: Colors.grey,
              fontSize: fontSize,
              fontWeight: FontWeight.w600
          ),
        )
      ],
    ),
  );
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
          activeBgColors: [[Colors.green], [Colors.orangeAccent], [Colors.black54]],
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
          activeBgColors: [[Colors.green], [Colors.orangeAccent]],
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
      ]
  );
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







