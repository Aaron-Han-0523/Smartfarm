// ** GET SITE ID/FCM DATA **

// GetX
import 'package:get/get.dart';

// Dio
import 'package:dio/dio.dart';

// Env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Global
import 'package:edgeworks/globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;


// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// dio APIs
Dio dio = Dio();


class GetSiteFcmData {

  // get site id function
  Future<dynamic> getSiteData(var userId) async {
    // Site Id 전체 가져와서 담기
    final getSiteIds = await dio.get('$url/$userId/sites');
    stream.siteInfo = getSiteIds.data;
    print('[GetSiteFcmData] Site Info는  : ${stream.siteInfo}');

    // Site names 가져오기
    stream.siteNames =
        stream.siteInfo.map((e) => e["site_name"].toString()).toList();
    print('[GetSiteFcmData] Site Ids는 가져오기: ${stream.siteNames}');
  }

  // put fcm token function
  Future<dynamic> putFcmData(var userId) async {
    var fcmtoken = stream.fcmtoken;
    var data = {'uid': userId, 'fcmtoken': fcmtoken};
    final postToken = await dio.put('$api/farm/$userId/pushAlarm', data: data);
    print('[GetSiteFcmData] postToken: $postToken');
    await Get.offAllNamed('/sensor');
    // Get.offAllNamed('/sensor');
  }


}
