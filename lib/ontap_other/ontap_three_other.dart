import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:plms_start/punch_issue/image_painter.dart';
// import 'package:flutter_switch/flutter_switch.dart';

import '../pages/utils/title_text.dart';
import '../globals/globals.dart' as globals;
import '../globals/punch_draft.dart' as draft;
/*
* name : ontap_three_other
* description : other third page
* writer : walter
* create date : 2021-09-30
* last update : 2021-10-20
* */

class OntapThird extends StatefulWidget {
  const OntapThird({Key? key}) : super(key: key);

  @override
  _OntapThirdState createState() => _OntapThirdState();
}

class _OntapThirdState extends State<OntapThird> {
  // double _pixelX = draft.punch_issue_Pixel_X[0];
  // double _pixelY = draft.punch_issue_Pixel_Y[0];
  @override
  Widget build(BuildContext context) {
    var radius = Radius.circular(10);
    return Container(
      color: Color(0xFFE6E6E6),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xffB7C5B9),
                borderRadius:
                    BorderRadius.only(topLeft: radius, bottomLeft: radius),
              ),
              height: MediaQuery.of(context).size.height,
              width: Get.width * 1 / 50,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: Get.width - Get.width * 0.83 / 8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(topRight: radius, bottomRight: radius),
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
                  children: [
                    Row(
                      children: [
                        TitleText(
                          title: 'Attachment',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _imagePicker(),
                    _draftView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이미지 선택 저장
  final ImagePicker _picker = ImagePicker();
  List _imageData = draft.punch_issue_Photo;
  bool status = true;
  Widget _imagePicker() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          // _swichWidget('Upload Images now'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Photo'),
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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      InkWell(
                        onTap: () async {},
                        child: Image.file(
                          // File(_imageList[index].path),
                          File(_imageData[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 갤러리 이미지 선택
  void imageSelect() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    try {
      if (selectedImage!.path.isNotEmpty) {
        final imageData =
            await Get.to(() => ImagePainters(), arguments: selectedImage.path);
        if (imageData != null) {
          setState(() {
            _imageData.add(imageData);
            globals.punch_issue_Photo = _imageData;
            print(globals.punch_issue_Photo);
          });
        }
      }
      setState(() {});
    } catch (e) {}
  }

  // 카메라 이미지 선택
  void videoSelect() async {
    final XFile? takenImage =
        await _picker.pickImage(source: ImageSource.camera);
    try {
      if (takenImage!.path.isNotEmpty) {
        final imageData =
            await Get.to(() => ImagePainters(), arguments: takenImage.path);
        if (imageData != null) {
          setState(() {
            _imageData.add(imageData);
            globals.punch_issue_Photo = _imageData;
            print(globals.punch_issue_Photo);
          });
        }
      }

      setState(() {});
    } catch (e) {}
  }

// 도면 보기 위젯
  Widget _draftView() {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height - 305,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('View drawing'),
                Container(
                  width: Get.width * 1 / 4.1,
                  height: Get.height * 1 / 30,
                ),
                // Container(
                //   width: Get.width * 1 / 3.5,
                //   height: Get.height * 1 / 30,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         primary: Color(0xff8ab898), padding: EdgeInsets.all(0)),
                //     onPressed: () {
                //       setState(() {
                //         print(draft.punch_issue_Pixel_X.length);
                //       });
                //     },
                //     child: Text(
                //       "Location",
                //       style: TextStyle(fontSize: 13),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.width - 90,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: globals.punch_issue_Drawings_File.length == 1
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          child: Image.file(
                            globals.punch_issue_Drawings_File[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        draft.punch_issue_Pixel_X.length == 1
                            ? Transform.translate(
                                offset: Offset(
                                    draft.punch_issue_Pixel_X[0] * 50,
                                    draft.punch_issue_Pixel_Y[0] * 50),
                                child: Icon(Icons.add_location_sharp))
                            : Container()
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
