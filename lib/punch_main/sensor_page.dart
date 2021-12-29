import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/*
* name : ListOpen Page
* description : open data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class SensorPage extends StatefulWidget {
  SensorPage({Key? key}) : super(key: key);

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  // final List data = login.openList;

  // String id = Get.arguments[4];
  // String password = Get.arguments[5];
  // String userName = Get.arguments[6];
  // String email = Get.arguments[7];
  // String company = Get.arguments[8];
  // String authority = Get.arguments[9];

  void initState(){
    super.initState();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Scaffold(
      body: Container(
          color: Color(0xFFE6E6E6),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              MyAccordian(),
              MyAccordian2(),
              MyGraph()
            ],
          )),
    );
  }
}

class MyAccordian extends StatefulWidget {
  const MyAccordian({Key? key}) : super(key: key);

  @override
  State<MyAccordian> createState() => _MyAccordianState();
}

class _MyAccordianState extends State<MyAccordian> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.grey[350],
          child: ExpansionTile(
            backgroundColor: Colors.grey[350],
            initiallyExpanded: true,
            title: Text('외부환경'),
            children: <Widget>[
              Row(children: [
                _cards('외부온도', '12.5', true, Icons.wb_sunny),
                _cards('외부습도', '12.5', true, Icons.invert_colors)
              ]),
              Row(children: [
                _cards('강우', '12.5', true, Icons.wb_sunny),
                _cards('풍향', '12.5', true, Icons.wb_sunny)
              ]),
              Row(children: [
                _cards('풍속', '12.5', true, Icons.wb_sunny),
                _cards('일사량', '12.5', true, Icons.wb_sunny)
              ])
            ],
          ),
        ),
      ],
    );
  }
}

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
        Container(
          color: Colors.grey[350],
          margin: EdgeInsets.only(bottom: 10),
          child: ExpansionTile(
            backgroundColor: Colors.grey[350],
            title: Text('내부환경'),
            children: <Widget>[
              Row(children: [
                _cards('내부온도', '12.5', true, Icons.wb_sunny),
                _cards('내부습도', '12.5', true, Icons.wb_sunny)
              ]),
              Row(children: [
                _cards('토양온도', '12.5', true, Icons.wb_sunny),
                _cards('토양습도', '12.5', true, Icons.wb_sunny)
              ]),
              Row(children: [
                _cards('토양건조도', '12.5', true, Icons.wb_sunny),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}

class MyGraph extends StatefulWidget {
  const MyGraph({Key? key}) : super(key: key);

  @override
  State<MyGraph> createState() => _MyGraphState();
}

class _MyGraphState extends State<MyGraph> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.grey[350],
          child: ExpansionTile(
            backgroundColor: Colors.grey[350],
            title: Text("그래프"),
            children: [
              _lineChart()
            ],
          ),
        ),
      ],
    );
  }
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

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

Widget _cards(var title, var subtitle, bool visibles, dynamic icon) {
  return Visibility(
    visible: visibles,
    child: Container(
      // alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20, right: 5, bottom: 15),
      height: 90,
      width: 160,
      decoration: _decoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(title, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
              ]),
          Icon(icon, size: 60, color: Colors.black54)
        ],
      ),
    ),
  );
}

BoxDecoration _decoration() {
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2,
        offset: Offset(3, 5), // changes position of shadow
      ),
    ],
  );
}




