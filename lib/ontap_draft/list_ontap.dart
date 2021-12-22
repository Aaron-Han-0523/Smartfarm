import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plms_start/ontap_draft/confirm_page_ontap.dart';
import 'package:http/http.dart' as http;

// import 'package:plms_start/pages/utils/button_issue.dart';
import 'package:plms_start/punch_issue/appbar_screen.dart';
import 'package:plms_start/punch_issue/tabbar_screen.dart';
import 'ontap_one.dart';
import 'ontap_three.dart';
import 'ontap_two.dart';

// import 'package:http/http.dart' as http;
import '../globals/login.dart' as login;
import '../globals/issue.dart' as issue;
import '../globals/photos.dart' as photos;
import '../globals/punch_draft.dart' as draft;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
* name : list_ontap
* description : draft ontap page
* writer : walter
* create date : 2021-09-30
* last update : 2021-10-20
* */

class OnTapScreen extends StatefulWidget {
  const OnTapScreen({Key? key}) : super(key: key);

  @override
  _OnTapScreennState createState() => _OnTapScreennState();
}

class _OnTapScreennState extends State<OnTapScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  final page1Key = new GlobalKey();
  final page2Key = new GlobalKey();
  final page3Key = new GlobalKey();

  double page1Height = 0;
  double page2Height = 0;
  double page3Height = 0;
  bool isTapToScroll = false;

  List datas = login.draftList;

  String projectID = issue.projectList[0];
  String punchID = draft.punch_issue_Punch_ID.length == 0
      ? 'PunchID'
      : draft.punch_issue_Punch_ID[0];
  String userID = login.userID[0];
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _onScroll();
    });

    datas[Get.arguments]['tagNumber'] != null
        ? draft.punch_issue_Tag_Number = [datas[Get.arguments]['tagNumber']]
        : draft.punch_issue_Tag_Number = [];

    datas[Get.arguments]['bulkItem'] != null
        ? draft.punch_issue_Bulk_Item = [datas[Get.arguments]['bulkItem']]
        : datas[Get.arguments]['bulkName'] != null
            ? draft.punch_issue_Bulk_Item = ['1']
            : draft.punch_issue_Bulk_Item = ['0'];

    datas[Get.arguments]['bulkName'] != null
        ? draft.punch_issue_Bulk_Name = [datas[Get.arguments]['bulkName']]
        : draft.punch_issue_Bulk_Name = [];

    draft.punch_issue_Category = [datas[Get.arguments]['category']];
    draft.punch_issue_System = [datas[Get.arguments]['systemID']];
    draft.punch_issue_Sub_System = [datas[Get.arguments]['subsystem']];

    datas[Get.arguments]['unit'] != null
        ? draft.punch_issue_Unit = [datas[Get.arguments]['unit']]
        : draft.punch_issue_Unit = [];

    datas[Get.arguments]['area'] != null
        ? draft.punch_issue_Area = [datas[Get.arguments]['area']]
        : draft.punch_issue_Area = [];

    draft.punch_issue_Punch_ID = [datas[Get.arguments]['punchID']];

    datas[Get.arguments]['issueDescription'] != null
        ? draft.punch_issue_Description = [
            datas[Get.arguments]['issueDescription']
          ]
        : draft.punch_issue_Description = [];

    datas[Get.arguments]['department'] != null
        ? draft.punch_issue_Action_On = [datas[Get.arguments]['department']]
        : draft.punch_issue_Action_On = [];

    datas[Get.arguments]['discipline'] != null
        ? draft.punch_issue_Discipline = [datas[Get.arguments]['discipline']]
        : draft.punch_issue_Discipline = [];

    datas[Get.arguments]['raisedBy'] != null
        ? draft.punch_issue_Raised_On = [datas[Get.arguments]['raisedBy']]
        : draft.punch_issue_Raised_On = [];

    datas[Get.arguments]['targetDate'] != null
        ? draft.punch_issue_Date = [datas[Get.arguments]['targetDate']]
        : draft.punch_issue_Date = [];

    // datas[Get.arguments]['department'] != null?
    // draft.punch_issue_Keyword = [];

    datas[Get.arguments]['designChgReq'] == '1'
        ? draft.punch_issue_Design = ['1']
        : draft.punch_issue_Design = ['0'];

    datas[Get.arguments]['materialReq'] == '1'
        ? draft.punch_issue_Material = ['1']
        : draft.punch_issue_Material = ['0'];
    photos.photos_Image_Path = [];
    draft.punch_issue_Photo = [];
    // draft.punch_issue_Photo_Path = [];
    // draft.punch_issue_Photo_Name = [];
    draft.punch_issue_Photo_Name = [];
    draft.punch_issue_Photo_Path = [];
    draft.punch_issue_Photo_New_Name = [];
    draft.punch_issue_Photo_New_Path = [];
    draft.punch_issue_Drawings = [];
    draft.punch_issue_Drawings_File = [];
    draft.punch_issue_Drawings_Path = [];
    _photoPath();

    super.initState();
  }

  Future<void> _photoPath() async {
    var url = Uri.parse('$api/summury/photospath');
    var response = await http.post(url, body: {
      'punchID': datas[Get.arguments]['punchID'],
    });
    var photoPath = jsonDecode(response.body);
    draft.punch_issue_Count = 0;
    draft.punch_issue_disCount = 0;

    draft.punch_issue_Count += photoPath.length as int;
    draft.punch_issue_disCount += photoPath.length as int;

    if (photoPath.length > 0) {
      for (var i = 0; i < photoPath.length; i++) {
        var imagePath2 = '${photoPath[i]['imagePath']}';
        draft.punch_issue_Photo_Name.add(imagePath2);
        photos.photos_Image_Path.add(imagePath2);
        var imagePath3 = '${photoPath[i]['localPath']}';
        draft.punch_issue_Photo_Path.add(imagePath3);
        photos.photos_Local_Path.add(imagePath3);
      }
    } else {
      return null;
    }

    var url2 = Uri.parse('$api/summury/photosload');
    final directory = (await getExternalStorageDirectory())!.path;
    if (photos.photos_Image_Path.length > 0) {
      for (var i = 0; i < photos.photos_Image_Path.length; i++) {
        var response = await http
            .get(url2, headers: {"imagePath": photos.photos_Image_Path[i]});

        Uint8List jsonData = response.bodyBytes;

        final image = File(
            '$directory/${projectID}_${punchID}_${userID}_${photos.photos_Image_Path[i].substring(14)}');

        image.writeAsBytesSync(jsonData);

        draft.punch_issue_Photo.add(image);
      }
    } else {
      return null;
    }

    // for (var imageFile in imageFileList) {
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
                  OntapOne(
                    key: page1Key,
                  ),
                  OntapTwo(
                    key: page2Key,
                  ),
                  OntapThree(
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

  // delete save create 버튼
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
              ),
              onPressed: () async {
                var url = Uri.parse('$api/summury/delete');
                var response = await http.post(url, body: {
                  'projectID': issue.projectList[0],
                  'punchID': datas[Get.arguments]['punchID'],
                });
                print(response.body);

                Get.toNamed('/home');
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
                if (draft.punch_issue_Status.length == 0) {
                  draft.punch_issue_Status.add('1');
                } else {
                  draft.punch_issue_Status.removeAt(0);
                  draft.punch_issue_Status.add('1');
                }
                draft.punch_issue_Issued_Date = [];
                draft.punch_issue_Issued_Date
                    .add(DateTime.now().toString().toString());
                Get.to(OnTapConfirmPage());
                // Get.toNamed('/confirm');
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
                if (draft.punch_issue_Status.length == 0) {
                  draft.punch_issue_Status.add('2');
                } else {
                  draft.punch_issue_Status.removeAt(0);
                  draft.punch_issue_Status.add('2');
                }
                draft.punch_issue_Issued_Date = [];
                draft.punch_issue_Issued_Date
                    .add(DateTime.now().toString().toString());
                // Get.toNamed('/confirm');
                Get.to(() => OnTapConfirmPage());
              },
              child: Text("Create Issue"),
            ),
          ),
        ],
      ),
    );
  }
}
