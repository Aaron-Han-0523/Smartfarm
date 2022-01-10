import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../globals/stream.dart' as stream;
/*
* name : ListOpen Page
* description : open data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

// globalKey
var innerTemp = stream.temp_1; // 내부온도
var extTemp = stream.exttemp_1; // 외부온도
var soilTemp = stream.soiltemp_1; // 토양온도
var innerHumid = stream.humid_1; // 내부습도
var extHumid = stream.humid_1; // 외부습도
var soilHumid = stream.soilhumid_1; // 토양습도

class SensorPage extends StatefulWidget {
  SensorPage({Key? key}) : super(key: key);

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            toolbarHeight: 70.0,
            backgroundColor: Color(0xffF5F9FC),
            title: Align(
              alignment: Alignment.topLeft,
              child: Column(children: [
                Text(
                  'Farm in Earth',
                  style: TextStyle(color: Color(0xff2E8953), fontSize: 25),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text('siteDropdown',
                        style: TextStyle(color: Colors.black, fontSize: 18))),
              ]),
            ),
          ),
          SliverList(
            // itemExtent: 3.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: Colors.red,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF5F9FC),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    alignment: Alignment.center,
                    // color: Color(0xffF5F9FC),

                    child: Column(
                      children: [
                        MyAccordian(),
                        MyAccordian2(),
                        MyGraph(),
                      ],
                    ),
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: _decorations(),
            child: ExpansionTile(
              initiallyExpanded: true,
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Image.asset(
                      'assets/images/icon_exevn.png',
                      scale: 3,
                    ),
                  ),
                  Text(
                    '외부환경',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              children: <Widget>[
                Row(children: [
                  _cards('외부온도', extTemp, true, 'assets/images/icon_temp.png'),
                  _cards('외부습도', extHumid, true, 'assets/images/icon_humid.png')
                ]),
                Row(children: [
                  _cards('강우', '12.5', true, 'assets/images/icon_rainy.png'),
                  _cards('풍향', '12.5', true, 'assets/images/icon_wind.png')
                ]),
                Row(children: [
                  _cards('풍속', '12.5', true, 'assets/images/icon_windsp.png'),
                  _cards('일사량', '12.5', true, 'assets/images/icon_shiny.png')
                ])
              ],
            ),
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: _decorations(),
            child: ExpansionTile(
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Image.asset(
                      'assets/images/icon_inevn.png',
                      scale: 3,
                    ),
                  ),
                  Text(
                    '내부환경',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              children: <Widget>[
                Row(children: [
                  _cards(
                      '내부온도', innerTemp, true, 'assets/images/icon_temp.png'),
                  _cards(
                      '내부습도', innerHumid, true, 'assets/images/icon_temp.png')
                ]),
                Row(children: [
                  _cards('토양온도', soilTemp, true, 'assets/images/icon_temp.png'),
                  _cards('토양습도', soilHumid, true, 'assets/images/icon_temp.png')
                ]),
                Row(children: [
                  _cards('토양건조도', '12.5', true, 'assets/images/icon_temp.png'),
                ]),
              ],
            ),
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
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: _decorations(),
            child: ExpansionTile(
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Image.asset(
                      'assets/images/icon_graph.png',
                      scale: 3,
                    ),
                  ),
                  Text(
                    "그래프",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              children: [_lineChart()],
            ),
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

  return Container(
    color: Colors.white,
    child: SfCartesianChart(
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
        ]),
  );
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

// dynamic icon
Widget _cards(var title, var subtitle, bool visibles, String assets) {
  return Visibility(
    visible: visibles,
    child: Container(
      // alignment: Alignment.center,
      margin: EdgeInsets.only(left: 7, right: 5, bottom: 10),
      height: Get.height * 1 / 9,
      width: Get.height * 1 / 4.5,
      decoration: _decoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 23),
              child: Text(title,
                  style: TextStyle(color: Color(0xff2E8953), fontSize: 12)),
            ),
            Text(subtitle,
                style: TextStyle(
                    color: Color(0xff222222),
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
          ]),
          Image.asset(
            assets,
            scale: 2,
          )
          // Icon(icon, size: 60, color: Colors.black54)
        ],
      ),
    ),
  );
}

BoxDecoration _decoration() {
  return BoxDecoration(
    color: Colors.white,
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

BoxDecoration _decorations() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Color(0xff2E8953),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2,
        offset: Offset(3, 5), // changes position of shadow
      ),
    ],
  );
}
