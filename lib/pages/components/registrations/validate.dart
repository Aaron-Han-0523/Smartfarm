import 'package:flutter/material.dart';

/*
* name : CheckValidate Page
* description : Validate page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class CheckValidate {
  // 이메일 체크
  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus(); //포커스를 해당 textformfield에 맞춘다.
        // return '잘못된 이메일 형식입니다.';
        return '';
      } else {
        return null;
      }
    }
  }

  // 비밀번호 체크
  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else {
      String pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,10}$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '특수문자,영문,숫자 포함 8~10자 ';
      } else {
        return null;
      }
    }
  }

  // 비밀번호 동일 확인
  String? validaterePassword(
      FocusNode focusNode, String value, var controller) {
    if (value != controller.text) return 'Not Match';
  }
}
