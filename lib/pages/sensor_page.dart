// necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// getX controller
import '../utils/getX_controller/controller.dart';
// global
import '../globals/stream.dart' as stream;

/*
* name : ListOpen Page
* description : open data page
* writer : walter
* create date : 2021-09-30
* last update : 2022-02-03
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

  // siteDropdown button global variable
  var siteDropdown = stream.sitesDropdownValue == ''
      ? '${stream.siteNames[0]}'
      : stream.sitesDropdownValue; //${stream.siteNames[0]}

  @override
  void initState() {
    super.initState();
    print('[sensor page] stream.chartData: ${stream.chartData.length}');
    for (var i = 0; i < stream.chartData.length; i++) {
      data.add(_InnerTempData(stream.chartData[i]['time_stamp'],
          double.parse(stream.chartData[i]['value'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff2E6645),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                toolbarHeight: Get.height * 0.08,
                backgroundColor: Color(0xffF5F9FC),
                title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Farm in Earth',
                          style:
                              TextStyle(color: Color(0xff2E8953), fontSize: 22),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(siteDropdown,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17)),
                      ),
                      SizedBox(height: Get.height * 0.01),
                    ]),
              ),
              SliverList(
                // itemExtent: 3.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      color: Color(0xffF5F9FC),
                      child: Column(
                        children: [
                          _myAccordian(),
                          _myAccordian2(),
                          _myGraph(),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: Get.height * 1 / 30,
              width: Get.width,
              child: Image.asset(
                'assets/images/image_bottombar.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 외부 환경 위젯
  Widget _myAccordian() {
    return Obx(
          () => Column(
        children: <Widget>[
          _fromLTRBPadding(
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
                      _leftRightPadding(
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

  // 내부 환경 위젯
  Widget _myAccordian2() {
    return Obx(
          () => Column(
        children: <Widget>[
          _fromLTRBPadding(
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
                      _leftRightPadding(
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
                        primary: false,
                        childAspectRatio:
                        (Get.width * 0.4) / (Get.height * 1 / 9),
                        crossAxisCount: 2,
                        children: List.generate(innerData.length, (index) {
                          return _cards(innerData[index], innerCon[index].value,
                              true, 'assets/images/icon_temp.png');
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 그래프 위젯
  @override
  Widget _myGraph() {
    return Column(
      children: <Widget>[
        _fromLTRBPadding(
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
                    _leftRightPadding(
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

// 그래프 데이터 관련
List<_InnerTempData> data = [
  // _InnerTempData('Jan', 35),
  // _InnerTempData('Feb', 28),
  // _InnerTempData('Mar', 34),
  // _InnerTempData('Apr', 32),
  // _InnerTempData('May', 40)
];

Widget _lineChart() {
  // List<_InnerTempData> data = [
  //   _InnerTempData('Jan', 35),
  //   _InnerTempData('Feb', 28),
  //   _InnerTempData('Mar', 34),
  //   _InnerTempData('Apr', 32),
  //   _InnerTempData('May', 40)
  // ];

  // List<_SalesData> subData = [
  //   _SalesData('Jan', 20),
  //   _SalesData('Feb', 50),
  //   _SalesData('Mar', 30),
  //   _SalesData('Apr', 40),
  //   _SalesData('May', 28)
  // ];

  return SfCartesianChart(
      backgroundColor: Colors.white,
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries<_InnerTempData, String>>[
        LineSeries<_InnerTempData, String>(
            dataSource: data,
            xValueMapper: (_InnerTempData sales, _) => sales.dateTime,
            yValueMapper: (_InnerTempData sales, _) => sales.tempValue,
            name: 'InnerTemp',
            // Enable data label
            dataLabelSettings: DataLabelSettings(isVisible: false)),
        // LineSeries<_SalesData, String>(
        //     dataSource: subData,
        //     xValueMapper: (_SalesData sales, _) => sales.year,
        //     yValueMapper: (_SalesData sales, _) => sales.sales,
        //     name: 'Sales',
        //     // Enable data label
        //     dataLabelSettings: DataLabelSettings(isVisible: false))
      ]);
}

class _InnerTempData {
  _InnerTempData(this.dateTime, this.tempValue);

  final String dateTime;
  final double tempValue;
}

// dynamic icon
Widget _cards(var title, var subtitle, bool visibles, String assets) {
  return Visibility(
    visible: visibles,
    child: Container(
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

// BoxDecoration 위젯 (shadow 미적용)
BoxDecoration _decoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  );
}

// BoxDecoration 위젯 (shadow 적용)
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

// padding 위젯
Padding _fromLTRBPadding({child}) {
  return Padding(padding: new EdgeInsets.fromLTRB(15, 10, 15, 5), child: child);
}

Padding _leftRightPadding({child}) {
  return Padding(
      padding: new EdgeInsets.only(left: 10, right: 10), child: child);
}
