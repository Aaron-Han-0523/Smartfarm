// necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// env
import 'package:flutter_dotenv/flutter_dotenv.dart';
// dio
import 'package:edgeworks/utils/dio/login_dio.dart';
// global
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

/*
* name : LoginPage
* description : login page
* writer : mark
* create date : 2021-12-28
* last update : 2021-02-03
* */

// Api's
LoginTest _loginTest = LoginTest();
late double headerTopZone;
var api = dotenv.env['PHONE_IP'];

// global
String userId = '';
String userPw = '';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TextEditingController
  // 저장된 id/pw 가져오는 로직 -> logout 처리되면 저장된 값 사라짐
  final _idTextEditController = TextEditingController();
  final _pwTextEditController = TextEditingController();

  // 저장된 id 값 가져오기
  Future<dynamic> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    setState(() {
      _idTextEditController.text = userId;
      edgeworks.checkUserId = userId;
    });
    return userId;
  }

  // 저장된 pw 값 가져오기
  Future<dynamic> getUserPw() async {
    final prefs = await SharedPreferences.getInstance();
    userPw = prefs.getString('userPw') ?? '';
    setState(() {
      _pwTextEditController.text = userPw;
    });
    return userPw;
  }

  @override
  void initState() {
    getUserId();
    getUserPw();
    super.initState();
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
        )
    );
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
                controller:
                    _idTextEditController, // 저장된 id값이 없으면 _idcontroller id값이 있으면 저장된 값 불러오기
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
            await _loginTest.loginTest(uid, pw);
            // Get.toNamed('/home');
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
}
