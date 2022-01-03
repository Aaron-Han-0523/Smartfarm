import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:plms_start/dio/login_dio.dart';
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
        backgroundColor: Color(0xFF009688),
        // 카카오 채널 고객센터/문의
        floatingActionButton: FloatingActionButton(
            onPressed: _launchURL,
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/images/kakao_channel.png')),
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              _background(),
              Positioned(
                left: 0,
                right: 0,
                top: Get.height * 4.5 / 8,
                bottom: 10,
                child: Column(
                  children: [
                    _textForm(),
                    SizedBox(height: 10),
                    _textButton(),
                    SizedBox(
                      height: 30,
                    ),
                    _button(),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
            Text(
              'Farm in Earth',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w500),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            // height: Get.height * 1 / 30,
            height: Get.height * 0.07,
            width: Get.width * 4.5 / 7,
            child: TextFormField(
              controller: _idTextEditController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: AppLocalizations.of(context)!.loginID,
                  hintStyle: TextStyle(color: Colors.grey)),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: Get.height * 1 / 30,
          ),
          Container(
            color: Colors.white,
            // height: Get.height * 1 / 30,
            height: Get.height * 0.07,
            width: Get.width * 4.5 / 7,
            child: TextFormField(
              controller: _pwTextEditController,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: AppLocalizations.of(context)!.loginPW,
                  hintStyle: TextStyle(color: Colors.grey)
                  // labelText: AppLocalizations.of(context)!.loginPW,
                  ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  // 로그인 버튼
  Widget _button() {
    return Container(
      height: Get.height * 0.06,
      width: Get.width * 0.65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff304D5B),
        ),
        onPressed: () async {
          var uid = _idTextEditController.text;
          var pw = _pwTextEditController.text;
          _loginTest.loginTest(uid, pw);

          // var url = Uri.parse('$api/api/login');
          // var response = await http.post(url, body: {
          //   'uid': _idTextEditController.text,
          //   'password': _pwTextEditController.text,
          // });

          // Map<String, dynamic> jsonData = jsonDecode(response.body);
          // print(jsonData['results']['uid']);
          // print(jsonData['result']);
          // if (jsonData['results']['uid'] == _idTextEditController.text &&
          //     jsonData['result'] == true) {
          // Get.toNamed('/sensor');
          // } else {
          //   _showDialog();
          // }
        },
        child: Text(
          '로그인',
          // AppLocalizations.of(context)!.signIn,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  // 회원가입 폼
  Widget _signupText() {
    return Column(
      children: [
        Container(
          // width: 1,
          height: 3,
          child: Icon(
            Icons.arrow_drop_down,
            size: 50,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.signUpText,
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

// 회원가입 버튼
  Widget _textButton() {
    return TextButton(
        onPressed: () {
          Get.toNamed("/signup");
        },
        child: Text(
          '비밀번호 변경',
          // AppLocalizations.of(context)!.signUp,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ));
  }

  //카카오 채널 url launcher
  _launchURL() async {
    const url = 'http://pf.kakao.com/_TAxfdb';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

// 로그인 에러 다이얼로그
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(AppLocalizations.of(context)!.loginDialogText),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff71838D),
                  ),
                  child:
                      new Text(AppLocalizations.of(context)!.loginDialogButton),
                  onPressed: () {
                    _idTextEditController.clear();
                    _pwTextEditController.clear();
                    Get.back();
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
