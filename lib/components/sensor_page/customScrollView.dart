import 'package:edgeworks/components/sensor_page/extSensor.dart';
import 'package:edgeworks/components/sensor_page/innerSensor.dart';
import 'package:edgeworks/components/sensor_page/innserTempChart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// global
import '../../globals/stream.dart' as stream;

// site dropdown value
var siteDropdown = stream.sitesDropdownValue == ''
    ? '${stream.siteNames[0]}'
    : stream.sitesDropdownValue;

class SensorScrollViews extends StatelessWidget {
  const SensorScrollViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                    style: TextStyle(color: Color(0xff2E8953), fontSize: 22),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(siteDropdown,
                      style: TextStyle(color: Colors.black, fontSize: 17)),
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
                    ExtSensor(),
                    InnerSensor(),
                    InnserTempChart(),
                  ],
                ),
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}
