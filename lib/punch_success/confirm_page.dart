import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
// import 'package:get/get.dart';
import 'package:plms_start/pages/utils/button_confirm.dart';
import 'package:plms_start/pages/utils/header_issue.dart';

import '../globals/globals.dart' as globals;
import '../globals/login.dart' as login;
import '../globals/issue.dart' as issue;

// import 'components/screenList.dart';

class ConfirmPage extends StatefulWidget {
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  // String punchID = 'punchID';

  // String date = 'date';

  // String issuedBy = 'issuedBy';
  // String unit = 'unit';
  // String area = 'area';
  // String system = 'system';
  // String subsystem = 'subsystem';
  // String tagnumber = 'tagnumber';
  // String category = 'category';
  String punchID = globals.punch_issue_Punch_ID[0];
  var date = globals.punch_issue_Issued_Date.length == 1
      ? globals.punch_issue_Issued_Date[0]
      : '';
  String issuedBy = login.userID[0];
  String unit = '';
  String area = '';
  String system = '';

  String subsystem = '';

  String tagnumber = '';

  String category = globals.punch_issue_Category[0];

  void initState() {
    _imageData = [];
    if (globals.punch_issue_Photo.length > 0) {
      for (var i = 0; i < globals.punch_issue_Photo.length; i++) {
        _imageData.add(globals.punch_issue_Photo[i]);
      }
    }

    for (var i = 0; i < issue.systemsList.length; i++) {
      if (issue.systemsList[i] == globals.punch_issue_System[0]) {
        system = issue.systemsNameList[i];
      }
    }
    for (var i = 0; i < issue.subsystemList.length; i++) {
      if (issue.subsystemList[i] == globals.punch_issue_Sub_System[0]) {
        subsystem = issue.subsystemNameList[i];
      }
    }

    if (globals.punch_issue_Unit.length != 0 &&
        globals.punch_issue_Unit[0] != null) {
      unit = globals.punch_issue_Unit[0];
    }
    if (globals.punch_issue_Area.length != 0 &&
        globals.punch_issue_Area[0] != null) {
      area = globals.punch_issue_Area[0];
    }
    if (globals.punch_issue_Tag_Number.length != 0 &&
        globals.punch_issue_Tag_Number[0] != null) {
      tagnumber = globals.punch_issue_Tag_Number[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var radius = Radius.circular(10);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2B3745),
        automaticallyImplyLeading: false,
        title: Header(
          title: "Punch Issue",
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFE6E6E6),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffB7C5B9),
                          borderRadius: BorderRadius.only(
                              topLeft: radius, bottomLeft: radius),
                        ),
                        height: Get.height * 7.5 / 9,
                        width: Get.width * 1 / 50,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: Get.height * 7.5 / 9,
                        width: Get.width - Get.width * 0.83 / 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: radius, bottomRight: radius),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffB7C5B9),
                              offset: Offset(0, 0.3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Punch Issue Confirmation",
                                style: TextStyle(fontSize: 20),
                              ),
                              _sizedBox(),
                              Text(
                                "Plsease confirm created Punch Issue",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _rowData("Punch ID", punchID),
                              _sizedBox(),
                              _rowData(
                                  "Issued Date",
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateTime.parse(date))
                                      .toString()),
                              _sizedBox(),
                              _rowData("Issued By", issuedBy),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                height: Get.height * 2.2 / 4,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _rowData2('Unit', unit),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _rowData2('Area', area),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _colData(
                                      'System',
                                      system,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _colData('Sub-system', subsystem),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _rowData2(
                                      'Tag Number',
                                      tagnumber,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _rowData2('Category', category),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _imagePicker(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConfirmButton(

          // name: '/',
          buttonname1: "Back",
          buttonname2: "Cancel",
          buttonname3: "Confirm"),
    );
  }

  Widget _sizedBox() {
    return SizedBox(
      height: 5,
    );
  }

  Widget _rowData(var title, var data) {
    return Row(
      children: [
        SizedBox(
            width: Get.width * 1 / 4,
            child: Text(
              title,
              style: TextStyle(color: Colors.black54),
            )),
        Text(
          data,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _colData(var title, var data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: Get.width * 2 / 7,
            child: Text(
              title,
              style: TextStyle(color: Colors.grey),
            )),
        Text(
          data,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }

  Widget _rowData2(var title1, var data1) {
    return Row(
      children: [
        SizedBox(
            width: Get.width * 2 / 7,
            child: Text(
              title1,
              style: TextStyle(color: Colors.grey),
            )),
        Text(
          data1,
        ),
      ],
    );
  }
}

List _imageData = [];
bool status = true;
Widget _imagePicker() {
  return Container(
    decoration: BoxDecoration(color: Colors.white),
    height: Get.height * 1 / 6.5,
    width: Get.width,
    child: Column(
      children: [
        // _swichWidget('Upload Images now'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Photo',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        // 이미지 저장 및 보기
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: _imageData.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.file(
                  // File(_imageList[index].path),
                  File(_imageData[index].path),
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
