// necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
// dio
import 'package:dio/dio.dart';
// env
import 'package:flutter_dotenv/flutter_dotenv.dart';
// global
import 'package:edgeworks/globals/checkUser.dart' as edgeworks;
import 'package:edgeworks/globals/stream.dart' as stream;

/*
* name : login API & change password
* description : login api
* writer : mark
* create date : 2022-01-03
* last update : 2022-02-03
* */

class LoginTest {
  // env
  var api = dotenv.env['PHONE_IP'];

  // Dio
  Dio dio = new Dio();

  Future<dynamic> loginTest(String uid, String pw) async {
    var params = {
      'uid': uid,
      'password': pw,
    };

    var response = await dio.post('$api/farm/login', data: params);

    Map jsonBody = response.data;
    var jsonData = jsonBody['result'].toString();

    if (response.statusCode == 200) {
      if (jsonData == 'true') {
        edgeworks.saveUserInfo(uid, pw);
        edgeworks.checkUserId = uid;
        Get.toNamed('/home');
        // post fcm token
        postFcmToken(uid, stream.fcmtoken);
        // cookies
        var cookies = response.headers['set-cookie'];
        // var data = cookies![0].split()
        print(cookies![0].split('Path')[0]);
        edgeworks.cookies = cookies[0].split('Path')[0];
      } else if (jsonData == 'false') {
        Get.defaultDialog(
            backgroundColor: Colors.white,
            title: '오류',
            middleText: 'ID/PW를 확인해주세요',
            textCancel: 'Cancel');
      } else {
        Get.defaultDialog(
            backgroundColor: Colors.white,
            title: '오류',
            middleText: 'ID/PW를 입력해주세요',
            textCancel: 'Cancel');
      }
    } else {
      print('[login_dio page] 통신 에러');
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
        edgeworks.checkUserKey = jsonBody['result'].toString();
      }
    }
  }

  // 사용자 id 조회
  Future<dynamic> checkUid(String uid, bool uidStatus) async {
    var getUid = await dio.get('$api/farm/$uid');

    var jsonBody = getUid.data;

    if (jsonBody != null) {
      if (jsonBody[0]["uid"] == uid) {
        return uidStatus = true;
      } else {
        return uidStatus = false;
      }
    }
  }

  // pw 일치 확인
  Future<dynamic> checkPw(String uid, String pw) async {
    var params = {
      'password': pw,
    };

    var response = await dio.post('$api/farm/login/$uid/checkpw', data: params);

    var jsonBody = response.data;

    var jsonData = jsonBody['result'].toString();
    if (jsonData == 'true') {
      edgeworks.checkUserKey = jsonData;
      print('[login_dio page] result는 성공 : ${edgeworks.checkUserKey}');
    } else if ((jsonBody['results'][0]['uid']) != uid) {
      Get.defaultDialog(
          backgroundColor: Colors.white,
          title: '실패',
          middleText: 'ID를 확인해주세요',
          textCancel: 'Cancel');
    } else {
      print('[login_dio page] result는 실패');
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
          textCancel: '확인');
      return false;
    }
  }

  // fcm token sql로 보내기
  Future<dynamic> postFcmToken(String userId, String fcmtoken) async {
    var fcmtoken = stream.fcmtoken;
    var data = {'uid': userId, 'fcmtoken': fcmtoken};
    final postToken = await dio.put('$api/farm/$userId/pushAlarm', data: data);
  }
}
