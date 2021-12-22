import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:plms_start/pages/utils/button_issue.dart';
import 'package:plms_start/pages/utils/header_issue.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals/login.dart' as login;
// import '../globals/issue.dart' as issue;
import '../globals/photos.dart' as photos;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'screen_punch.dart';

/*
* name : PhtoList
* description : don't send photo data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class PhotoList extends StatefulWidget {
  const PhotoList({Key? key}) : super(key: key);

  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  var api = dotenv.env['PHONE_IP'];

  List data = [];

  @override
  void initState() {
    _photoListData();

    // print(photos.photos_Image_Path[1].substring(14).toString());
    super.initState();
  }

  void _photoListData() async {
    print('시작!!!!!!!!!!!!');
    var url = Uri.parse('$api/summury/loadpunch/');
    for (var i = 0; i < photos.photos_Punch_ID.length; i++) {
      var response = await http.post(url, body: {
        'punchID': photos.photos_Punch_ID[i],
        'userID': login.userID[0],
      });
      var loadPunch = jsonDecode(response.body);
      if (loadPunch.length != 0) {
        data += loadPunch;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2B3745),
        automaticallyImplyLeading: false,
        title: Header(title: "Upload Photos"),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFFE6E6E6),
            child: Container(
              width: MediaQuery.of(context).size.width,
              // width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Container(
                  color: Color(0xff2B3745),
                  height: Get.height * 1 / 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '  - Please connect to WIFI and Upload',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      Text(
                        'Total photos : ${data.length}',
                        style: TextStyle(color: Colors.green, fontSize: 8),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: _photoPage(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: Get.height * 1 / 9,
        color: Color(0xFFE6E6E6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 1 / 2.4,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff2F4C5A), // background
                  // onPrimary: Colors.white, // foreground
                ),
                onPressed: () async {
                  var url = Uri.parse('$api/summury/uploadphotos');

                  for (var i = 0; i < data.length; i++) {
                    await http.post(url, body: {
                      'punchID': photos.photos_Punch_ID[i],
                    });
                  }

                  // Get.offAllNamed('/home');
                  _sendImage();
                  print(photos.photos_Punch_ID);
                  Get.toNamed('/home');
                },
                child: Text("Upload"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoPage() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      // Color(0xFFE6E6E6),
      // width: Get.width,
      // height: Get.height,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "${data[index]['punchID']},${data[index]['category']},${data[index]['discipline']},${data[index]['unit']},${data[index]['area']}"),
                _boxsize(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data[index]['systemID'],
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                      // softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      width: Get.width * 1 / 5,
                      height: Get.height * 1 / 30,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              primary: photos.photos_Punch_Step[index] == 1
                                  ? Color(0xff55b093)
                                  : Color(0xffb88d6a)),
                          onPressed: () {},
                          child: photos.photos_Punch_Step[index] == 1
                              ? Text("complete")
                              : Text("open")),
                    )
                  ],
                ),
                _boxsize(),
                Divider(
                  thickness: 2,
                ),
                _boxsize(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _boxsize() {
    return SizedBox(
      height: 10,
    );
  }

  List imageFileList = photos.photos_Local_Path;
  List imageName = photos.photos_Image_Path;
  // List imageName = photos.;
  Future<void> _sendImage() async {
    // print(photos.photos_Image_Path[0]);
    // print(photos.photos_Image_Path[1]);
    print(imageFileList.length);
    var url = Uri.parse('$api/summury/uploadfile');
    var request = http.MultipartRequest('POST', url);
    // for (var imageFile in imageFileList) {
    for (int i = 0; i < imageFileList.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'imgFile',
        imageFileList[i],
        filename: imageName[i].substring(14).toString(),
        contentType: new MediaType('image', 'png'),
      ));
      print(i);
    }

    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
  }
}
