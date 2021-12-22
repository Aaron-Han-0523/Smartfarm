import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:plms_start/punch_issue/image_painter.dart';
import 'package:plms_start/pages/utils/header_issue.dart';
import 'package:plms_start/pages/utils/title_text.dart';
import 'package:plms_start/punch_main/image_painter_completes.dart';
import '../globals/login.dart' as login;
import '../globals/completes.dart' as completes;

/*
* name : PunchComplete Page
* description : complete page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class PunchComplete extends StatefulWidget {
  const PunchComplete({Key? key}) : super(key: key);

  @override
  _PunchCompleteState createState() => _PunchCompleteState();
}

class _PunchCompleteState extends State<PunchComplete> {
  var api = dotenv.env['PHONE_IP'];
  // var api = dotenv.env['EMUL_IP'];

  var data = Get.arguments[0];
  var id = login.userID.length == 0 ? '' : login.userID[0];
  var password = login.password.length == 0 ? '' : login.password[0];
  var userName = login.userName.length == 0 ? '' : login.userName[0];
  var email = login.email.length == 0 ? '' : login.email[0];
  var company = login.company.length == 0 ? '' : login.company[0];
  var authority = login.authority.length == 0 ? '' : login.authority[0];
  var personalID = login.personalID.length == 0 ? '' : login.personalID[0];
  var department = login.department.length == 0 ? '' : login.department[0];
  @override
  void initState() {
    completes.punch_issue_Punch_ID = [data['punchID']];
    completes.punch_issue_Photo = [];
    completes.punch_issue_Photo_Path = [];
    completes.punch_issue_Photo_Name = [];
    completes.punch_issue_Drawings = [];
    completes.punch_issue_Drawings_File = [];
    completes.punch_issue_Pixel_X = [];
    completes.punch_issue_Pixel_Y = [];
    completes.punch_issue_Switch = ['1'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2B3745),
        automaticallyImplyLeading: false,
        title: Header(
          title: AppLocalizations.of(context)!.completeTitle,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFFE6E6E6),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  color: Color(0xff2B3745),
                  // height: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: _completeComponent(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Color(0xFFE6E6E6),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffB7C5B9),
                            offset: Offset(-7, 0),
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
                                  title: AppLocalizations.of(context)!
                                      .completePageTitle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _imagePicker(),
                            SizedBox(
                              height: 20,
                            ),
                            _description(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFE6E6E6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: Get.width * 2.8 / 7,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff71838D), // background
                  // onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(AppLocalizations.of(context)!.completePageButton1),
              ),
            ),
            SizedBox(
              width: Get.width * 2.8 / 7,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff2F4C5A), // background
                  // onPrimary: Colors.white, // foreground
                ),
                onPressed: () async {
                  print(id);
                  print(data['projectID']);
                  print(data['punchID']);
                  print(DateTime.now());

                  var url = Uri.parse('$api/summury/complete');
                  await http.post(url, body: {
                    'userID': id,
                    'projectID': data['projectID'],
                    'punchID': data['punchID'],
                    'completeComment': desData[0],
                    'completedDate': DateTime.now().toString(),
                  });
                  print('성공이욤');
                  var url2 = Uri.parse('$api/summury/photos');
                  if (completes.punch_issue_Photo.length == 1) {
                    await http.post(url2, body: {
                      'punchID': completes.punch_issue_Punch_ID[0],
                      'punchStep': '2',
                      'seq': '1',
                      'localPath':
                          '${completes.punch_issue_Photo_Path[0]}${completes.punch_issue_Photo_Name[0]}',
                      'imagePath':
                          'upload/photos/${completes.punch_issue_Photo_Name[0]}',
                      'uploaded': completes.punch_issue_Switch[0],
                      'uploadDate': DateTime.now().toString(),
                    });
                  } else if (completes.punch_issue_Photo.length > 1) {
                    for (var i = 0;
                        i < completes.punch_issue_Photo.length;
                        i++) {
                      await http.post(url2, body: {
                        'punchID': completes.punch_issue_Punch_ID[0],
                        'punchStep': '2',
                        'seq': '${i + 1}',
                        'localPath':
                            '${completes.punch_issue_Photo_Path[i]}${completes.punch_issue_Photo_Name[i]}',
                        'imagePath':
                            'upload/photos/${completes.punch_issue_Photo_Name[i]}',
                        'uploaded': completes.punch_issue_Switch[0],
                        'uploadDate': DateTime.now().toString(),
                      });
                    }
                  }
                  if (completes.punch_issue_Switch[0] == '1') {
                    _sendImage();
                  }

                  Get.offAllNamed(
                    '/home',
                    //  arguments: [
                    //   authority,
                    //   id,
                    //   password,
                    //   userName,
                    //   email,
                    //   company,
                    //   personalID,
                    //   department
                    // ]
                  );
                  completes.punch_issue_Photo = [];
                },
                child: Text(AppLocalizations.of(context)!.completePageButton2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendImage() async {
    List imageFileList = completes.punch_issue_Photo;
    List imageName = completes.punch_issue_Photo_Name;
    print('!!!!!!!!!!!!!!name!!!!!!!!!!!!');
    print(imageName);
    print(_imageData);
    print(completes.punch_issue_Photo);
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

  // 사진 카메라에서 이미지 선택
  final ImagePicker _picker = ImagePicker();
  List _imageData = completes.punch_issue_Photo;
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

  // var api = dotenv.env['PHONE_IP'];
  // // var api = dotenv.env['EMUL_IP'];

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
              completes.punch_issue_Switch.removeAt(0);
              completes.punch_issue_Switch.add('1');
              print(completes.punch_issue_Switch);
            } else {
              completes.punch_issue_Switch.removeAt(0);
              completes.punch_issue_Switch.add('0');
              print(completes.punch_issue_Switch);
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
                    completes.punch_issue_Photo_Name.removeAt(index);
                    completes.punch_issue_Photo_Path.removeAt(index);
                    completes.punch_issue_Photo = _imageData;
                    print(completes.punch_issue_Photo);
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
            await Get.to(() => ImagePainters3(), arguments: selectedImage.path);
        if (imageData != null) {
          setState(() {
            _imageData.add(imageData);
            completes.punch_issue_Photo = _imageData;
            print(completes.punch_issue_Photo);
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
            await Get.to(() => ImagePainters3(), arguments: takenImage.path);
        if (imageData != null) {
          setState(() {
            _imageData.add(imageData);
            completes.punch_issue_Photo = _imageData;
            print(completes.punch_issue_Photo);
          });
        }
      }

      setState(() {});
    } catch (e) {}
  }

  // description
  List desData = [];
  Widget _description() {
    return Column(
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context)!.completePageDescription),
          ],
        ),
        TextField(
            onChanged: (String str) {
              setState(() {
                if (desData.length == 0) {
                  desData.add(str);
                } else {
                  desData.removeAt(0);
                  desData.add(str);
                }
                print('globaldata!!!!!!!!!!');
                print(desData);
                print(desData[0]);
              });
            },
            maxLines: 7,
            keyboardType: TextInputType.multiline,
            maxLength: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText:
                  AppLocalizations.of(context)!.completePageDescriptionLabel,
              isDense: true,
            )),
      ],
    );
  }

  // app bar data
  Widget _completeComponent() {
    return Column(
      children: [
        _dataWidget('PunchID', data['punchID']),
        _sized15(),
        _dataWidget('Category', data['category']),
        _sized15(),
        _dataWidget('Area', data['area'] != null ? data['area'] : ''),
        _sized15(),
        _dataWidget('Unit', data['unit'] != null ? data['unit'] : ''),
        _sized15(),
        _dataWidget(
            'Tag Number', data['tagNumber'] != null ? data['tagNumber'] : ''),
        _sized15(),
        _dataWidget('System', data['systemName']),
        _sized15(),
        _dataWidget('Sub-system', data['subsystemName']),
        _sized15(),
        Container(
          width: 500,
          child: Divider(
            color: Color(0xff5D8791),
            thickness: 1.3,
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                data['notAcceptComment'] == null
                    ? ''
                    : data['notAcceptComment'],
                style: TextStyle(color: Color(0xff5D8791)),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _sized15() {
    return SizedBox(
      height: 10,
    );
  }

  // data text widget
  Widget _dataWidget(String title, String datas) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 2 / 7,
          // height: Get.height * 1 / 11,
          child: Text(
            title,
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
        ),
        Flexible(
          child: Text(
            datas,
            style: TextStyle(color: Colors.white, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
