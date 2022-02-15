import 'package:edgeworks/utils/getX_controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../globals/stream.dart' as stream;

/*
* name : Soil Weather Class
* description : Soil Weather Class
* writer : Walter
* create date : 2022-02-15
* last update : 2022-02-15
* */

// 날씨 위젯
class Weather extends StatelessWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounterController());
    return Obx(
      () => Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _mainMonitoring("맑음", "${controller.extTemp.value}", "7860"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Container(
                  height: Get.height * 0.13,
                  width: Get.width * 0.425,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _subMonitoring(
                          'assets/images/icon_temp.png',
                          "내부 온도",
                          "${controller.innerTemp.value}" + "°C",
                          'assets/images/icon_humid.png',
                          "내부 습도",
                          "${controller.innerHumid.value}" + "%"),
                    ],
                  ),
                ),
              ),
              Container(
                height: Get.height * 0.13,
                width: Get.width * 0.425,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _subMonitoring(
                        'assets/images/icon_soiltemp.png',
                        "토양 온도",
                        "${controller.soilTemp.value}°C",
                        'assets/images/icon_soilhumid.png',
                        "토양 습도",
                        "${controller.soilHumid.value}%"),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

// 모니터링
Widget _mainMonitoring(String weather, String temperNumber, String soilNumber) {
  final controller = Get.put(CounterController());
  return Container(
    height: Get.height * 0.07,
    width: Get.width * 0.9,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      controller.getWeather(stream.exttemp_1),
      controller.getWeatherStatus(stream.exttemp_1),
      Text(" 토양 전도도 $soilNumber cm/μs",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff222222))),
    ]),
    decoration: _decoration(Color(0xffFFFFFF)),
  );
}

// 내부/토양 모니터링
Widget _subMonitoring(dynamic icon, String mainText, String _mainText,
    dynamic _icon, String subText, String _subText) {
  return Container(
      height: Get.height * 0.09,
      width: Get.width * 0.425,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          rowWidget(icon, mainText, _mainText),
          rowWidget(_icon, subText, _subText),
        ],
      ),
      decoration: _decoration(Color(0xffFFFFFF)));
}

Widget rowWidget(
  dynamic icons,
  dynamic mainTexts,
  dynamic _mainTexts,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Image.asset(icons, color: Color(0xff222222), scale: 5),
      Text(mainTexts,
          style: _textStyle(Color(0xff222222), FontWeight.normal, 15)),
      Text(_mainTexts,
          style: _textStyle(Color(0xff222222), FontWeight.w600, 15)),
    ],
  );
}

TextStyle _textStyle(dynamic _color, dynamic _weight, double _size) {
  return TextStyle(color: _color, fontWeight: _weight, fontSize: _size);
}

// BoxDecoration (with box shadow)
BoxDecoration _decoration(dynamic color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2,
        offset: Offset(3, 5), // changes position of shadow
      ),
    ],
  );
}
