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
* last update : 2022-01-05
* */

class LoginTest {
  var api = dotenv.env['PHONE_IP'];
  Dio dio = new Dio();

  Future<dynamic> loginTest(String uid, String pw) async {
    var params = {
      'uid': uid,
      'password': pw,
    };

    var response = await dio.post('$api/farm/login', data: params);

    Map jsonBody = response.data;

    var jsonData = jsonBody['result'].toString();
    // var cookies = response.headers['set-cookie'];
    // // var data = cookies![0].split()
    // print('header!!!!!!!!!!!!!!!!');
    // print(cookies![0].split('Path')[0]);
    // plms_start.cookies = cookies[0].split('Path')[0];

    if (response.statusCode == 200) {
      if (jsonData == 'true') {
        Get.toNamed('/sensor');

        var cookies = response.headers['set-cookie'];
        // var data = cookies![0].split()
        print('header!!!!!!!!!!!!!!!!');
        print(cookies![0].split('Path')[0]);
        plms_start.cookies = cookies[0].split('Path')[0];

        print('jsonBody는: $jsonBody');
        print('password는: ${jsonBody['results']['password']}');
      } else if (jsonData == 'false') {
        print('ID/PW를 확인해주세요');
        Get.defaultDialog(
            backgroundColor: Colors.white,
            title: '오류',
            middleText: 'ID/PW를 확인해주세요',
            textCancel: 'Cancel');
      } else {
        print('ID/PW를 입력해주세요');
        Get.defaultDialog(
            backgroundColor: Colors.white,
            title: '오류',
            middleText: 'ID/PW를 입력해주세요',
            textCancel: 'Cancel');
      }
    } else {
      print('통신 에러');
    }
  }

  // id/pw 조회
  Future<dynamic> checkUser(String uid, String pw) async {
    var params = {
      'uid': uid,
      'password': pw,
    };

    var response = await dio.post('$api/farm/login', data: params);

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

  // pw 일치 확인
  Future<dynamic> checkPw(String uid, String pw) async {
    var params = {
      'password': pw,
    };

    var response = await dio.post('$api/farm/login/$uid/checkpw', data: params);

    var jsonBody = response.data;

    print('응답은 : ${jsonBody['results']['uid']}');

    var jsonData = jsonBody['result'].toString();
    if (jsonData == 'true') {
      plms_start.checkUserKey = jsonData;
      print('result는 성공 : ${plms_start.checkUserKey}');
    } else if ((jsonBody['results'][0]['uid']) != uid) {
      Get.defaultDialog(
          backgroundColor: Colors.white,
          title: '실패',
          middleText: 'ID를 확인해주세요',
          textCancel: 'Cancel');
    } else {
      print('result는 실패');
      Get.defaultDialog(
          backgroundColor: Colors.white,
          title: '실패',
          middleText: 'ID/PW를 확인해주세요',
          textCancel: 'Cancel');
    }
  }

  // 비밀번호 update api 연동
  Future<dynamic> updatePW(String uid, String pw) async {
    var params = {
      'password': pw,
    };

    var response = await dio.put('$api/farm/$uid/password', data: params);

    Map jsonBody = response.data;

    if (jsonBody['result'][0] == 1) {
      Get.defaultDialog(
              backgroundColor: Colors.white,
              title: '성공',
              middleText: '비밀번호가 변경되었습니다.',
              textCancel: 'Cancel')
          .then((value) => Get.back());
      return true;
    } else if (jsonBody['result'][0] == 0) {
      Get.defaultDialog(
          backgroundColor: Colors.white,
          title: '오류',
          middleText: '비밀번호를 확인해주세요',
          textCancel: 'Cancel');
      return false;
    }

    // if (response.statusCode == 200 && plms_start.checkUserKey.isNotEmpty) {
    //   print('new pw는 ${jsonBody['result'][0]==1}');
    //   if (jsonBody['result'][0] == 1) {
    //     Get.defaultDialog(backgroundColor: Colors.white, title: '성공', middleText: '비밀번호가 변경되었습니다.', textCancel: 'Cancel').then((value) => Get.back());
    //     return true;
    //   } else if (jsonBody['result'][0] == 0) {
    //     Get.defaultDialog(backgroundColor: Colors.white, title: '오류', middleText: '비밀번호를 확인해주세요', textCancel: 'Cancel');
    //     return false;
    //   }
    // } else {
    //   print('error');
    // }
  }
}
