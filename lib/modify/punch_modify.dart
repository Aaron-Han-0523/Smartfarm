import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:plms_start/pages/components/registrations/validate.dart';

import 'package:http/http.dart' as http;
import '../globals/login.dart' as login;
import '../globals/issue.dart' as issue;
/*
* name : ModifyPage
* description : modify page
* writer : walter
* create date : 2021-09-30
* last update : 2021-10-20
* */

class ModifyPage extends StatefulWidget {
  const ModifyPage({Key? key}) : super(key: key);

  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  final _idTextEditController = TextEditingController(text: login.userID[0]);
  final _pwTextEditController = TextEditingController();
  final _newpwTextEditController = TextEditingController();
  final _repwTextEditController = TextEditingController();
  final _emailTextEditController = TextEditingController(text: login.email[0]);
  final _comTextEditController = TextEditingController(text: login.company[0]);
  final _nameTextEditController =
      TextEditingController(text: login.userName[0]);
  final _personTextEditController =
      TextEditingController(text: login.personalID[0]);

  var api = dotenv.env['PHONE_IP'];

  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isManager = login.authority[0] == '3' ? true : false;

  String _horizonGroupValue = login.authority[0] == '3'
      ? 'Manager'
      : login.authority[0] == '4'
          ? 'QC'
          : 'Assignee';

  List<String> _status = ["Assignee", "QC", "Manager"];
  String dropdownValue = '';

  List<String> deptName = issue.deptNameList;
  List<String> department = issue.deptList;
  List<String> depList = [];
  List<String> authorityList = [];
  List<String> deptList = [];

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  FocusNode _newpasswordFocus = new FocusNode();

  String pwData = login.password[0];

  final formKey = GlobalKey<FormState>();

  FocusNode _pwFocusNode = FocusNode();

  @override
  void initState() {
    authorityList.add(login.authority[0]);

    for (int i = 0; i < deptName.length; i++) {
      if (login.department[0] == department[i]) {
        deptList.add(deptName[i]);
        depList.add(department[i]);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  if (((formKey.currentState!.validate() == true))) {
                    var url = Uri.parse('$api/summury/update');
                    if (isManager == true) {
                      var response = await http.post(url, body: {
                        'userID': _idTextEditController.text,
                        'password': _newpwTextEditController.text,
                        'userName': _nameTextEditController.text,
                        'email': _emailTextEditController.text,
                        'company': _comTextEditController.text,
                        'authority': authorityList[authorityList.length - 1],
                        'personalID': _personTextEditController.text,
                        'department': depList[depList.length - 1],
                      });
                      print(response.body);
                      Get.offAllNamed('/');
                    } else if (isManager == false) {
                      var response = await http.post(url, body: {
                        'userID': _idTextEditController.text,
                        'password': _newpwTextEditController.text,
                        'userName': _nameTextEditController.text,
                        'email': _emailTextEditController.text,
                        'company': _comTextEditController.text,
                        'authority': authorityList[authorityList.length - 1],
                      });
                      Get.offAllNamed('/');
                    } else {
                      Get.defaultDialog(
                        textCancel: "cancel",
                        cancelTextColor: Colors.black,
                        title: 'Error',
                        titleStyle: TextStyle(color: Colors.red),
                        middleText: 'Check your User Register',
                        buttonColor: Colors.white,
                      );
                    }
                  } else {
                    Get.defaultDialog(
                      textCancel: "cancel",
                      cancelTextColor: Colors.black,
                      title: 'Error',
                      titleStyle: TextStyle(color: Colors.red),
                      middleText: 'Check your User Register',
                      buttonColor: Colors.white,
                    );
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
                height: MediaQuery.of(context).size.height * 8 / 9,
                width: Get.width * 1 / 50,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 8 / 9,
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
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    children: [
                      _radioButton(),
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
                            _enabletextFieldText(
                                AppLocalizations.of(context)!.signUpID,
                                _idTextEditController,
                                'ID를'),
                            _size15(),
                            _pwFormField(
                              AppLocalizations.of(context)!.signUpPW,
                              _pwTextEditController,
                            ),
                            _size15(),
                            _newpwFormField(
                              'New Password',
                              _newpwTextEditController,
                            ),
                            _size15(),
                            _repwtextField(
                              "New ${AppLocalizations.of(context)!.signUprepw}",
                              _repwTextEditController,
                            ),
                            _size15(),
                            _emailFormField(
                              AppLocalizations.of(context)!.signUpmail,
                              _emailTextEditController,
                            ),
                            _size15(),
                            _textField(AppLocalizations.of(context)!.signUpcom,
                                _comTextEditController, '회사를'),
                            _size15(),
                            _textField(AppLocalizations.of(context)!.signUpname,
                                _nameTextEditController, '이름을'),
                            _size15(),
                            _enabletextField(
                                AppLocalizations.of(context)!.signUppersonal,
                                _personTextEditController,
                                '개인ID를'),
                            _size15(),
                            _dropdownButton(),
                            _size15(),
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

// 라디오 선택 버튼
  Widget _radioButton() {
    return RadioGroup<String>.builder(
      activeColor: Colors.black,
      direction: Axis.horizontal,
      groupValue: _horizonGroupValue,
      onChanged: (value) => setState(() {
        _horizonGroupValue = value!;
        if (value == _status[0]) {
          authorityList.add('1');
          isManager = false;
          _personTextEditController.clear();
          deptList = List.empty();
          print("Manager: $isManager");
        }
        if (value == _status[1]) {
          authorityList.add('4');
          isManager = false;
          _personTextEditController.clear();
          deptList = List.empty();

          print("Manager: $isManager");
        }
        if (value == _status[2]) {
          authorityList.add('3');
          isManager = true;
          print("Manager: $isManager");
        }
      }),
      items: _status,
      itemBuilder: (item) => RadioButtonBuilder(
        item,
        textPosition: RadioButtonTextPosition.left,
      ),
    );
  }

// 부서 드롭 다운 버튼
  Widget _dropdownButton() {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 1 / 3.9,
          child: Text(
            AppLocalizations.of(context)!.signUpdept,
            style: TextStyle(
              color: isManager == true ? Colors.black : Colors.grey,
            ),
          ),
        ),
        Container(
          width: Get.width * 2.8 / 5,
          height: Get.height * 1.3 / 25,
          child: DropdownSearch<String>(
            // maxHeight: 100,

            dropdownSearchDecoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: OutlineInputBorder(),
              // isCollapsed: true,
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            enabled: isManager,
            dropDownButton: Icon(null),
            dropdownSearchBaseStyle: TextStyle(fontSize: 17),
            selectedItem: isManager == false
                ? ''
                : deptList.length == 0
                    ? ''
                    : deptList[0],
            mode: Mode.MENU,
            items: deptName,
            showSelectedItem: true,

            // hint: AppLocalizations.of(context)!.signUpdeptselect,
            onChanged: (valued) {
              setState(() {
                for (var i = 0; i < deptName.length; i++) {
                  if (valued == deptName[i]) {
                    depList.add(department[i]);
                  }
                }
                print(depList);
              });
            },
          ),
        ),
      ],
    );
  }

// 회사, 이름 텍스트 폼
  Widget _textField(String title, var controller, String text) {
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
            decoration: _textDecoration(),
            validator: (value) {
              if (value!.isEmpty) {
                return '$text 입력하세요';
              }
            },
            onChanged: (text) {
              print(_nameTextEditController.text);
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

// true false 개인 ID 선택 텍스트폼
  Widget _enabletextField(String title, var controller, String text) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 1 / 3.9,
          child: Text(
            title,
            style: TextStyle(
              color: isManager == true ? Colors.black : Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            enabled: isManager,
            style: TextStyle(fontSize: 17),
            controller: controller,
            decoration: _textDecoration(),
            validator: (value) {
              if (value!.isEmpty) {
                return '$text 입력하세요';
              }
            },
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

// user ID 텍스트 필드
  Widget _enabletextFieldText(String title, var controller, String text) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 1 / 3.9,
          child: Text(
            title,
            style: TextStyle(
              color: isManager == true ? Colors.black : Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            enabled: false,
            style: TextStyle(fontSize: 17),
            controller: controller,
            decoration: _textDecoration(),
            validator: (value) {
              if (value!.isEmpty) {
                return '$text 입력하세요';
              }
            },
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

// 텍스트 데코레이션
  InputDecoration _textDecoration() {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 16, 0, 0),
      border: OutlineInputBorder(),
      helperText: '',
      // helperText: helperText,
    );
  }

// 비밀번호 확인 텍스트폼
  Widget _repwtextField(String title, var controller) {
    return Row(
      children: [
        SizedBox(width: Get.width * 1 / 3.9, child: Text(title)),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 1.95 / 25,
          child: TextFormField(
            maxLength: 10,
            style: TextStyle(fontSize: 17),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            validator: (value) => CheckValidate().validaterePassword(
                _passwordFocus, value!, _newpwTextEditController),
            controller: controller,
            decoration: _textDecoration(),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

// 기존 비말번호 텍스트 폼
  Widget _pwFormField(String title, var controller) {
    return Row(
      children: [
        SizedBox(width: Get.width * 1 / 3.9, child: Text(title)),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 1.95 / 25,
          child: TextFormField(
            maxLength: 10,
            style: TextStyle(fontSize: 17),
            keyboardType: TextInputType.visiblePassword,
            focusNode: _pwFocusNode,
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return '';
              }
              if (value != pwData) {
                return '비밀번호를 다시 입력하세요';
              }
            },
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

// 새로운 비밀번호 작성 텍스트 폼
  Widget _newpwFormField(String title, var controller) {
    return Row(
      children: [
        SizedBox(width: Get.width * 1 / 3.9, child: Text(title)),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 1.95 / 25,
          child: TextFormField(
            maxLength: 10,
            style: TextStyle(fontSize: 17),
            keyboardType: TextInputType.visiblePassword,
            focusNode: _newpasswordFocus,
            obscureText: true,
            validator: (value) =>
                CheckValidate().validatePassword(_passwordFocus, value!),
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

// 이메일 텍스트 폼
  Widget _emailFormField(String title, var controller) {
    return Row(
      children: [
        SizedBox(width: Get.width * 1 / 3.9, child: Text(title)),
        Container(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            style: TextStyle(fontSize: 17),
            validator: (value) =>
                CheckValidate().validateEmail(_emailFocus, value!),
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            focusNode: _emailFocus,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: OutlineInputBorder(),
              helperText: '이메일을 입력하세요',
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

// 텍스트 데코레이션
  InputDecoration _textFormDecoration() {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      border: OutlineInputBorder(),

      // helperText: helperText,
    );
  }
}
