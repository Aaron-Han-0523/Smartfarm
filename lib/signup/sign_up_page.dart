import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_dropdown_search/flutter_dropdown_search.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plms_start/dio/login_dio.dart';
import 'package:plms_start/ontap_draft/confirm_page_ontap.dart';
import 'package:plms_start/pages/components/registrations/validate.dart';

import 'package:dropdown_search/dropdown_search.dart';

import '../pages/utils/header_issue.dart';
import 'package:plms_start/globals/checkUser.dart' as plms_start;
import 'dart:convert';

/*
* name : change password
* description : change password
* writer : mark
* create date : 2021-01-03
* last update : 2021-01-05
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
        backgroundColor: Color(0xff2B3745),
        automaticallyImplyLeading: false,
        title: Header(
          title: AppLocalizations.of(context)!.signUpHeader,
        ),
      ),
      body: ListView(
        children: [
          _firstPage(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFE6E6E6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 2.2 / 7,
              child: new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff71838D),
                ),
                child:
                    new Text(AppLocalizations.of(context)!.signUpbottomButton1),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            // registration 버튼
            Container(
              width: Get.width * 2.2 / 7,
              child: new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff2F4C5A), // background
                  // onPrimary: Colors.white, // foreground
                ),
                child:
                    new Text(AppLocalizations.of(context)!.signUpbottomButton2),
                onPressed: () async {
                  if (formKey.currentState!.validate() == true) {
                    var response = await dio.post(
                        '$api/farm/login/${_idTextEditController.text}/checkpw', data: {
                        'password': _currentPwTextEditController.text,
                    });
                    print('비밀번호는 : ${_currentPwTextEditController.text}');
                    print('ID는 : ${_idTextEditController.text}');

                    Map jsonBody = response.data;
                    var jsonData = jsonBody['result'].toString();
                    if (jsonData == 'true' ) {
                      print('result는 성공: $jsonData');
                      _loginTest.updatePW(_idTextEditController.text, _repwTextEditController.text)
                          .then((value) => formKey.currentState!.save());
                      print('result는 성공2: $jsonData');

                    } else {
                      print('result는 실패');
                      Get.defaultDialog(backgroundColor: Colors.white, title: '실패', middleText: 'ID/PW를 확인해주세요', textCancel: 'Cancel');
                    }
                  }else{
                    print('새비밀번호 확인');
                  }
                },
              ),
            ),
          ],
        ),
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
    var radius = Radius.circular(10);
    return Form(
      key: formKey,
      child: Container(
        // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                height: MediaQuery.of(context).size.height * 7.5 / 9,
                width: Get.width * 1 / 50,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 7.5 / 9,
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
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.3)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          children: [
                            _textField(
                                '아이디',
                                // AppLocalizations.of(context)!.signUpID,
                                _idTextEditController),
                            _size15(),
                            _currentPwField(
                                '현재 비밀번호', _currentPwTextEditController),
                            _size15(),
                            _pwFormField(
                              '새 비밀번호',
                              _pwTextEditController,
                            ),
                            _size15(),
                            _repwtextField(
                              '비밀번호 확인',
                              // AppLocalizations.of(context)!.signUprepw,
                              _repwTextEditController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // dropdown button

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
              validator: (value)
              => CheckValidate().currentPassword(_currentPwFocus, value!, _idTextEditController),
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
            validator: (_repwTextEditController) => CheckValidate().validaterePassword(
                _repasswordFocus, _repwTextEditController!, _pwTextEditController),
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
                _passwordFocus,
                value!,
                _currentPwTextEditController),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
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

// radio button

// agreement page one
}
