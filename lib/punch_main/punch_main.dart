import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:get/get.dart';
// import 'package:get/get.dart';

import 'package:plms_start/pages/utils/button_issue.dart';
import 'package:plms_start/punch_main/list_close.dart';
import 'package:plms_start/punch_main/list_draft.dart';
import 'package:plms_start/punch_main/list_file.dart';
import 'package:plms_start/punch_main/list_open.dart';
import 'package:plms_start/punch_main/list_req.dart';

import '../globals/login.dart' as login;
// import 'package:plms_start/pages/utils/header_issue.dart';

// import 'screen_punch.dart';

/*
* name : ScreenList
* description : punch main page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class ScreenList extends StatefulWidget {
  const ScreenList({Key? key}) : super(key: key);

  @override
  _ScreenListState createState() => _ScreenListState();
}

class _ScreenListState extends State<ScreenList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int len = (login.draftList.length +
        login.openList.length +
        login.reqList.length +
        login.closeList.length);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff2b3645),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.appTitle),
              IconButton(
                onPressed: () {
                  Get.toNamed(
                    '/popup',
                  );
                  // Get.to(PopUpPage(), opaque: false);
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
        body: DefaultTabController(
          // initialIndex: 0,
          length: 5,
          child: Column(
            children: [
              Container(
                // height: Get.height,
                color: Color(0xFFE6E6E6),
                child: Container(
                  // height: Get.height,
                  // width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 6, right: 6),
                  child: TabBar(
                    controller: _tabController,
                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },

                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 0.0001,
                    // isScrollable: true,

                    tabs: [
                      _tabBars(0xff959595, AppLocalizations.of(context)!.tile1,
                          '$len', 0),
                      _tabBars(0xff7c4141, AppLocalizations.of(context)!.tile2,
                          '${login.draftList.length}', 1),
                      _tabBars(0xffb88d6a, AppLocalizations.of(context)!.tile3,
                          '${login.openList.length}', 2),
                      _tabBars(0xff987ca1, AppLocalizations.of(context)!.tile41,
                          '${login.reqList.length}', 3),
                      _tabBars(0xff637a8f, AppLocalizations.of(context)!.tile5,
                          '${login.closeList.length}', 4),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListFile(),
                    ListDraft(),
                    ListOpen(),
                    ListReq(),
                    ListClose(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: IssueButton(
            name: '/punchList',
            name2: '/photoList',
            buttonname1: AppLocalizations.of(context)!.pListbutton1,
            buttonname2: AppLocalizations.of(context)!.pListbutton2));
  }

  // tab bar
  Widget _tabBars(int colors, String tiles, String nums, int idx) {
    var radius = Radius.circular(8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: Get.height * 1 / 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: radius, topLeft: radius),
            color: Color(colors),
          ),
          width: MediaQuery.of(context).size.width * 1 / 5.5 * 1 / 2,
        ),
        Container(
          height: Get.height * 1 / 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: radius, topRight: radius, bottomRight: radius),
            boxShadow: [
              BoxShadow(color: Colors.grey, offset: Offset(0, 1)),
            ],
            color: _currentIndex == idx ? Color(colors) : Colors.white,
          ),
          padding: EdgeInsets.all(2),
          width: MediaQuery.of(context).size.width * 1 / 5,
          child: Tab(child: _colorChange(tiles, nums, idx)),
        ),
      ],
    );
  }

  // tab color change
  Widget _colorChange(String name, String nums, int idx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
              color: _currentIndex == idx ? Colors.white : Colors.black,
              fontSize: 10),
        ),
        Text(
          nums,
          style: TextStyle(
              color: _currentIndex == idx ? Colors.white : Colors.grey,
              fontSize: 10),
        ),
      ],
    );
  }
}
