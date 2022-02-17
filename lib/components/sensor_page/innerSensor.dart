import 'package:edgeworks/components/sensor_page/card.dart';
import 'package:edgeworks/utils/getX_controller/sensorController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final controller = Get.put(SensorController());

List innerData = ['내부 온도', '내부 습도', '토양 온도', '토양 습도'];
List innerCon = [
  controller.innerTemp,
  controller.innerHumid,
  controller.soilTemp,
  controller.soilHumid
];

class InnerSensor extends StatelessWidget {
  const InnerSensor({Key? key}) : super(key: key);

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
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  title: Row(
                    children: [
                      _leftRightPadding(
                        child: Image.asset(
                          'assets/images/icon_inevn.png',
                          scale: 3,
                        ),
                      ),
                      Text(
                        '내부 환경',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    SizedBox(
                      width: Get.width,
                      height:
                          (Get.height * 1 / 9) * (innerData.length ~/ 2 + 0.4),
                      child: GridView.count(
                        primary: false,
                        childAspectRatio:
                            (Get.width * 0.4) / (Get.height * 1 / 9),
                        crossAxisCount: 2,
                        children: List.generate(innerData.length, (index) {
                          return Cards(
                              title: innerData[index],
                              subtitle: innerCon[index].value,
                              visibles: true,
                              assets: 'assets/images/icon_temp.png');
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
  return Padding(padding: new EdgeInsets.fromLTRB(15, 10, 15, 5), child: child);
}

Padding _leftRightPadding({child}) {
  return Padding(
      padding: new EdgeInsets.only(left: 10, right: 10), child: child);
}
