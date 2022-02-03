// necessary to build app
import 'package:get/get_navigation/src/extension_navigation.dart';
// dio
import 'package:dio/dio.dart';
// env
import 'package:flutter_dotenv/flutter_dotenv.dart';
// getX
import 'package:get/get_core/src/get_main.dart';
//global
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

/*
* name : logout API
* description : logout Api page
* writer : mark
* create date : 2022-01-06
* last update : 2022-02-03
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
        edgeworks.deleteUserInfo();
        Get.offAllNamed('/');
        print('[logout_dio page] 로그아웃 성공');
      } else if (jsonData == 'false') {
        print('[logout_dio page] 로그인 필요');
      } else {
      }
    } else {
    }
  }
}
