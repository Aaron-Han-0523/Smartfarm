// ** CCTV CONTROLLER PAGE **

// necessary to build app
import 'package:get/get.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// dio
import 'package:dio/dio.dart';

// global
import 'package:edgeworks/globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;


/*
* name : CCTV Controller Page
* description : CCTV Controller Page (Get CCTV Data from DB)
* writer : mark
* create date : 2021-12-28
* last update : 2022-02-16
* */


// mqtt
int clientPort = 1883;
var setTopic = '/sf/$siteId/data';

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// Dio
var dio = Dio();

class CctvController extends GetxController {

  // Define Cctv Variable
  var cctvs = [].obs;
  var cctvUrls = [].obs;
  var cctvUrlVariable = ''.obs;

   Future<dynamic> getCctvData() async {
    // cctvs
    final getCctvs = await dio.get('$url/$userId/site/$siteId/cctvs');
    cctvs.value = getCctvs.data;
    print('[cctvPage] GET CCTV List from stream: $cctvs');
    print('[cctvPage] GET CCTV List length: ${cctvs.length}');

    for (var i = 0; i < cctvs.length; i++) {
      cctvUrlVariable.value = cctvs[i]['cctv_url'];
      cctvUrls.add(cctvUrlVariable);
    }
    print('[cctvPage] GET CCTV Url 개수: ${cctvUrls.length}');
    print('[cctvPage] GET CCTV Url List: $cctvUrls');
    update();
   }
}