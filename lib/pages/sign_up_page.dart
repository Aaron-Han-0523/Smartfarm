import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_dropdown_search/flutter_dropdown_search.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:edgeworks/dio/login_dio.dart';
import 'package:edgeworks/pages/components/registrations/validate.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:edgeworks/globals/checkUser.dart' as edgeworks;
import 'dart:convert';

/*
* name : change password
* description : change password
* writer : mark
* create date : 2021-01-03
* last update : 2021-01-12
* */
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // var api = dotenv.env['PHONE_IP'];
  LoginTest _loginTest = LoginTest();
  var api = dotenv.env['PHONE_IP'];
  Dio dio = new Dio();

  @override
  void initState() {
    readFile();
    super.initState();
  }

  String filePath1 = "assets/text/Service_Terms_and_Conditions.txt";
  String filePath2 = "assets/text/Person_Data_Agree.txt";
  String fileText1 = "";
  String fileText2 = "";

  // read agreement txt
  readFile() async {
    String text1 = await rootBundle.loadString(filePath1);
    String text2 = await rootBundle.loadString(filePath2);
    setState(() {
      fileText1 = text1;
      fileText2 = text2;
    });
  }

  // get data

  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isManager = false;

  String dropdownValue = '';
  // var _items = [];
  List<String> deptName = [];
  List<String> department = [];
  List<String> depList = [];
  List<String> authorityList = ['1'];
  // int authoritylen = (authorityList.length - 1);
  List<String> deptList = [];
  int count = 0;
  // TextEditingController _controller = TextEditingController();
  final _idTextEditController = TextEditingController();
  final _pwTextEditController = TextEditingController();
  final _currentPwTextEditController = TextEditingController();
  final _repwTextEditController = TextEditingController();
  final _emailTextEditController = TextEditingController();
  final _comTextEditController = TextEditingController();
  final _nameTextEditController = TextEditingController();
  final _personalTextEditController = TextEditingController();

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  FocusNode _repasswordFocus = new FocusNode();
  FocusNode _currentPwFocus = new FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _idTextEditController.dispose();
    _pwTextEditController.dispose();
    _currentPwTextEditController.dispose();
    _repwTextEditController.dispose();
    _emailTextEditController.dispose();
    _comTextEditController.dispose();
    _nameTextEditController.dispose();
    _personalTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          color: Color(0xff222222),
          onPressed: () {
            Get.toNamed('/');
          },
        ),
        title: Text(
          '비밀번호 변경',
          style: TextStyle(color: Color(0xff4cbb8b)),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: Get.height * 0.07),
          _firstPage(),
        ],
      ),
    );
  }

  Widget _size15() {
    return SizedBox(
      height: 5,
    );
  }

  // first page
  Widget _firstPage() {
    return Form(
      key: formKey,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Column(
            children: [
              _textField('아이디', _idTextEditController),
              _size15(),
              _currentPwField('현재 비밀번호', _currentPwTextEditController),
              _size15(),
              _pwFormField(
                '새 비밀번호',
                _pwTextEditController,
              ),
              _size15(),
              _repwtextField(
                '비밀번호 확인',
                _repwTextEditController,
              ),
            ],
          ),
        ),
        SizedBox(height: Get.height * 0.3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // _cancleButton(),
            _registerButton(),
          ],
        )
      ]),
    );
  }

  // 사용자 이메일 필드
  Widget _textField(String title, var controller) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 1 / 3.9,
          child: Text(title),
        ),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            style: TextStyle(fontSize: 17),
            controller: controller,
            focusNode: _emailFocus,
            keyboardType: TextInputType.visiblePassword,
            decoration: _textDecoration(),
            validator: (value) =>
                CheckValidate().validateEmail(_emailFocus, value!),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  // 현재 비밀번호확인 필드
  Widget _currentPwField(String title, var controller) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 1 / 3.9,
          child: Text(title),
        ),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            style: TextStyle(fontSize: 17),
            controller: controller,
            focusNode: _currentPwFocus,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: _textDecoration(),
            validator: (value) => CheckValidate().currentPassword(
                _currentPwFocus, value!, _idTextEditController),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  // text decoration
  InputDecoration _textDecoration() {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 16, 0, 0),
      border: OutlineInputBorder(),
      helperText: '',
    );
  }

  // check password
  Widget _repwtextField(String title, var controller) {
    return Row(
      children: [
        SizedBox(width: Get.width * 1 / 3.9, child: Text(title)),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            maxLength: 10,
            style: TextStyle(fontSize: 17),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            validator: (_repwTextEditController) => CheckValidate()
                .validaterePassword(_repasswordFocus, _repwTextEditController!,
                    _pwTextEditController),
            controller: controller,
            decoration: _textFormDecoration(),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  // 새 비밀번호
  Widget _pwFormField(String title, var controller) {
    return Row(
      children: [
        SizedBox(width: Get.width * 1 / 3.9, child: Text(title)),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            maxLength: 10,
            style: TextStyle(fontSize: 17),
            keyboardType: TextInputType.visiblePassword,
            focusNode: _passwordFocus,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
            decoration: _textFormDecoration(),
            controller: controller,
            validator: (value) => CheckValidate().validatePassword(
                _passwordFocus, value!, _currentPwTextEditController),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  // 변경 등록 버튼
  Widget _registerButton() {
    return Container(
      height: Get.height * 0.07,
      width: Get.width * 0.8,
      child: new ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff4cbb8b),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)), // background
        ),
        child: new Text(
          '비밀번호 변경',
          style: TextStyle(
              color: Color(0xffFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate() == true) {
            var response = await dio.post(
                '$api/farm/login/${_idTextEditController.text}/checkpw',
                data: {
                  'password': _currentPwTextEditController.text,
                });
            print('비밀번호는 : ${_currentPwTextEditController.text}');
            print('ID는 : ${_idTextEditController.text}');

            Map jsonBody = response.data;
            var jsonData = jsonBody['result'].toString();
            if (jsonData == 'true') {
              print('result는 성공: $jsonData');
              _loginTest
                  .updatePW(
                      _idTextEditController.text, _repwTextEditController.text)
                  .then((value) => formKey.currentState!.save());
              print('result는 성공2: $jsonData');
            } else {
              print('result는 실패');
              Get.defaultDialog(
                  backgroundColor: Colors.white,
                  title: '실패',
                  middleText: '현재 ID/PW를 확인해주세요',
                  textCancel: 'Cancel');
            }
          } else {
            print('새비밀번호 확인');
          }
        },
      ),
    );
  }

  // 취소 버튼
  Widget _cancleButton() {
    return Container(
      // height: Get.height * 0.06,
      width: Get.width * 0.4,
      child: new ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff4cbb8b),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: new Text(
          '취소',
          style: TextStyle(
              color: Color(0xffFFFFFF),
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  // textform decoration
  InputDecoration _textFormDecoration() {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      border: OutlineInputBorder(),
      // helperText: helperText,
    );
  }
}
