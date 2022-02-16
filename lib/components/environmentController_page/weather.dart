// ** WEATHER WIDGET PAGE **

// Necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// GetX  controller
import 'package:edgeworks/utils/getX_controller/sensorController.dart';

// Global
import '../../globals/stream.dart' as stream;

/*
* name : Weather Page
* description : Weather Widget Page
* writer : mark
* create date : 2021-12-28
* last update : 2022-02-09
* */

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SensorController());
    return Obx(
      () => Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _mainMonitoring(),
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
                        'assets/images/icon_wind.png',
                        "풍향",
                        // "${controller.soilTemp.value}°C",
                        "남동향",
                        'assets/images/icon_windsp.png',
                        "  풍속",
                        // "${controller.soilHumid.value}%"),
                        "12.5m/s"),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  // 현재 상태 모니터링
  Widget _mainMonitoring() {
    final controller = Get.put(SensorController());
    return Container(
        height: Get.height * 0.07,
        width: Get.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            controller.getWeather(stream.exttemp_1),
            // temp == 20 && extHumid=='5'? ImageIcon(AssetImage('assets/images/icon_shiny.png'), color: Color(0xff222222), size: 40): innerHumid=='50'? ImageIcon(AssetImage('assets/images/icon_shiny.png'), color: Color(0xff222222), size: 40):,
            controller.getWeatherStatus(stream.exttemp_1),
            Image.asset('assets/images/icon_env_arrow_up.png',
                color: Color(0xffffd5185), scale: 3),
            Text("07:32",
                style: _textStyle(Color(0xff222222), FontWeight.w600, 16)),
            Image.asset('assets/images/icon_env_arrow_down.png',
                color: Color(0xfff656565), scale: 3),
            Text("18:08",
                style: _textStyle(Color(0xff222222), FontWeight.w600, 16)),
          ],
        ),
        decoration: _decoration(Color(0xffFFFFFF)));
  }

// 내/외부 모니터링
  Widget _subMonitoring(dynamic icon, String mainText, String _mainText,
      dynamic _icon, String subText, String _subText) {
    return Container(
        height: Get.height * 0.09,
        width: Get.width * 0.425,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(icon, color: Color(0xff222222), scale: 5),
                Text(mainText,
                    style:
                        _textStyle(Color(0xff222222), FontWeight.normal, 15)),
                Text(_mainText,
                    style: _textStyle(Color(0xff222222), FontWeight.w600, 15)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(_icon, color: Color(0xff222222), scale: 5),
                Text(subText,
                    style:
                        _textStyle(Color(0xff222222), FontWeight.normal, 15)),
                Text(_subText,
                    style: _textStyle(Color(0xff222222), FontWeight.w600, 15)),
              ],
            ),
          ],
        ),
        decoration: _decoration(Color(0xffFFFFFF)));
  }

  // Text Style Widget
  TextStyle _textStyle(dynamic _color, dynamic _weight, double _size) {
    return TextStyle(color: _color, fontWeight: _weight, fontSize: _size);
  }

  // Decoration (with box shadow) Widget
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
}
