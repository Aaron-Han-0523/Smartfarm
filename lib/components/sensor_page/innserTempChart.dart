// ** INNER TEMP CHART WIDGET PAGE **

// Necessary to build app
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// GetX
import 'package:get/get.dart';
import 'package:edgeworks/utils/getX_controller/innerTempChartController.dart';

// Import Chart Data Class
import 'package:edgeworks/models/sensor_page/innerTempData.dart';


// GetX controller
final _innerTempController = Get.put(InnerTempChartController());

// Chart
Timer? _timer;

class InnserTempChart extends StatefulWidget {
  InnserTempChart({Key? key}) : super(key: key);

  @override
  State<InnserTempChart> createState() => _InnserTempChartState();
}

class _InnserTempChartState extends State<InnserTempChart> {

  @override
  void initState() {

    setState(() {
      _innerTempController.getTrendsTempData();
      _innerTempController.chartData;
    });
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _innerTempController.getTrendsTempData();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  FutureBuilder(
                      future: _innerTempController.getTrendsTempData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return _lineChart();
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                      // child: _lineChart()
                      )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Chart Data Widget
  Widget _lineChart() {
    return SfCartesianChart(
        backgroundColor: Colors.white,
        primaryXAxis: CategoryAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(
          interval: 20,
        ),
        // primaryXAxis: DateTimeAxis(
        //   majorGridLines: const MajorGridLines(width: 0),
        //   dateFormat: DateFormat.Hms(),
        //   intervalType: DateTimeIntervalType.seconds,
        //   autoScrollingDelta: 10,
        //   autoScrollingDeltaType: DateTimeIntervalType.seconds
        // ),
        series: <ChartSeries<InnerTempData, String>>[
          LineSeries<InnerTempData, String>(
              dataSource: _innerTempController.chartData,
              xValueMapper: (InnerTempData sales, _) => sales.dateTime,
              yValueMapper: (InnerTempData sales, _) => sales.tempValue,
              name: 'InnerTemp',
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: false)),
        ]);
  }
}

// BoxDecoration Widget
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

// Padding Widget
Padding _fromLTRBPadding({child}) {
  return Padding(padding: new EdgeInsets.fromLTRB(15, 10, 15, 5), child: child);
}

Padding _leftRightPadding({child}) {
  return Padding(
      padding: new EdgeInsets.only(left: 10, right: 10), child: child);
}
