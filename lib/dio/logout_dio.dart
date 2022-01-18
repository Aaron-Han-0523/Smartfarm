import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import "package:edgeworks/globals/checkUser.dart" as edgeworks;
/*
* name : logout API
* description : logout Api page
* writer : mark
* create date : 2022-01-06
* last update : 2022-01-06
* */

class Logout {
  var api = dotenv.env['PHONE_IP'];
  Dio dio = new Dio();

  Future<dynamic> logout() async {
    var options = Options(
      headers: {
        "Content-Type": "application/json",
        "cookie": edgeworks.cookies
      },
    );
    var response = await dio.post('$api/farm/logout', options: options);

    Map jsonBody = response.data;

    var jsonData = jsonBody['result'].toString();

    if (response.statusCode == 200) {
      if (jsonData == 'true') {
        Get.offAllNamed('/');
        print('jsonBody는: $jsonBody');
        print('로그아웃 성공!!');
      } else if (jsonData == 'false') {
        print('로그인을 하세요!!');
        print('jsondata는 : $jsonData');
      } else {
        print('에러!!');
      }
    } else {
      print('통신 에러');
    }
  }
}
