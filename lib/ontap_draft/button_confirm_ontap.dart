import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import '/globals/login.dart' as login;
import '/globals/issue.dart' as issue;
import '/globals/punch_draft.dart' as draft;

/*
* name : button_confirm_ontap
* description : draft ontap confirm button page
* writer : walter
* create date : 2021-09-30
* last update : 2021-10-05
* */

class OnTapConfirmButton extends StatefulWidget {
  OnTapConfirmButton(
      {Key? key,
      // required this.name,
      required this.buttonname1,
      required this.buttonname2,
      required this.buttonname3})
      : super(key: key);
  // String name;
  final String buttonname1;
  final String buttonname2;
  final String buttonname3;

  @override
  _OnTapConfirmButtonState createState() => _OnTapConfirmButtonState();
}

class _OnTapConfirmButtonState extends State<OnTapConfirmButton> {
  var api = dotenv.env['PHONE_IP'];
  // var api = dotenv.env['EMUL_IP'];
  var buttonWidth = Get.width * 1 / 3.5;

  List _nameData = [
    'projectID',
    'punchID',
    'category',
    'systemID',
    'subsystem',
    'discipline',
    'status',
    'unit',
    'area',
    'tagNumber',
    'bulkItem',
    'bulkName',
    'department',
    'targetDate',
    'issuedBy',
    'issuedDate',
    'raisedBy',
    'designChgReq',
    'materialReq',
    'issueDescription',
  ];

  List _listData = [
    issue.projectList,
    draft.punch_issue_Punch_ID,
    draft.punch_issue_Category,
    draft.punch_issue_System,
    draft.punch_issue_Sub_System,
    draft.punch_issue_Discipline,
    draft.punch_issue_Status,
    draft.punch_issue_Unit,
    draft.punch_issue_Area,
    draft.punch_issue_Tag_Number,
    draft.punch_issue_Bulk_Item,
    draft.punch_issue_Bulk_Name,
    draft.punch_issue_Action_On,
    draft.punch_issue_Date,
    login.userID,
    draft.punch_issue_Issued_Date,
    draft.punch_issue_Raised_On,
    draft.punch_issue_Design,
    draft.punch_issue_Material,
    draft.punch_issue_Description,
  ];
  List _keyword = draft.punch_issue_Keyword;
  Map<String, String> _mapData = {};

  @override
  void initState() {
    for (int i = 0; i < _listData.length; i++) {
      if (_listData[i].length != 0) {
        _mapData[_nameData[i]] = _listData[i][0];
      }
    }
    if (_keyword.length == 1) {
      _mapData['keyword1'] = _keyword[0];
    } else if (_keyword.length == 2) {
      _mapData['keyword1'] = _keyword[0];
      _mapData['keyword2'] = _keyword[1];
    } else if (_keyword.length == 3) {
      _mapData['keyword1'] = _keyword[0];
      _mapData['keyword2'] = _keyword[1];
      _mapData['keyword3'] = _keyword[2];
    } else if (_keyword.length == 4) {
      _mapData['keyword1'] = _keyword[0];
      _mapData['keyword2'] = _keyword[1];
      _mapData['keyword3'] = _keyword[2];
      _mapData['keyword4'] = _keyword[3];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE6E6E6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.,
        children: [
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff71838D),
              ),
              onPressed: () {
                Get.back();
              },
              child: Text(widget.buttonname1),
            ),
          ),
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff71838D),
              ),
              onPressed: () {
                // print(_mapData);
                _showDialog('/home');
              },
              child: Text(widget.buttonname2),
            ),
          ),
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff2F4C5A), // background
                // onPrimary: Colors.white, // foreground
              ),
              onPressed: () async {
                print('hi');
                var url = Uri.parse('$api/summury/draftupdate');

                await http.post(url, body: _mapData);
                print('보낸다!!!!!!!!');

                var url2 = Uri.parse('$api/summury/photosupdate');
                if (draft.punch_issue_Photo.length == 1) {
                  await http.post(url2, body: {
                    'punchID': draft.punch_issue_Punch_ID[0],
                    'punchStep': '1',
                    'seq': '1',
                    'localPath': draft.punch_issue_Photo_Path[0].toString(),
                    'imagePath': draft.punch_issue_Photo_Name[0].toString(),
                    'uploaded': draft.punch_issue_Switch[0],
                    'uploadDate': DateTime.now().toString(),
                  });
                } else if (draft.punch_issue_Photo.length > 1) {
                  for (var i = 0; i < draft.punch_issue_Photo.length; i++) {
                    await http.post(url2, body: {
                      'punchID': draft.punch_issue_Punch_ID[0],
                      'punchStep': '1',
                      'seq': '${i + 1}',
                      'localPath': draft.punch_issue_Photo_Path[i].toString(),
                      'imagePath': draft.punch_issue_Photo_Name[i].toString(),
                      'uploaded': draft.punch_issue_Switch[0],
                      'uploadDate': DateTime.now().toString(),
                    });
                  }
                }
                if (draft.punch_issue_Photo.length > 0) {
                  _sendImage();
                }

                print('간다!!!!!!!!!!!!!!!!!!!');

                Get.offAllNamed("/home");
              },
              child: Text(widget.buttonname3),
            ),
          ),
        ],
      ),
    );
  }

// 사진 보내기
  List imageFileList = draft.punch_issue_Photo;
  List imageName = draft.punch_issue_Photo_Name;
  Future<void> _sendImage() async {
    var url = Uri.parse('$api/summury/uploadfile');
    var request = http.MultipartRequest('POST', url);
    // for (var imageFile in imageFileList) {
    for (int i = 0; i < imageFileList.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'imgFile',
        imageFileList[i].path,
        filename: imageName[i].toString(),
        contentType: new MediaType('image', 'png'),
      ));
    }

    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
  }

// 취소 확인 다이얼 로그
  void _showDialog(String page) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(
              "Are you sure you want to Cancel? \n Changes that you made may not be saved"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff71838D),
                  ),
                  child: new Text("No"),
                  onPressed: () {
                    Get.back();
                  },
                ),
                new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff2F4C5A), // background
                    // onPrimary: Colors.white, // foreground
                  ),
                  child: new Text("Yes"),
                  onPressed: () {
                    setState(() {});
                    Get.toNamed(page);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
