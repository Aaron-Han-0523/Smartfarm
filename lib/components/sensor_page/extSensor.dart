import 'package:edgeworks/components/sensor_page/card.dart';
import 'package:edgeworks/utils/getX_controller/sensorController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final controller = Get.put(SensorController());

class ExtSensor extends StatelessWidget {
  const ExtSensor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: <Widget>[
          _fromLTRBPadding(
            child: Container(
              decoration: _decorations(),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  title: Row(
                    children: [
                      _leftRightPadding(
                        child: Image.asset(
                          'assets/images/icon_exevn.png',
                          scale: 3,
                        ),
                      ),
                      Text(
                        '외부 환경',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    SizedBox(height: Get.height * 0.01),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Cards(
                              title: '외부 온도',
                              subtitle: controller.extTemp.value,
                              visibles: true,
                              assets: 'assets/images/icon_temp.png'),
                          Cards(
                              title: '외부 습도',
                              subtitle: controller.extHumid.value,
                              visibles: true,
                              assets: 'assets/images/icon_humid.png')
                        ]),
                    SizedBox(height: Get.height * 0.01),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Cards(
                              title: '강우',
                              subtitle: '12.5',
                              visibles: true,
                              assets: 'assets/images/icon_rainy.png'),
                          Cards(
                              title: '풍향',
                              subtitle: '12.5',
                              visibles: true,
                              assets: 'assets/images/icon_wind.png')
                        ]),
                    SizedBox(height: Get.height * 0.01),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Cards(
                              title: '풍속',
                              subtitle: '12.5',
                              visibles: true,
                              assets: 'assets/images/icon_windsp.png'),
                          Cards(
                              title: '일사량',
                              subtitle: '12.5',
                              visibles: true,
                              assets: 'assets/images/icon_shiny.png')
                        ]),
                    SizedBox(height: Get.height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BoxDecoration 위젯 (shadow 미적용)
  BoxDecoration _decoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    );
  }

// BoxDecoration 위젯 (shadow 적용)
  BoxDecoration _decorations() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color(0xff2E8953),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 2,
          offset: Offset(3, 5), // changes position of shadow
        ),
      ],
    );
  }

// padding 위젯
  Padding _fromLTRBPadding({child}) {
    return Padding(
        padding: new EdgeInsets.fromLTRB(15, 10, 15, 5), child: child);
  }

  Padding _leftRightPadding({child}) {
    return Padding(
        padding: new EdgeInsets.only(left: 10, right: 10), child: child);
  }
}
