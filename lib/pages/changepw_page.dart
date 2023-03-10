// ** CHANGE PASSWORD PAGE **

// Necessary to build app
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Dio
import 'package:dio/dio.dart';
import 'package:edgeworks/utils/dio/loginDio.dart';

// Check login validate page
import 'package:edgeworks/utils/registrations/validate.dart';

/*
* name : change password
* description : change password
* writer : mark
* create date : 2021-01-03
* last update : 2021-02-18
* */

// Api's
var api = dotenv.env['PHONE_IP'];

// Dio
Dio dio = new Dio();

// Get login Data class
LoginTest _loginTest = LoginTest();


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    readFile();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
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

  // TextEditingController
  final _idTextEditController = TextEditingController();
  final _pwTextEditController = TextEditingController();
  final _currentPwTextEditController = TextEditingController();
  final _repwTextEditController = TextEditingController();
  final _emailTextEditController = TextEditingController();
  final _comTextEditController = TextEditingController();
  final _nameTextEditController = TextEditingController();
  final _personalTextEditController = TextEditingController();

  // FocusNode
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
          '???????????? ??????',
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

  // Form
  Widget _firstPage() {
    return Form(
      key: formKey,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              _textField('?????????', _idTextEditController),
              _size15(),
              _currentPwField('?????? ????????????', _currentPwTextEditController),
              _size15(),
              _pwFormField(
                '??? ????????????',
                _pwTextEditController,
              ),
              _size15(),
              _repwtextField(
                '???????????? ??????',
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

  // ????????? ????????? ??????
  Widget _textField(String title, var controller) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 12),
          width: Get.width * 1 / 3.9,
          child: Text(title,
              style: TextStyle(fontSize: 15), textAlign: TextAlign.right),
        ),
        SizedBox(width: Get.width * 0.05),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            style: TextStyle(fontSize: 17),
            controller: controller,
            focusNode: _emailFocus,
            keyboardType: TextInputType.visiblePassword,
            decoration: _textDecoration(),
            validator: (value) => CheckValidate()
                .validateEmail(_emailFocus, value!, _idTextEditController.text),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  // ?????? ?????????????????? ??????
  Widget _currentPwField(String title, var controller) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 12),
          width: Get.width * 1 / 3.9,
          child: Text(title,
              style: TextStyle(fontSize: 15), textAlign: TextAlign.right),
        ),
        SizedBox(width: Get.width * 0.05),
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

  // InputText Decoration widget
  InputDecoration _textDecoration() {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 16, 0, 0),
      border: OutlineInputBorder(),
      helperText: '',
    );
  }

  // ??? ???????????? ??????
  Widget _repwtextField(String title, var controller) {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.only(bottom: 12),
            width: Get.width * 1 / 3.9,
            child: Text(title,
                style: TextStyle(fontSize: 15), textAlign: TextAlign.right)),
        SizedBox(width: Get.width * 0.05),
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

  // ??? ????????????
  Widget _pwFormField(String title, var controller) {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.only(bottom: 12),
            width: Get.width * 1 / 3.9,
            child: Text(title,
                style: TextStyle(fontSize: 15), textAlign: TextAlign.right)),
        SizedBox(width: Get.width * 0.05),
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

  // ?????? ?????? ??????
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
          '???????????? ??????',
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
            print('[changePw page] ????????? ?????? : ${_idTextEditController.text}');

            Map jsonBody = response.data;
            var jsonData = jsonBody['result'].toString();
            if (jsonData == 'true') {
              _loginTest
                  .updatePW(
                      _idTextEditController.text, _repwTextEditController.text)
                  .then((value) => formKey.currentState!.save());
            } else if (jsonData == 'false2') {
              Get.defaultDialog(
                  backgroundColor: Colors.white,
                  title: '??????',
                  middleText: '?????? ID??????????????????',
                  textCancel: '??????');
            } else if (jsonData == 'false1') {
              Get.defaultDialog(
                  backgroundColor: Colors.white,
                  title: '??????',
                  middleText: '?????? ??????????????? ??????????????????',
                  textCancel: '??????');
            }
          } else {
            print('[changePw page] ??????????????? ?????? ??????');
          }
        },
      ),
    );
  }

  // TextForm Decoration Widget
  InputDecoration _textFormDecoration() {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      border: OutlineInputBorder(),
    );
  }
}
