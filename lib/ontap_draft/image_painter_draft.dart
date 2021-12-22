import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';

// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// import '../globals/globals.dart' as globals;
import 'package:http/http.dart' as http;
import '../globals/punch_draft.dart' as draft;
import '../globals/issue.dart' as issue;
import '../globals/login.dart' as login;
/*
* name : ImagePainters
* description : image painter page
* writer : walter
* create date : 2021-09-30
* last update : 2021-10-20
* */

class ImagePainters2 extends StatefulWidget {
  @override
  _ImagePainters2State createState() => _ImagePainters2State();
}

class _ImagePainters2State extends State<ImagePainters2> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();

  String imageData = Get.arguments;
  List _imageList = [];
  String projectID = issue.projectList[0];
  String punchID = draft.punch_issue_Punch_ID.length == 0
      ? 'PunchID'
      : draft.punch_issue_Punch_ID[0];
  String userID = login.userID[0];

  int idx = draft.punch_issue_Photo.length + 1;

  var api = dotenv.env['PHONE_IP'];

  // 이미지 저장 함수
  void saveImage() async {
    draft.punch_issue_Photo_New_Name = [];
    draft.punch_issue_Photo_New_Path = [];
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
    draft.punch_issue_Photo_New_Path.add(path);
    draft.punch_issue_Photo_New_Name.add(fileName);
    print('globals!!!!!!!!!!!!!!!!');
    print(draft.punch_issue_Photo_New_Name);

    var url2 = Uri.parse('$api/summury/photos');

    await http.post(url2, body: {
      'punchID': draft.punch_issue_Punch_ID[0],
      'punchStep': '1',
      'seq': '${draft.punch_issue_Count + 1}',
      'localPath':
          '${draft.punch_issue_Photo_New_Path[0]}${draft.punch_issue_Photo_New_Name[0]}',
      'imagePath': 'upload/photos/${draft.punch_issue_Photo_New_Name[0]}',
      'uploaded': '0',
      'uploadDate': DateTime.now().toString(),
    });
    draft.punch_issue_Count += 1;
    draft.punch_issue_Photo_Path.add(
        '${draft.punch_issue_Photo_New_Path[0]}${draft.punch_issue_Photo_New_Name[0]}');
    draft.punch_issue_Photo_Name
        .add('upload/photos/${draft.punch_issue_Photo_New_Name[0]}');
    Get.back();
    Get.back(result: _imageList[0]);
  }

  // 이미지 저장중 로딩 함수
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
