import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:edgeworks/dio/login_dio.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals/login.dart' as login;

// import 'package:google_fonts/google_fonts.dart';

/*
* name : LoginPage
* description : login page
* writer : john
* create date : 2021-09-30
* last update : 2021-10-20
* */
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idTextEditController = TextEditingController();
  final _pwTextEditController = TextEditingController();

  // import
  LoginTest _loginTest = LoginTest();

  late double headerTopZone;

  var api = dotenv.env['PHONE_IP'];

  @override
  void initState() {
    login.authority = [];
    login.userID = [];
    login.password = [];
    login.userName = [];
    login.email = [];
    login.company = [];
    login.personalID = [];
    login.department = [];
    _getStatuses();
    print('flutter login????????????');
    super.initState();
  }

  Future<bool> _getStatuses() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage, Permission.camera].request();

    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  @override
  void dispose() {
    _idTextEditController.dispose();
    _pwTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    headerTopZone = Get.mediaQuery.padding.top;
    return Scaffold(
        backgroundColor: Color(0xffF5F9FC),
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              _background(),
              Positioned(
                left: 0,
                right: 0,
                top: Get.height * 0.35,
                bottom: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _textForm(),
                    // _textButton(),
                    _button(),
                    // _textButton(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  // 배경화면
  Widget _background() {
    return SafeArea(
      child: Container(
        width: Get.width,
        height: Get.height,
        child: Padding(
          padding: EdgeInsets.only(top: 150),
          child: Column(children: [
            Image.asset(
              'assets/images/main_Farm in Earth_v1.png',
              scale: 1.5,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.only(right: 80, top: 10),
                    child: Text('EDGE WORKS',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w500)))),
          ]),
        ),
      ),
    );
  }

  // 로그인 폼
  Widget _textForm() {
    return Column(
      children: [
        Container(
          // decoration: _decorations(),
          // height: Get.height * 0.075,
          width: Get.width * 0.8,
          child: Row(children: [
            Expanded(
              child: TextFormField(
                controller: _idTextEditController,
                decoration: InputDecoration(
                    fillColor: Color(0xffFFFFFF),
                    filled: true,
                    prefixIcon:
                        Icon(Icons.person, color: Colors.grey, size: 25),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(25)),
                    hintText: '아이디',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 15)),
                onChanged: (text) {
                  setState(() {});
                },
              ),
            ),
          ]),
        ),
        // SizedBox(
        //   height: Get.height * 0.03,
        // ),
        Container(
          padding: EdgeInsets.only(top: 25),
          // height: Get.height * 1 / 30,
          // height: Get.height * 0.075,
          width: Get.width * 0.8,
          child: Row(children: [
            Expanded(
              child: TextFormField(
                controller: _pwTextEditController,
                obscureText: true,
                decoration: InputDecoration(
                    fillColor: Color(0xffFFFFFF),
                    filled: true,
                    prefixIcon:
                        Icon(Icons.vpn_key_sharp, color: Colors.grey, size: 25),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(25)),
                    hintText: '비밀번호',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 15)
                    // labelText: AppLocalizations.of(context)!.loginPW,
                    ),
                onChanged: (text) {
                  setState(() {});
                },
              ),
            ),
          ]),
        ),
      ],
    );
  }

  // 로그인 버튼
  Widget _button() {
    return Column(children: [
      Container(
        height: Get.height * 0.08,
        width: Get.width * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Color(0xff4cbb8b),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
          onPressed: () async {
            var uid = _idTextEditController.text;
            var pw = _pwTextEditController.text;
            await _loginTest.loginTest(uid, pw); // Get.toNamed('/home');
            // Get.toNamed('/home');
            // Get.toNamed('/sensor');
          },
          child: Text(
            '로그인',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      _textButton()
    ]);
  }

  // 회원가입 폼
  // Widget _signupText() {
  //   return Column(
  //     children: [
  //       Container(
  //         // width: 1,
  //         height: 3,
  //         child: Icon(
  //           Icons.arrow_drop_down,
  //           size: 50,
  //         ),
  //       ),
  //       Text(
  //         AppLocalizations.of(context)!.signUpText,
  //         style: TextStyle(fontSize: 13, color: Colors.grey),
  //       ),
  //     ],
  //   );
  // }

// 비밀번호 변경 / 카카오 채널 연결
  Widget _textButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
          onPressed: () {
            Get.toNamed("/signup");
          },
          child: Text(
            '비밀번호 변경',
            style: TextStyle(color: Color(0xff2E6645), fontSize: 14),
          )),
      Text(
        '/',
        style: TextStyle(color: Color(0xff2E6645), fontSize: 14),
      ),
      TextButton(
          onPressed: _launchURL,
          child: Text(
            '카카오 채널 연결',
            style: TextStyle(color: Color(0xff2E6645), fontSize: 14),
          ))
    ]);
  }

  //카카오 채널 url launcher
  _launchURL() async {
    const url = 'http://pf.kakao.com/_xledxfb';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // decoration(without box shadow)
  BoxDecoration _decorations() {
    return BoxDecoration(
      color: Color(0xffFFFFFF),
      borderRadius: BorderRadius.circular(30),
    );
  }

// 로그인 에러 다이얼로그
//   void _showDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: new Text(AppLocalizations.of(context)!.loginDialogText),
//           actions: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 new ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     primary: Color(0xff71838D),
//                   ),
//                   child:
//                       new Text(AppLocalizations.of(context)!.loginDialogButton),
//                   onPressed: () {
//                     _idTextEditController.clear();
//                     _pwTextEditController.clear();
//                     Get.back();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
}
