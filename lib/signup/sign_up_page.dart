import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_dropdown_search/flutter_dropdown_search.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plms_start/pages/components/registrations/validate.dart';

import 'package:dropdown_search/dropdown_search.dart';

import '../pages/utils/header_issue.dart';

import 'dart:convert';

/*
* name : SignUpPage
* description : join page
* writer : john
* create date : 2021-09-30
* last update : 2021-09-30
* */
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var api = dotenv.env['PHONE_IP'];
  // var api = dotenv.env['EMUL_IP'];

  @override
  void initState() {
    test();
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
  Future<dynamic> test() async {
    var uriResponse = await http.get(
      Uri.parse(
        '$api/summury/department/',
      ),
    );

    var json = jsonDecode(uriResponse.body);
    // print(json.runtimeType);
    print(json[0]['department']);
    depList.add(json[0]['department']);
    // _items += json;
    int len = json.length;
    // dispose();
    if (mounted)
      this.setState(() {
        for (int i = 0; i < len; i++) {
          deptName += [json[i]['deptName']];
          department += [json[i]['department']];
        }
      });
  }

  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isManager = false;

  String _horizonGroupValue = "Assignee";

  List<String> _status = ["Assignee", "QC", "Manager"];
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
  final _repwTextEditController = TextEditingController();
  final _emailTextEditController = TextEditingController();
  final _comTextEditController = TextEditingController();
  final _nameTextEditController = TextEditingController();
  final _personalTextEditController = TextEditingController();

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  FocusNode _repasswordFocus = new FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _idTextEditController.dispose();
    _pwTextEditController.dispose();
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
          _checkPage1(
            AppLocalizations.of(context)!.signUpcheckPage1,
            fileText1,
          ),
          _checkPage2(
            AppLocalizations.of(context)!.signUpcheckPage2,
            fileText2,
          ),
          _checkPage3(),
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
                  if ((isSwitched & isSwitched2 == true)) {
                    formKey.currentState!.validate();
                    print(AppLocalizations.of(context)!.signUpbottomButton2);
                  } else {
                    return Get.defaultDialog(
                      textCancel: "cancel",
                      cancelTextColor: Colors.black,
                      title: 'Error',
                      titleStyle: TextStyle(color: Colors.red),
                      middleText: 'Check I agree',
                      buttonColor: Colors.white,
                    );
                  }

                  if (((formKey.currentState!.validate() == true))) {
                    // print(formKey.currentState!.validate());
                    // var url = Uri.parse('http://10.0.2.2:5000/api/register');
                    var url = Uri.parse('$api/api/register');
                    // if (jsonData['result'] == false) {
                    //   // _showDialog();
                    //   // }
                    // }

                    if (isManager == true) {
                      var response = await http.post(url, body: {
                        'userID': _idTextEditController.text,
                        'password': _pwTextEditController.text,
                        'userName': _nameTextEditController.text,
                        'email': _emailTextEditController.text,
                        'company': _comTextEditController.text,
                        'authority': authorityList[authorityList.length - 1],
                        'personalID': _personalTextEditController.text,
                        'department': depList[depList.length - 1],
                        'active': '1',
                      });
                      print(response.body);
                      Map<String, dynamic> jsonData = jsonDecode(response.body);
                      if (jsonData['result'] == false) {
                        Get.defaultDialog(
                          textCancel: "cancel",
                          cancelTextColor: Colors.black,
                          title: 'Error',
                          titleStyle: TextStyle(color: Colors.red),
                          middleText: "Can't use your User ID",
                          buttonColor: Colors.white,
                        );
                      } else if (jsonData['result'] == false) {
                        Get.defaultDialog(
                          textCancel: "cancel",
                          cancelTextColor: Colors.black,
                          title: 'Error',
                          titleStyle: TextStyle(color: Colors.red),
                          middleText: "Check your User Register",
                          buttonColor: Colors.white,
                        );
                      } else {
                        Get.back();
                      }
                    } else if (isManager == false) {
                      var response = await http.post(url, body: {
                        'userID': _idTextEditController.text,
                        'password': _pwTextEditController.text,
                        'userName': _nameTextEditController.text,
                        'email': _emailTextEditController.text,
                        'company': _comTextEditController.text,
                        'authority': authorityList[authorityList.length - 1],
                        // 'personalID': _personalTextEditController.text,
                        // 'department': depList[depList.length - 1],
                        'active': '1',
                      });
                      Map<String, dynamic> jsonData = jsonDecode(response.body);
                      if (jsonData['result'] == false) {
                        Get.defaultDialog(
                          textCancel: "cancel",
                          cancelTextColor: Colors.black,
                          title: 'Error',
                          titleStyle: TextStyle(color: Colors.red),
                          middleText: "Can't use your User ID",
                          buttonColor: Colors.white,
                        );
                      } else {
                        Get.back();
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
                            _textField(AppLocalizations.of(context)!.signUpID,
                                _idTextEditController, 'ID를'),
                            _size15(),
                            _pwFormField(
                              AppLocalizations.of(context)!.signUpPW,
                              _pwTextEditController,
                            ),
                            _size15(),
                            _repwtextField(
                              AppLocalizations.of(context)!.signUprepw,
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
                                _personalTextEditController,
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

  // dropdown button
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

            mode: Mode.BOTTOM_SHEET,
            items: deptName,
            showSelectedItem: true,
            selectedItem: isManager == false ? '' : deptName[0],
            // hint: AppLocalizations.of(context)!.signUpdeptselect,
            onChanged: (valued) {
              setState(() {
                for (var i = 0; i < deptName.length; i++) {
                  if (valued == deptName[i]) {
                    depList.add(department[i]);
                  }
                }
              });
            },
          ),
        ),
      ],
    );
  }

  // text field
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
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  // text field use enables
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
            validator: (value) {
              if (value!.isEmpty) {
                return '$text 입력하세요';
              }
            },
            enabled: isManager,
            style: TextStyle(fontSize: 17),
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

  // text decoration
  InputDecoration _textDecoration() {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 16, 0, 0),
      border: OutlineInputBorder(),
      helperText: '',
      // helperText: helperText,
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
            validator: (value) => CheckValidate().validaterePassword(
                _repasswordFocus, value!, _pwTextEditController),
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

  // password
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

  // email
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

  // textform decoration
  InputDecoration _textFormDecoration() {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      border: OutlineInputBorder(),

      // helperText: helperText,
    );
  }

  // radio button
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
          _personalTextEditController.clear();
          deptList = List.empty();
          print("Manager: $isManager");
        }
        if (value == _status[1]) {
          authorityList.add('4');
          isManager = false;
          _personalTextEditController.clear();
          deptList = List.empty();

          print("Manager: $isManager");
        }
        if (value == _status[2]) {
          authorityList.add('3');
          isManager = true;
          print("Manager: $isManager");
          // print(isSwitched);
        }

        // print(authorityList);
      }),
      items: _status,
      itemBuilder: (item) => RadioButtonBuilder(
        item,
        textPosition: RadioButtonTextPosition.left,
      ),
    );
  }

  // agreement page one
  Widget _checkPage1(String title, String data) {
    // bool isSwitched1 = false;
    var radius = Radius.circular(10);
    return Container(
      // height: MediaQuery.of(context).size.height,
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
              height: MediaQuery.of(context).size.height * 3.9 / 9,
              width: Get.width * 1 / 50,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 3.9 / 9,
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
                    Column(
                      children: [
                        Text(title),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Color(0xffeeeeee),
                          height: 200,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(data),
                              )
                            ],
                          ),
                        ),
                        _swichs()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // agreement page two
  Widget _checkPage2(String title, String data) {
    // bool isSwitched1 = false;
    var radius = Radius.circular(10);
    return Container(
      // height: MediaQuery.of(context).size.height,
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
              height: MediaQuery.of(context).size.height * 3.9 / 9,
              width: Get.width * 1 / 50,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 3.9 / 9,
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
                    Column(
                      children: [
                        Text(title),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Color(0xffeeeeee),
                          height: 200,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(data),
                              )
                            ],
                          ),
                        ),
                        _swichs2()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // all agreement check button
  Widget _checkPage3() {
    // bool isSwitched1 = false;
    var radius = Radius.circular(10);
    return Container(
      // height: MediaQuery.of(context).size.height,
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
              height: MediaQuery.of(context).size.height * 1 / 10.5,
              width: Get.width * 1 / 50,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 1 / 10.5,
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
                    Column(
                      children: [
                        // Text(title),
                        // Container(
                        //   color: Color(0xffeeeeee),
                        //   height: 200,
                        //   child: ListView(
                        //     children: [Text(data)],
                        //   ),
                        // ),
                        _swichs3()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // switch button one
  Widget _swichs() {
    return Row(
      children: [
        Checkbox(
          value: isSwitched,
          onChanged: (value) {
            if (value == false) {
              isSwitched3 = false;
            }

            setState(() {
              isSwitched = value!;
              // print(isSwitched);
            });
          },
          // activeTrackColor: Colors.yellow,
          activeColor: Colors.black,
        ),
        SizedBox(
          width: 90,
          child: Text(AppLocalizations.of(context)!.signUpcheckbox),
        ),
      ],
    );
  }

  // switch button two
  Widget _swichs2() {
    return Row(
      children: [
        Checkbox(
          value: isSwitched2,
          onChanged: (value) {
            if (value == false) {
              isSwitched3 = false;
            }

            setState(() {
              isSwitched2 = value!;
              // print(isSwitched2);
            });
          },
          // activeTrackColor: Colors.yellow,
          activeColor: Colors.black,
        ),
        SizedBox(
          width: 90,
          child: Text(AppLocalizations.of(context)!.signUpcheckbox),
        ),
      ],
    );
  }

  // switch button three
  Widget _swichs3() {
    return Row(
      children: [
        Checkbox(
          value: isSwitched3,
          onChanged: (value) {
            if (value == true) {
              isSwitched = true;
              isSwitched2 = true;
            } else {
              isSwitched = false;
              isSwitched2 = false;
            }

            setState(() {
              isSwitched3 = value!;
              // print(isSwitched2);
            });
          },
          // activeTrackColor: Colors.yellow,
          activeColor: Colors.black,
        ),
        SizedBox(
          width: 150,
          child: Text(AppLocalizations.of(context)!.signUpAllcheckbox),
        ),
      ],
    );
  }
}
