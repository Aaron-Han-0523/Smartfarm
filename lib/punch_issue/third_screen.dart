import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:plms_start/punch_issue/image_painter.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../pages/utils/title_text.dart';
import '../globals/globals.dart' as globals;
import '../globals/issue.dart' as issue;
/*
* name : PageThree
* description : punch issue three page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class PageThree extends StatefulWidget {
  const PageThree({Key? key}) : super(key: key);

  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
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
                    // DropboxText(text: 'Action On'),
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
  List _imageData = globals.punch_issue_Photo;
  bool status = true;
  Widget _imagePicker() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          _swichWidget('Upload Images now'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Photo'),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _showDialog2();
                    });
                  },
                  icon: Icon(
                    Icons.add_a_photo,
                    size: Get.height * 1 / 18,
                  )),
            ],
          ),
          // i) image 를 서버에 업로드 -> 백엔드 웹서버에 파일을 올린다. -> /usr/local/applications/plms/uploads
          // ii) filename 지정해주고, 경로를 지정
          // upload file table : file id, original filename, server filename, server path, time, device path
          // iii) 실제 구현 측면에서 타이밍
          // 1) 바로 업로드
          // 2) 나중 업로드

          // 저장 타이밍 2가지
          // 테이블 영구적인 저장
          // 기기내의 저장소 -> sqlite -> (x)

          // i) 바로 업로드
          // ii) 나중에 업로드

          // 이미지 저장 및 보기
          Container(
            height: Get.height * 1 / 6.6,
            width: Get.width,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              // scrollDirection: Axis.horizontal,
              itemCount: _imageData.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      InkWell(
                        onTap: () async {
                          print('hi');
                          // _imagePainter(index);
                          // final imageData = await Get.to(() => ImagePainters(),
                          //     arguments: _imageList[index].path);
                          // setState(() {
                          //   _imageData.add(imageData);
                          // });
                          print('hihi');
                        },
                        child: Image.file(
                          // File(_imageList[index].path),
                          File(_imageData[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          child: IconButton(
                            onPressed: () {
                              _showDialog(index);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      )
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

  var api = dotenv.env['PHONE_IP'];
  // var api = dotenv.env['EMUL_IP'];

//   }

  // 스위치 버튼
  Widget _swichWidget(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        FlutterSwitch(
          activeColor: Colors.green,
          width: 40.0,
          height: 20.0,
          valueFontSize: 10.0,
          toggleSize: 10.0,
          value: status,
          borderRadius: 30.0,
          // padding: 3.0,
          showOnOff: true,
          onToggle: (val) {
            setState(() {
              status = val;
            });
            if (status == true) {
              globals.punch_issue_Switch.removeAt(0);
              globals.punch_issue_Switch.add('1');
              print(globals.punch_issue_Switch);
            } else {
              globals.punch_issue_Switch.removeAt(0);
              globals.punch_issue_Switch.add('0');
              print(globals.punch_issue_Switch);
            }
          },
        ),
      ],
    );
  }

  // 카메라 갤러리 선택
  void _showDialog2() {
    double _imageSize = Get.width * 1 / 11;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    imageSelect();
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/gallery_button.png',
                        height: _imageSize,
                        width: _imageSize,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Open Gallery",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    videoSelect();
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/camera_button.png',
                        height: _imageSize,
                        width: _imageSize,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Open Camera",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // 이미지 삭제
  void _showDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text("Are you sure you want to Delete?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new ElevatedButton(
                  child: new Text("No"),
                  onPressed: () {
                    Get.back();
                  },
                ),
                new ElevatedButton(
                  child: new Text("Yes"),
                  onPressed: () {
                    _imageData.removeAt(index);
                    globals.punch_issue_Photo_Name.removeAt(index);
                    globals.punch_issue_Photo_Path.removeAt(index);
                    globals.punch_issue_Photo = _imageData;
                    print(globals.punch_issue_Photo);
                    setState(() {});
                    Get.back();
                  },
                ),
              ],
            )
          ],
        );
      },
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

        // Get.to(ImagePainters());
        // _imageList.add(selectedImage);
        // print(selectedImage.runtimeType);
        // print(selectedImage);
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
                Container(
                  width: Get.width * 1 / 2.7,
                  height: Get.height * 1 / 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff8ab898), padding: EdgeInsets.all(0)),
                    onPressed: () async {
                      globals.punch_issue_Drawings_File = [];
                      var url = Uri.parse('$api/summury/drawingspath/');
                      var response = await http.post(url, body: {
                        'projectID': issue.projectList[0],
                        'systemID': globals.punch_issue_System[0],
                        'subsystem': globals.punch_issue_Sub_System[0],
                      });
                      var jsonDatas = jsonDecode(response.body);
                      print("response.body!!!!!!!!!!!!!!!");
                      print(jsonDatas);
                      if (jsonDatas.length == 0) {
                        return null;
                      } else {
                        if (globals.punch_issue_Drawings.length == 0) {
                          globals.punch_issue_Drawings
                              .add(jsonDatas[0]['drawingNo']);
                          globals.punch_issue_Drawings_Path
                              .add(jsonDatas[0]['imagePath']);
                          print(globals.punch_issue_Drawings);
                        } else {
                          globals.punch_issue_Drawings.removeAt(0);
                          globals.punch_issue_Drawings_Path.removeAt(0);
                          globals.punch_issue_Drawings
                              .add(jsonDatas[0]['drawingNo']);
                          globals.punch_issue_Drawings_Path
                              .add(jsonDatas[0]['imagePath']);
                        }
                        var url2 = Uri.parse('$api/summury/drawingsload');
                        var response2 = await http.get(url2, headers: {
                          "imagePath": globals.punch_issue_Drawings_Path[0]
                          // "imagePath": 'upload/drawings/pdfs/8776892-01.png'
                        });
                        final directory =
                            (await getApplicationSupportDirectory()).path;
                        Uint8List jsonData = response2.bodyBytes;
                        print(
                            '!!!!!!!!!!!!json222222222!!!!!!!!!!!!!!!!!!!!!!!!');
                        print(directory);
                        final image = File(
                            // '$directory/${projectID}_${punchID}_${userID}_${photos.photos_Image_Path[i].substring(14)}'
                            '$directory/${globals.punch_issue_Drawings[0]}}');
                        print('!!!!!!!!!!!!image!!!!!!!!!!!!!!!!!!!!!!!!');
                        print(image.runtimeType);
                        image.writeAsBytesSync(jsonData);

                        globals.punch_issue_Drawings_File.add(image);
                        print(globals.punch_issue_Drawings_File);
                        setState(() {});
                      }
                    },
                    child: Text(
                      "View drawing",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),

                Container(
                  width: Get.width * 1 / 3.5,
                  height: Get.height * 1 / 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff8ab898), padding: EdgeInsets.all(0)),
                    onPressed: () {
                      Get.toNamed("/draft");
                      // Get.to(() => DraftPage2());
                      // FileImage();
                    },
                    child: Text(
                      "Location",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                // Text(pixelList),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onLongPress: () {
                setState(() {
                  // Get.toNamed("/draft");
                });
              },
              onDoubleTap: () {
                setState(() {});
              },
              child: Container(
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
                            globals.punch_issue_Pixel_X.length == 1
                                ? Transform.translate(
                                    offset: Offset(
                                        globals.punch_issue_Pixel_cdX[0],
                                        globals.punch_issue_Pixel_cdY[0]),
                                    child: Icon(Icons.add_location_sharp))
                                : Container()
                          ],
                        )
                      : null),
            )
          ],
        ),
      ),
    );
  }
}
