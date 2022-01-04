import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plms_start/dio/login_dio.dart';
import 'package:plms_start/globals/checkUser.dart' as plms_start;


/*
* name : CheckValidate Page
* description : Validate page
* writer : walter/mark
* create date : 2021-09-30
* last update : 2022-01-04
* */


class CheckValidate {

  LoginTest _loginTest = LoginTest();


  // 이메일 체크
  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      Get.snackbar('error', '아이디를 입력하세요', backgroundColor: Colors.white);
      return '이메일을 입력하세요.';
    } else {
    }
  }

  String? currentPassword(String value, var controller) {
    if (value.isEmpty && value != controller.text) {
      Get.snackbar('error', '비밀번호를 입력하세요', backgroundColor: Colors.white);
      return '비밀번호를 입력하세요';
    } else if (value.isNotEmpty) {
      _loginTest.checkUser(controller.text, value); //비밀번호 입력이 되어 있으면 -> api 연동
    }
  }

  // 새 비밀번호
  String? validatePassword(FocusNode focusNode, String value, var controller) {
    if (value.isEmpty && value != controller.text) {
      focusNode.requestFocus();
      Get.snackbar('error', '비밀번호를 입력하세요', backgroundColor: Colors.white);
      return '비밀번호를 입력하세요';
    }
  }


  // 비밀번호 동일 확인
  String? validaterePassword(
      FocusNode focusNode, String value, var controller) {
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,10}$';
    RegExp regExp = new RegExp(pattern);
      if (value !=controller.text ) {
        Get.snackbar('error', '비밀번호를 확인하세요', backgroundColor: Colors.white);
        return 'Not Match';
      } else if (value == controller.text && value.isNotEmpty) {
        if (!regExp.hasMatch(value)) {
          Get.snackbar('error', '특수문자,영문,숫자 포함 8~10자', backgroundColor: Colors.white);
          return '특수문자,영문,숫자 포함 8~10자 ';
        }
      }
  }
}
