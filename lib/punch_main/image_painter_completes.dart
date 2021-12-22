import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';

// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// import '../globals/globals.dart' as globals;
import '../globals/issue.dart' as issue;
import '../globals/login.dart' as login;
import '../globals/completes.dart' as completes;
/*
* name : ImagePainters
* description : image painter page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class ImagePainters3 extends StatefulWidget {
  @override
  _ImagePainter3sState createState() => _ImagePainter3sState();
}

class _ImagePainter3sState extends State<ImagePainters3> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();

  String imageData = Get.arguments;
  List _imageList = [];
  String projectID = issue.projectList[0];
  String punchID = completes.punch_issue_Punch_ID.length == 0
      ? 'PunchID'
      : completes.punch_issue_Punch_ID[0];
  String userID = login.userID[0];

  // 이미지 저장 함수
  void saveImage() async {
    final image = await _imageKey.currentState!.exportImage();
    final directory = (await getExternalStorageDirectory())!.path;
    print(image);
    await Directory('$directory/sample/').create(recursive: true);
    final path = '$directory/sample/';
    final fileName =
        '${projectID}_${punchID}_${userID}_${DateTime.now().millisecondsSinceEpoch}.png';
    final fullPath = path + fileName;
    final imgFile = File('$fullPath');
    print(imgFile.runtimeType);
    imgFile.writeAsBytesSync(image!);
    print(fullPath.runtimeType);
    _imageList.add(imgFile);
    completes.punch_issue_Photo_Path.add(path);
    completes.punch_issue_Photo_Name.add(fileName);
    print('globals!!!!!!!!!!!!!!!!');
    print(completes.punch_issue_Photo_Name);
    setState(() {});
    Get.back();

    print('간다!');
// 저장 알림 스낵바
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: Colors.grey[700],
    //     padding: const EdgeInsets.only(left: 10),
    //     content: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         const Text("Image Exported successfully.",
    //             style: TextStyle(color: Colors.white)),
    //       ],
    //     ),
    //   ),
    // );
    Get.back(result: _imageList[0]);
  }

  // 로딩 함수
  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
  }

  // void _print() async {
  //   final image = await _imageKey.currentState!.exportImage();
  //   final directory = (await getExternalStorageDirectory())!.path;
  //   final path = '$directory/sample/';
  //   final fileName =
  //       '${projectID}_${punchID}_${userID}_${DateTime.now().millisecondsSinceEpoch}.png';
  //   final fullPath = path + fileName;
  //   // final fullPath =
  //   //     '$directory/sample/${projectID}_${punchID}_${userID}_${DateTime.now().millisecondsSinceEpoch}.png';
  //   // print(directory);
  //   print(path);
  //   print(fileName);
  //   print(fullPath);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              color: Colors.green,
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new_sharp),
            ),
            const Text("Image Painter Example"),
          ],
        ),
        backgroundColor: Color(0xff2B3745),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () {
              _onLoading();
              saveImage();
            },
          ),
          // IconButton(
          //   color: Colors.green,
          //   onPressed: () {
          //     _print();
          //   },
          //   icon: const Icon(Icons.arrow_back_ios_new_sharp),
          // ),
        ],
      ),
      body: ImagePainter.file(
        File(imageData),
        key: _imageKey,
        initialPaintMode: PaintMode.rect,
      ),
    );
  }
}
