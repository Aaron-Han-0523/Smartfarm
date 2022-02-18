// ** SITE CONFIG BUTTON WIDGET **

// Necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//API
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:edgeworks/utils/mqtt/mqtt.dart';

//GetX
import 'package:edgeworks/utils/getX_controller/settingController.dart';

//global
import '../../globals/stream.dart' as stream;
import "../../globals/checkUser.dart" as edgeworks;

// Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// dio APIs
// var options = BaseOptions(
//   baseUrl: '$url',
//   connectTimeout: 5000,
//   receiveTimeout: 3000,
// );
// Dio dio = Dio(options);
Dio dio = Dio();


// GetX Controller
final controller = Get.put(SettingController());

// Mqtt
ConnectMqtt _connectMqtt = ConnectMqtt();

class SiteConfigSetButton extends StatelessWidget {
  final TextEditingController highTempController;
  final TextEditingController lowTempController;
  const SiteConfigSetButton(
      {Key? key,
      required this.highTempController,
      required this.lowTempController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.07,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: new ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff4cbb8b),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)), // background
        ),
        child: new Text(
          '설정 저장',
          style: TextStyle(
              color: Color(0xffFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        onPressed: () async {
          _updateData(controller.status_alarm.value, highTempController.text,
              lowTempController.text, controller.set_timer.value);
          _connectMqtt
              .setConfig(
                  controller.status_alarm.value,
                  highTempController.text,
                  lowTempController.text,
                  controller.set_timer.value,
                  '/sf/$siteId/req/cfg',
                  '/sf/$siteId/req/cfg')
              .then((value) => Get.defaultDialog(
                  backgroundColor: Colors.white,
                  title: '설정 완료',
                  middleText: '설정이 완료 되었습니다.',
                  textCancel: '확인'));
        },
      ),
    );
  }

  // Update DB function
  Future<void> _updateData(var site_set_alarm_enable, var site_set_alarm_high,
      var site_set_alarm_low, var site_set_alarm_timer) async {
    var params = {
      'site_set_alarm_enable': site_set_alarm_enable,
      'site_set_alarm_high': site_set_alarm_high,
      'site_set_alarm_low': site_set_alarm_low,
      'site_set_alarm_timer': site_set_alarm_timer,
    };
    var response =
        await dio.put('$url/$userId/site/$siteId/settings', data: params);
    print('[setting page] 경보 알림 설정 결과 : $response');
    // 경보 알림 설정이 변경 되었을 경우 : 1
    // 경보 알림 설정 변경이 이미 되어있는 경우 : 0
  }
}
