import 'package:edgeworks/components/soilController_page/pumpsControlls.dart';
import 'package:edgeworks/components/soilController_page/valvesControlls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'weathers.dart';
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
                Weathers(),
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
                      PumpsControlls(),
                      ValvesControlls(),
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
