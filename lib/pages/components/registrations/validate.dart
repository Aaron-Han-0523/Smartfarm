import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* name : CheckValidate Page
* description : Validate page
* writer : walter
* create date : 2021-09-30
* last update : 2021-12-29
* */

class CheckValidate {
  // 이메일 체크
  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      Get.snackbar('error', '아이디를 확인하세요', backgroundColor: Colors.white);
      return '이메일을 입력하세요.';
    }
  }

  // 비밀번호 체크 // 수정
  // String? validatePassword(FocusNode focusNode, String value, var controller) {
  //   if (value.isEmpty && value != controller.text) {
  //     focusNode.requestFocus();
  //     return '비밀번호를 입력하세요.';
  //   } else {
  //     String pattern =
  //         r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,10}$';
  //     RegExp regExp = new RegExp(pattern);
  //     if (!regExp.hasMatch(value)) {
  //       focusNode.requestFocus();
  //       return '특수문자,영문,숫자 포함 8~10자 ';
  //     } else {
  //       return null;
  //     }
  //   }
  // }

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
