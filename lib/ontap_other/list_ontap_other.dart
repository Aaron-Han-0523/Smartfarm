import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// import 'package:plms_start/pages/utils/button_issue.dart';
import 'package:plms_start/punch_issue/appbar_screen.dart';
import 'package:plms_start/punch_issue/tabbar_screen.dart';
import 'ontap_one_other.dart';
import 'ontap_three_other.dart';
import 'ontap_two_other.dart';

// import 'package:http/http.dart' as http;
import '../globals/globals.dart' as globals;
import '../globals/login.dart' as login;
import '../globals/issue.dart' as issue;
import '../globals/photos.dart' as photos;
import '../globals/punch_draft.dart' as draft;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
* name : list_ontap_other
* description : other ontap page
* writer : walter
* create date : 2021-09-30
* last update : 2021-10-20
* */

class OnTapPage extends StatefulWidget {
  const OnTapPage({Key? key}) : super(key: key);

  @override
  _OnTapPageState createState() => _OnTapPageState();
}

class _OnTapPageState extends State<OnTapPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  final page1Key = new GlobalKey();
  final page2Key = new GlobalKey();
  final page3Key = new GlobalKey();

  double page1Height = 0;
  double page2Height = 0;
  double page3Height = 0;
  bool isTapToScroll = false;

  List datas = Get.arguments[1];
  int idx = Get.arguments[0];

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _onScroll();
    });

    globals.punch_issue_Drawings = [];
    globals.punch_issue_Drawings_Path = [];
    globals.punch_issue_Drawings_File = [];
    globals.punch_issue_Pixel_X = [];
    globals.punch_issue_Pixel_Y = [];
    globals.punch_issue_Pixel_cdX = [];
    globals.punch_issue_Pixel_cdY = [];

    draft.punch_issue_Photo = [];
    photos.photos_Image_Path = [];
    print('photos');
    _photoPath();
    Future.delayed(const Duration(milliseconds: 1000), () {
      _photoDatas();
    });
    Future.delayed(const Duration(milliseconds: 1300), () {
      _drawingsDatas();
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      _drawingPath();
    });

    print('Rmx');
    super.initState();
  }

  String projectID = issue.projectList[0];
  String punchID = draft.punch_issue_Punch_ID.length == 0
      ? 'PunchID'
      : draft.punch_issue_Punch_ID[0];
  String userID = login.userID[0];

  Future<void> _photoPath() async {
    print('start!!!!!!!!!!');
    var url = Uri.parse('$api/summury/photospath');
    var response = await http.post(url, body: {
      'punchID': datas[idx]['punchID'],
    });
    var photoPath = jsonDecode(response.body);
    print(photoPath);
    for (var i = 0; i < photoPath.length; i++) {
      var imagePath2 = '${photoPath[i]['imagePath']}';
      photos.photos_Image_Path.add(imagePath2);
    }
    print(photos.photos_Image_Path);
    print('middle');
  }

  Future<void> _drawingsDatas() async {
    globals.punch_issue_Drawings_File = [];
    var url3 = Uri.parse('$api/summury/drawingspath/');
    var response3 = await http.post(url3, body: {
      'projectID': issue.projectList[0],
      'systemID': datas[idx]['systemID'],
      'subsystem': datas[idx]['subsystem'],
    });
    print('drawing');
    var jsonDatas = jsonDecode(response3.body);
    print(jsonDatas);
    if (jsonDatas.length == 0) {
      return null;
    } else {
      if (globals.punch_issue_Drawings.length == 0) {
        globals.punch_issue_Drawings.add(jsonDatas[0]['drawingNo']);
        globals.punch_issue_Drawings_Path.add(jsonDatas[0]['imagePath']);
      } else {
        globals.punch_issue_Drawings.removeAt(0);
        globals.punch_issue_Drawings_Path.removeAt(0);
        globals.punch_issue_Drawings.add(jsonDatas[0]['drawingNo']);
        globals.punch_issue_Drawings_Path.add(jsonDatas[0]['imagePath']);
      }
      print(globals.punch_issue_Drawings);
      var url2 = Uri.parse('$api/summury/drawingsload');
      var response2 = await http.get(url2, headers: {
        "imagePath": globals.punch_issue_Drawings_Path[0]
        // "imagePath": 'upload/drawings/pdfs/8776892-01.png'
      });
      final directory = (await getApplicationSupportDirectory()).path;
      Uint8List jsonData2 = response2.bodyBytes;
      final image = File(
          // '$directory/${projectID}_${punchID}_${userID}_${photos.photos_Image_Path[i].substring(14)}'
          '$directory/${globals.punch_issue_Drawings[0]}}');
      image.writeAsBytesSync(jsonData2);
      globals.punch_issue_Drawings_File.add(image);
      setState(() {});
    }
  }

  Future<void> _photoDatas() async {
    print(photos.photos_Image_Path);
    var url2 = Uri.parse('$api/summury/photosload');
    final directory = (await getApplicationDocumentsDirectory()).path;
    print('middle222');

    for (var i = 0; i < photos.photos_Image_Path.length; i++) {
      var response = await http
          .get(url2, headers: {"imagePath": photos.photos_Image_Path[i]});
      print(response.body);
      Uint8List jsonData = response.bodyBytes;
      print('middle333');
      final image = File(
          '$directory/${projectID}_${punchID}_${userID}_${photos.photos_Image_Path[i].substring(14)}');
      image.writeAsBytesSync(jsonData);
      draft.punch_issue_Photo.add(image);
      // print(draft.punch_issue_Photo);
    }
  }

  Future<void> _drawingPath() async {
    draft.punch_issue_Pixel_X = [];
    draft.punch_issue_Pixel_Y = [];
    var url4 = Uri.parse('$api/summury/pixelload/');
    if (globals.punch_issue_Drawings.length > 0) {
      var response4 = await http.post(url4, body: {
        'punchID': datas[idx]['punchID'],
        'drawingNo': globals.punch_issue_Drawings[0],
      });
      print('drawing');
      var jsonDatass = jsonDecode(response4.body);
      if (jsonDatass.length != 0) {
        for (var i = 0; i < jsonDatass.length; i++) {
          draft.punch_issue_Pixel_X.add(double.parse(jsonDatass[i]['xPixel']));
          draft.punch_issue_Pixel_Y.add(double.parse(jsonDatass[i]['yPixel']));
          print(draft.punch_issue_Pixel_X);
        }
      }
    }

    // print(jsonDatass[0]);

    setState(() {});
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
              automaticallyImplyLeading: false,
              elevation: 0,
              pinned: true,
              backgroundColor: Color(0xFFE6E6E6),
              title: CatalogTabBar(
                scrollController: _scrollController,
                tabController: _tabController,
                onTap: _onTapToScroll,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  OntapFirst(
                    key: page1Key,
                  ),
                  OntapSecond(
                    key: page2Key,
                  ),
                  OntapThird(
                    key: page3Key,
                  ),
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
}
