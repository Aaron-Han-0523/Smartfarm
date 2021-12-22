import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import 'package:plms_start/pages/utils/button_issue.dart';
import 'package:plms_start/punch_issue/appbar_screen.dart';
import 'package:plms_start/punch_issue/first_screen.dart';
import 'package:plms_start/punch_issue/second_screen.dart';
import 'package:plms_start/punch_issue/tabbar_screen.dart';
import 'package:plms_start/punch_issue/third_screen.dart';

// import 'package:http/http.dart' as http;
import '../globals/globals.dart' as globals;
import '../globals/punch_continue.dart' as continues;
import '../globals/issue.dart' as issue;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
* name : PunchScreen
* description : PunchScreen page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class PunchScreen extends StatefulWidget {
  const PunchScreen({Key? key}) : super(key: key);

  @override
  _PunchScreenState createState() => _PunchScreenState();
}

class _PunchScreenState extends State<PunchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  // int _selectedIndex = 0;

  final page1Key = new GlobalKey();
  final page2Key = new GlobalKey();
  final page3Key = new GlobalKey();

  double page1Height = 0;
  double page2Height = 0;
  double page3Height = 0;
  bool isTapToScroll = false;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _onScroll();
    });
    print('bulk!!!!!!!!!!!!!!!!!!!');
    print(continues.punch_issue_Bulk_Item);

    // globals.punch_issue_isTag = true;
    // globals.punch_issue_isBulk = false;
    globals.punch_issue_Tag_Number = [];
    globals.punch_issue_Bulk_Item = [];
    globals.punch_issue_Category = [];
    globals.punch_issue_System = [];
    globals.punch_issue_Sub_System = [];
    globals.punch_issue_Unit = [];
    globals.punch_issue_Area = [];
    globals.punch_issue_Punch_ID = [];
    globals.punch_issue_Description = [];
    globals.punch_issue_Action_On = [];
    globals.punch_issue_Discipline = [];
    globals.punch_issue_Raised_On = [];
    globals.punch_issue_Date = [];
    globals.punch_issue_Keyword = [];
    globals.punch_issue_Design = [];
    globals.punch_issue_Material = [];
    globals.punch_issue_Status = [];

    globals.punch_issue_Switch = ['1'];
    globals.punch_issue_Photo = [];
    globals.punch_issue_Photo_Path = [];
    globals.punch_issue_Photo_Name = [];
    globals.punch_issue_Drawings = [];
    globals.punch_issue_Drawings_File = [];
    globals.punch_issue_Pixel_X = [];
    globals.punch_issue_Pixel_Y = [];
    continues.punch_issue_Tag_Number.length == 1
        ? globals.punch_issue_Tag_Number
            .add(continues.punch_issue_Tag_Number[0])
        : globals.punch_issue_Tag_Number = [];

    continues.punch_issue_Bulk_Item.length == 1
        ? globals.punch_issue_Bulk_Item.add(continues.punch_issue_Bulk_Item[0])
        : globals.punch_issue_Bulk_Item = ['0'];
    continues.punch_issue_Bulk_Name.length == 1
        ? globals.punch_issue_Bulk_Name.add(continues.punch_issue_Bulk_Name[0])
        : globals.punch_issue_Bulk_Name = [];
    continues.punch_issue_Category.length == 1
        ? globals.punch_issue_Category.add(continues.punch_issue_Category[0])
        : globals.punch_issue_Category = [issue.categoryList[0]];
    continues.punch_issue_System.length == 1
        ? globals.punch_issue_System.add(continues.punch_issue_System[0])
        : globals.punch_issue_System = [issue.systemsList[0]];
    continues.punch_issue_Sub_System.length == 1
        ? globals.punch_issue_Sub_System
            .add(continues.punch_issue_Sub_System[0])
        : globals.punch_issue_Sub_System = [issue.subsystemList[0]];
    continues.punch_issue_Unit.length == 1
        ? globals.punch_issue_Unit.add(continues.punch_issue_Unit[0])
        : globals.punch_issue_Unit = [];
    continues.punch_issue_Area.length == 1
        ? globals.punch_issue_Area.add(continues.punch_issue_Area[0])
        : globals.punch_issue_Area = [];
    continues.punch_issue_Description.length == 1
        ? globals.punch_issue_Description
            .add(continues.punch_issue_Description[0])
        : globals.punch_issue_Description = [];
    print('여기!!!!!!!!!!');
    print(continues.punch_issue_Raised_On.length);
    continues.punch_issue_Discipline.length == 1
        ? globals.punch_issue_Discipline
            .add(continues.punch_issue_Discipline[0])
        : globals.punch_issue_Discipline = [issue.disciplineList[0]];
    continues.punch_issue_Status.length == 1
        ? globals.punch_issue_Status.add(continues.punch_issue_Status[0])
        : globals.punch_issue_Status = [];
    continues.punch_issue_Action_On.length == 1
        ? globals.punch_issue_Action_On.add(continues.punch_issue_Action_On[0])
        : globals.punch_issue_Action_On = [issue.deptList[0]];
    continues.punch_issue_Date.length == 1
        ? globals.punch_issue_Date.add(continues.punch_issue_Date[0])
        : globals.punch_issue_Date = [];
    continues.punch_issue_Keyword.length >= 1
        ? globals.punch_issue_Keyword = continues.punch_issue_Keyword
        : globals.punch_issue_Keyword = [];

    continues.punch_issue_Issued_Date.length == 1
        ? globals.punch_issue_Issued_Date
            .add(continues.punch_issue_Issued_Date[0])
        : globals.punch_issue_Issued_Date = [];
    continues.punch_issue_Raised_On.length == 1
        ? globals.punch_issue_Raised_On.add(continues.punch_issue_Raised_On[0])
        : globals.punch_issue_Raised_On = [];
    continues.punch_issue_Design.length == 1
        ? globals.punch_issue_Design.add(continues.punch_issue_Design[0])
        : globals.punch_issue_Design = ['0'];
    continues.punch_issue_Material.length == 1
        ? globals.punch_issue_Material.add(continues.punch_issue_Material[0])
        : globals.punch_issue_Material = ['0'];
    print('끝!!!!!!!!!!!!');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              // expandedHeight: 20,
              floating: true,
              // pinned: true,
              backgroundColor: Color(0xff2B3745),
              title: CatalogAppBar(
                title: 'Punch Issue',
              ),
            ),
            SliverAppBar(
              toolbarHeight: 90,
              // titleSpacing: 10,
              automaticallyImplyLeading: false,
              // expandedHeight: 50,
              elevation: 0,
              pinned: true,
              // titleSpacing: 0,
              backgroundColor: Color(0xFFE6E6E6),
              title:
                  // _tabbar(
                  //   _tabController,
                  //   _onTapToScroll,
                  // ),
                  CatalogTabBar(
                scrollController: _scrollController,
                tabController: _tabController,
                onTap: _onTapToScroll,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  PageOne(
                    key: page1Key,
                  ),
                  PageTwo(
                    key: page2Key,
                  ),
                  PageThree(
                    key: page3Key,
                  ),
                  _bottonButton(),
                  //todo 버튼 만들고, 이벤트 연결(put)
                  // Create post insert
                  // Read get select
                  // Update put update => 대상 id(where), 변경할 값들(set 구문)
                  // Delete delete delete
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  var api = dotenv.env['PHONE_IP'];

  // 스크롤 알고리즘
  void _onScroll() {
    if (isTapToScroll) return;

    if (page3Key.currentContext != null) {
      page3Height = page3Key.currentContext!.size!.height;
    } else {
      if (page1Key.currentContext != null) {
        page1Height = page1Key.currentContext!.size!.height;
      }
    }

    if (page2Key.currentContext != null) {
      page2Height = page2Key.currentContext!.size!.height;
    }

    if (_scrollController.offset <= page1Height) {
      _tabController.animateTo(0,
          duration: const Duration(milliseconds: 0), curve: Curves.linear);
    } else if (_scrollController.offset > page1Height &&
        _scrollController.offset <= page1Height + page2Height) {
      _tabController.animateTo(1,
          duration: const Duration(milliseconds: 0), curve: Curves.linear);
    } else if (_scrollController.offset > page1Height + page2Height &&
        _scrollController.offset <= page1Height + page2Height + page3Height) {
      _tabController.animateTo(2,
          duration: const Duration(milliseconds: 0), curve: Curves.linear);
    }
  }

//탭 알고리즘
  void _onTapToScroll(int index) async {
    var keys = [page1Key, page2Key, page3Key];
    var previousIndex = _tabController.previousIndex;

    isTapToScroll = true;
    if (index == 0) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    } else {
      if (previousIndex < index) {
        for (var i = previousIndex; i <= index; i++) {
          try {
            final RenderBox renderBox =
                keys[i].currentContext!.findRenderObject() as RenderBox;
            await _scrollController.position.ensureVisible(
              renderBox,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            );
          } catch (e) {}
        }
      } else {
        for (var i = previousIndex; i >= index; i--) {
          final RenderBox renderBox =
              keys[i].currentContext!.findRenderObject() as RenderBox;
          await _scrollController.position.ensureVisible(
            renderBox,
            // keys[i].currentContext!.findRenderObject(),
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
    }
    isTapToScroll = false;
  }

  _bottonButton() {
    var buttonWidth = Get.width * 1 / 3.5;
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      color: Color(0xFFE6E6E6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                primary: Color(0xff71838D), // background
                // onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                Get.back();
              },
              child: Text("Delete Draft"),
            ),
          ),
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                primary: Color(0xff5D8595), // background
                // onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                if (globals.punch_issue_Category.length == 0 ||
                    globals.punch_issue_System.length == 0 ||
                    globals.punch_issue_Sub_System.length == 0 ||
                    globals.punch_issue_Punch_ID.length == 0) {
                  Get.defaultDialog(
                    textCancel: "cancel",
                    cancelTextColor: Colors.black,
                    title: 'Error',
                    titleStyle: TextStyle(color: Colors.red),
                    middleText: 'Check Reqiured fields',
                    buttonColor: Colors.white,
                  );
                } else {
                  if (globals.punch_issue_Status.length == 0) {
                    globals.punch_issue_Status.add('1');
                  } else {
                    globals.punch_issue_Status.removeAt(0);
                    globals.punch_issue_Status.add('1');
                  }
                  globals.punch_issue_Issued_Date = [];
                  globals.punch_issue_Issued_Date
                      .add(DateTime.now().toString().toString());
                  print('global!!!!!!!!!!!');
                  print(globals.punch_issue_Status);
                  Get.toNamed('/confirm');
                }
              },
              child: Text("Save Draft"),
            ),
          ),
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                primary: Color(0xff2F4C5A), // background
                // onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                if (globals.punch_issue_Category.length == 0 ||
                    globals.punch_issue_System.length == 0 ||
                    globals.punch_issue_Sub_System.length == 0 ||
                    globals.punch_issue_Punch_ID.length == 0) {
                  Get.defaultDialog(
                    textCancel: "cancel",
                    cancelTextColor: Colors.black,
                    title: 'Error',
                    titleStyle: TextStyle(color: Colors.red),
                    middleText: 'Check Reqiured fields',
                    buttonColor: Colors.white,
                  );
                } else {
                  print('global!!!!!!!!!!!');
                  if (globals.punch_issue_Status.length == 0) {
                    globals.punch_issue_Status.add('2');
                  } else {
                    globals.punch_issue_Status.removeAt(0);
                    globals.punch_issue_Status.add('2');
                  }
                  globals.punch_issue_Issued_Date = [];
                  globals.punch_issue_Issued_Date
                      .add(DateTime.now().toString().toString());
                  Get.toNamed('/confirm');
                }
              },
              child: Text("Create Issue"),
            ),
          ),
        ],
      ),
    );
  }
}
