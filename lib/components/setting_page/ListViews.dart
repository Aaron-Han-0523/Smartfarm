//necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//GetX
import 'package:edgeworks/utils/getX_controller/settingController.dart';

// use class
import 'package:edgeworks/components/setting_page/highTempForm.dart';
import 'package:edgeworks/components/setting_page/lowTempForm.dart';
import 'package:edgeworks/components/setting_page/siteConfigSetButton.dart';
import 'package:edgeworks/components/setting_page/sitesDropDownButtons.dart';
import 'package:edgeworks/components/setting_page/switchWidget.dart';
import 'package:edgeworks/components/setting_page/timerDropDownButtons.dart';

//global
import '../../globals/stream.dart' as stream;

//controller
final controller = Get.put(SettingController());
final _highTextEditController = TextEditingController(
    text: controller.high_temp.value == '' ? null : controller.high_temp.value);
final _lowTextEditController = TextEditingController(
    text: controller.low_temp.value == '' ? null : controller.low_temp.value);

// siteDropdown button global variable
String sitesDropdownValue =
    stream.sitesDropdownValue == '' ? 'test' : stream.sitesDropdownValue;

class BodyListViews extends StatelessWidget {
  const BodyListViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        _containerWidget('경보 설정', 15),
        SwitchWidgets(
          names: '경보 활성화',
        ),
        SizedBox(height: Get.height * 0.02),
        HighTempForm(
            title: '고온 경보 (°C)',
            dic: "alarm_high_temp",
            highTempController: _highTextEditController),
        SizedBox(height: Get.height * 0.02),
        LowTempForm(
            title: '저온 경보 (°C)',
            dic: "alarm_low_temp",
            lowTempController: _lowTextEditController),
        const Divider(
          height: 30,
          thickness: 1,
          indent: 0,
          endIndent: 0,
          color: Colors.black26,
        ),
        _containerWidget('관수 타이머 설정', 13),
        TimerDropDownButtons(name: '타이머 시간'),
        SizedBox(height: Get.height * 0.02),
        SitesDropDownButtons(name: '사이트 설정'),
        SizedBox(height: Get.height * 0.15),
        SiteConfigSetButton(
            highTempController: _highTextEditController,
            lowTempController: _lowTextEditController)
      ],
    );
  }

  Widget _containerWidget(String title, double fontsize) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 20, bottom: 15),
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(title,
              style: TextStyle(fontSize: fontsize, color: Colors.black54))),
    );
  }
}
