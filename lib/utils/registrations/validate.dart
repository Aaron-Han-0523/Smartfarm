// ** LOGIN CHECK VALIDATION **

// Necessary to build app
import 'package:flutter/material.dart';


/*
* name : CheckValidate Page
* description : Validate page
* writer : walter/mark
* create date : 2021-09-30
* last update : 2022-02-18
* */

class CheckValidate {
  // 이메일 확인
  String? validateEmail(FocusNode focusNode, String value, var controller) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '아이디를 입력하세요.';
    }
  }

  // 현재 비밀번호 확인
  String? currentPassword(FocusNode focusNode, String value, var controller) {
    if (value.isEmpty && value != controller.text) {
      return '비밀번호를 입력하세요';
    }
  }

  // 새 비밀번호 확인
  String? validatePassword(FocusNode focusNode, String value, var controller) {
    if (value.isEmpty && value != controller.text) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요';
    }
  }

  // 비밀번호 동일 확인
  String? validaterePassword(
      FocusNode focusNode, String value, var controller) {
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,10}$';
    RegExp regExp = new RegExp(pattern);
    if (value != controller.text) {
      return 'Not Match';
    } else if (value == controller.text && value.isNotEmpty) {
      if (!regExp.hasMatch(value)) {
        return '특수문자,영문,숫자 포함 8~10자 ';
      }
    }
  }
}
