import 'dart:convert';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plms_start/globals/checkUser.dart' as plms_start;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

/*
* name : login API & change password
* description : login api
* writer : mark
* create date : 2022-01-03
* last update : 2022-01-03
* */

class LoginTest {

  var api = dotenv.env['PHONE_IP'];
  Dio dio = new Dio();
  // FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<dynamic> loginTest(String uid, String pw) async {
    var params = {
      'uid': uid,
      'password': pw,
    };

    var response = await dio.post(
        '$api/farm/login', data: params);

    Map jsonBody = response.data;

    if (response.statusCode == 200) {
      if (jsonBody['result'] == true) {
        Get.toNamed('/sensor');
        print('jsonBody는: $jsonBody');
        print('password는: ${jsonBody['results']['password']}');
      } else {
        Get.defaultDialog(backgroundColor: Colors.white, title: '오류', middleText: 'ID/PW를 확인해주세요', textCancel: 'Cancel');
      }
    }
  }

  // id/pw 조회
  Future<dynamic> checkUser(String uid, String pw) async {

    var params = {
      'uid': uid,
      'password': pw,
    };

    var response = await dio.post(
        '$api/farm/login', data: params);

    Map jsonBody = response.data;

    if (response.statusCode == 200) {

      if (jsonBody['result'] == true) {
        print('jsonBody는: $jsonBody');
        plms_start.checkUserKey = jsonBody['result'].toString();
        // _checkValidate.validatePassword;
        // return true;

      }
      // else if (jsonBody['result'] == false) {
      //   Get.defaultDialog(backgroundColor: Colors.white, title: '오류', middleText: '비밀번호를 다시 입력하세요', textCancel: 'Cancel');
      //   return false;
      // }
    }
  }


  // 비밀번호 update api 연동
  Future<dynamic> updatePW(String uid, String pw) async {
    var params = {
      'password': pw,
    };

    var response = await dio.put(
        '$api/farm/$uid/password', data: params);

    Map jsonBody = response.data;

    if (response.statusCode == 200) {
      print('new pw는 ${jsonBody['result'][0]==1}');
      if (jsonBody['result'][0] == 1) {
        Get.defaultDialog(backgroundColor: Colors.white, title: '성공', middleText: '비밀번호가 변경되었습니다.', textCancel: 'Cancel').then((value) => Get.back());
        return true;
      } else if (jsonBody['result'][0] == 0) {
        Get.defaultDialog(backgroundColor: Colors.white, title: '오류', middleText: 'ID/PW를 확인해주세요', textCancel: 'Cancel');
        return false;
      }
    } else {
      print('error');
    }
  }


}