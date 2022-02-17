//necessary to build app
import 'package:edgeworks/components/common_page/alignWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//GetX
import 'package:edgeworks/components/soilController_page/pumpsControlls.dart';
import 'package:edgeworks/components/soilController_page/valvesControlls.dart';

//weather
import 'weathers.dart';

//globals
import '../../globals/stream.dart' as stream;

/*
* name : Soil CustomScrollViews class
* description : Soil CustomScrollViews class
* writer : Walter
* create date : 2022-02-15
* last update : 2022-02-15
* */

// site dropdown value
var siteDropdown = stream.sitesDropdownValue == ''
    ? '${stream.siteNames[0]}'
    : stream.sitesDropdownValue;

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
                AlignWidget(
                    titles: 'Farm in Earth',
                    colors: Color(0xff2E8953),
                    fontSizes: 22),
                AlignWidget(
                    titles: siteDropdown, colors: Colors.black, fontSizes: 17),
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
