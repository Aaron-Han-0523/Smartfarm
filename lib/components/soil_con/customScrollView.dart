import 'package:edgeworks/components/soil_con/pumpsControl.dart';
import 'package:edgeworks/components/soil_con/valvesControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'weather.dart';
import '../../globals/stream.dart' as stream;

var siteDropdown =
    stream.sitesDropdownValue == '' ? 'test' : stream.sitesDropdownValue;

class CustomScrollViews extends StatelessWidget {
  const CustomScrollViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          toolbarHeight: Get.height * 0.29,
          backgroundColor: Color(0xffF5F9FC),
          title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _alignWidget('Farm in test', Color(0xff2E8953), 22),
                _alignWidget(siteDropdown, Colors.black, 17),
                SizedBox(height: Get.height * 0.02),
                Weather(),
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
                      PumpsControll(),
                      ValvesControll(),
                    ],
                  ));
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}

Widget _alignWidget(String titles, Color colors, double fontSizes) {
  return Align(
    alignment: Alignment.topLeft,
    child: Text(
      titles,
      style: TextStyle(color: colors, fontSize: fontSizes),
    ),
  );
}
