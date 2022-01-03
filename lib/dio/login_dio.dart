import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class LoginTest {

  var api = dotenv.env['EMUL_IP'];
  Dio dio = new Dio();

  Future<dynamic> loginTest(String uid, String pw) async {
    var params = {
      'uid': uid,
      'password': pw,
    };

    var response = await dio.post(
        '$api/farm/login', data: params);

    Map jsonBody = response.data;

    if (response.statusCode == 200) {
      if (jsonBody['results']['uid'] == uid &&
          jsonBody['result'] == true) {
        Get.toNamed('/sensor');
        print('jsonBody는: $jsonBody');
      }
    } else {
      print('error');
    }
  }
}