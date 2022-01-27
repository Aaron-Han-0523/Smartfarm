import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edgeworks/dio/login_dio.dart';
import 'package:edgeworks/globals/checkUser.dart' as edgeworks;

/*
* name : CheckValidate Page
* description : Validate page
* writer : walter/mark
* create date : 2021-09-30
* last update : 2022-01-05
* */

class CheckValidate {
  LoginTest _loginTest = LoginTest();

  // 이메일 체크
  String? validateEmail(FocusNode focusNode, String value, var controller) {
    bool uidStatus = false;

    if (value.isEmpty) {
      focusNode.requestFocus();
      return '아이디를 입력하세요.';
    } else if(value.isNotEmpty) {
      _loginTest.checkUid(controller, uidStatus);
      if (uidStatus == false) {
        return '아이디를 확인해주세요';
      }
    }
  }

  String? currentPassword(FocusNode focusNode, String value, var controller) {
    if (value.isEmpty && value != controller.text) {
      return '비밀번호를 입력하세요';
    }
  }

  // 새 비밀번호
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
