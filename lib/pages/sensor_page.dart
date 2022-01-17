import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../globals/stream.dart' as stream;
import 'components/getx_controller/controller.dart';
/*
* name : ListOpen Page
* description : open data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-01-11
* */

// globalKey
var innerTemp = stream.temp_1; // 내부온도
var extTemp = stream.exttemp_1; // 외부온도
var soilTemp = stream.soiltemp_1; // 토양온도
var innerHumid = stream.humid_1; // 내부습도
var extHumid = stream.humid_1; // 외부습도
var soilHumid = stream.soilhumid_1; // 토양습도
final controller = Get.put(CounterController());
List innerData = ['내부 온도', '내부 습도', '토양 온도', '토양 습도'];
List innerCon = [
  controller.innerTemp,
  controller.innerHumid,
  controller.soilTemp,
  controller.soilHumid
];

class SensorPage extends StatefulWidget {
  SensorPage({Key? key}) : super(key: key);

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  void initState() {
    super.initState();
  }

  var siteDropdown =
      stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2E6645),
      body: Container(
        // color: Color(0xffF5F9FC),
        decoration: BoxDecoration(
          color: Color(0xffF5F9FC),
          borderRadius: BorderRadius.circular(40),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              toolbarHeight: Get.height * 0.14,
              backgroundColor: Color(0xffF5F9FC),
              title: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Farm in Earth',
                    style: TextStyle(color: Color(0xff2E8953), fontSize: 25),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(siteDropdown,
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
              ]),
            ),
            SliverList(
              // itemExtent: 3.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    // color: Colors.red,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF5F9FC),
                        // borderRadius: BorderRadius.only(
                        //     bottomLeft: Radius.circular(10),
                        //     bottomRight: Radius.circular(10)),
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
  final controller = Get.put(CounterController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
            child: Container(
              decoration: _decorations(),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
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
                        '외부 환경',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    SizedBox(height: Get.height * 0.01),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _cards('외부 온도', controller.extTemp.value, true,
                              'assets/images/icon_temp.png'),
                          _cards('외부 습도', controller.extHumid.value, true,
                              'assets/images/icon_humid.png')
                        ]),
                    SizedBox(height: Get.height * 0.01),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _cards('강우', '12.5', true,
                              'assets/images/icon_rainy.png'),
                          _cards(
                              '풍향', '12.5', true, 'assets/images/icon_wind.png')
                        ]),
                    SizedBox(height: Get.height * 0.01),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _cards('풍속', '12.5', true,
                              'assets/images/icon_windsp.png'),
                          _cards('일사량', '12.5', true,
                              'assets/images/icon_shiny.png')
                        ]),
                    SizedBox(height: Get.height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyAccordian2 extends StatefulWidget {
  const MyAccordian2({Key? key}) : super(key: key);

  @override
  State<MyAccordian2> createState() => _MyAccordian2State();
}

class _MyAccordian2State extends State<MyAccordian2> {
  // final controller = Get.put(CounterController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
            child: Container(
              decoration: _decorations(),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
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
                        '내부 환경',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    SizedBox(
                      width: Get.width,
                      height:
                          (Get.height * 1 / 9) * (innerData.length ~/ 2 + 0.4),
                      child: GridView.count(
                        childAspectRatio:
                            (Get.width * 0.4) / (Get.height * 1 / 9),
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: 2,
                        // Generate 100 widgets that display their index in the List.

                        children: List.generate(innerData.length, (index) {
                          return _cards(innerData[index], innerCon[index].value,
                              true, 'assets/images/icon_temp.png');
                        }),
                      ),
                    ),
                    // SizedBox(height: Get.height * 0.01),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       _cards('내부 온도', controller.innerTemp.value, true,
                    //           'assets/images/icon_temp.png'),
                    //       _cards('내부 습도', controller.innerHumid.value, true,
                    //           'assets/images/icon_humid.png')
                    //     ]),
                    // SizedBox(height: Get.height * 0.01),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       _cards('토양 온도', controller.soilTemp.value, true,
                    //           'assets/images/icon_soiltemp.png'),
                    //       _cards('토양 습도', controller.soilHumid.value, true,
                    //           'assets/images/icon_soilhumid.png')
                    //     ]),
                    // SizedBox(height: Get.height * 0.01),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 5, bottom: 5),
                    //   child: Row(children: [
                    //     _cards('토양 건조도', '12.5', true,
                    //         'assets/images/icon_soilele.png'),
                    //   ]),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
          child: Container(
            decoration: _decorations(),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                children: [_lineChart()],
              ),
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
      margin: EdgeInsets.only(left: 7, right: 7, bottom: 10),
      height: Get.height * 1 / 9,
      width: Get.width * 0.4,
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
                    fontSize: 25,
                    fontWeight: FontWeight.w500)),
          ]),
          Image.asset(
            assets,
            scale: 3,
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
