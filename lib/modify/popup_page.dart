import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* name : PopUpPage
* description : modify popup page
* writer : walter
* create date : 2021-09-30
* last update : 2021-10-05
* */

class PopUpPage extends StatefulWidget {
  PopUpPage({Key? key}) : super(key: key);

  @override
  _PopUpPageState createState() => _PopUpPageState();
}

class _PopUpPageState extends State<PopUpPage> {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                color: Color(0xffdddddd),
                width: Get.width * 3.15 / 7,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff304d5c)),
                    onPressed: () {
                      Get.offNamed('/modify');
                    },
                    child: Text('Modify User Info'))),
            Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                color: Color(0xffdddddd),
                width: Get.width * 3.15 / 7,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff5C8694)),
                    onPressed: () {
                      Get.offAllNamed('/');
                    },
                    child: Text('Logout'))),
            Container(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                color: Color(0xffdddddd),
                width: Get.width * 3.15 / 7,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff71838c)),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Cancel'))),
          ],
        ),
      ),
    );
  }
}
