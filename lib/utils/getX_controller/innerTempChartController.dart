// ** INNER TEMP CHART DATA CONTROLLER **

// GetX
import 'package:get/get.dart';

// Dio
import 'package:dio/dio.dart';

// Env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import chart class
import 'package:edgeworks/models/sensor_page/innerTempData.dart';

// Global
import 'package:edgeworks/globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;


// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// Dio
Dio dio = Dio();


class InnerTempChartController extends GetxController {

  final List<InnerTempData> chartData = <InnerTempData>[].obs;
  List getChartData = [];

  // get trends temp data function
  Future<dynamic> getTrendsTempData() async {
    await Future.delayed(const Duration(milliseconds: 500), () async {
      final getInnerTemp =
      await dio.get('$url/$userId/site/$siteId/innerTemps');
      getChartData = getInnerTemp.data['data'];

      if (getChartData.length != 0) {
        print('[innerTempController] getInnerTemp: ${getInnerTemp.data['data']}');
        print(
            '[innerTempController] getInnerTemp 최근 내부온도 시간: '
                '${getInnerTemp.data['data'][0]['time_stamp']}'); //2022-01-27T09:19:59Z

        print(
            '[innerTempController] getInnerTemp 최근 내부온도 온도: '
                '${getInnerTemp.data['data'][0]['value']}');

        int innerTempLength = getInnerTemp.data['data'].length;
        print('[innerTempController] innerTempLength: $innerTempLength'); //120

        for (var i = 0; i < getChartData.length; i++) {
          var date = getChartData[i]['time_stamp'];
          print('시간 모음 : $date');
          print('value 모음 : ${getChartData[i]['value']}');
          var timeStamp = date.toString().substring(11,16); // 시:분
          chartData.add(InnerTempData(timeStamp,
              double.parse(getChartData[i]['value'])));
        }
      }
    });
  }

}
