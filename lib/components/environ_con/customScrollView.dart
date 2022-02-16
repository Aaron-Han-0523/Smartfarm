// necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// GetX controller
import 'package:edgeworks/components/environ_con/etcControl.dart';
import 'package:edgeworks/components/environ_con/sideControl.dart';
import 'package:edgeworks/components/environ_con/topControl.dart';
import 'package:edgeworks/components/environ_con/weather.dart';

// global
import '../../globals/stream.dart' as stream;


/*
* name : [Environment] customScrollView
* description : Environment custom scroll view
* writer : mark
* create date : 2021-12-24
* last update : 2021-02-16
* */


// site dropdown value
var siteDropdown = stream.sitesDropdownValue == ''
    ? '${stream.siteNames[0]}'
    : stream.sitesDropdownValue;


var textSizedBox = Get.width * 1 / 5;


class EnvironCustomScrollView extends StatefulWidget {
  const EnvironCustomScrollView({Key? key}) : super(key: key);

  @override
  _EnvironCustomScrollViewState createState() => _EnvironCustomScrollViewState();
}

class _EnvironCustomScrollViewState extends State<EnvironCustomScrollView> {


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
                SizedBox(height: Get.height * 0.02),
                Weather(),
              ]),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Container(
                color: Color(0xffF5F9FC),
                child: Column(
                  children: [
                    SideMotorWidget(),
                    TopMotorWidget(),
                    EtcMotorWidget(),
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