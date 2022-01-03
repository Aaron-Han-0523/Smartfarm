import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

/*
* name : login API
* description : login api
* writer : mark
* create date : 2022-01-03
* last update : 2022-01-03
* */

class LoginTest {

  var api = dotenv.env['EMUL_IP'];
  Dio dio = new Dio();
  FlutterSecureStorage storage = new FlutterSecureStorage();

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
    } else {
      print('error');
    }
  }

  // Future<dynamic> changePW(String uid, String pw) async {
  //   var params = {
  //     'password': pw,
  //   };
  //
  //   var response = await dio.put(
  //       '$api/farm/$uid/password', data: params);
  //
  //   Map jsonBody = response.data;
  //
  //   if (response.statusCode == 200) {
  //     if (jsonBody['results'] == uid &&
  //         jsonBody['result'] == true) {
  //       Get.toNamed('/sensor');
  //       print('jsonBody는: $jsonBody');
  //     }
  //   } else {
  //     Get.defaultDialog(backgroundColor: Colors.white, title: '오류', middleText: 'ID/PW를 확인해주세요');
  //   }
  // }

}