//necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//use library
import 'package:toggle_switch/toggle_switch.dart';

//GetX
import 'package:edgeworks/utils/getX_controller/settingController.dart';

//controller
final controller = Get.put(SettingController());

class SwitchWidgets extends StatefulWidget {
  final names;
  const SwitchWidgets({Key? key, required this.names}) : super(key: key);

  @override
  State<SwitchWidgets> createState() => _SwitchWidgetsState();
}

class _SwitchWidgetsState extends State<SwitchWidgets> {
  List<String> labelName = ['ON', 'OFF'];
  var selectedLabel = '';
  int initialIndex = controller.status_alarm.value == true ? 0 : 1;

//global key
  bool status = false;
  // var _setTimer = controller.set_timer.value;
  // bool _alarmStatus = controller.status_alarm.value;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffFFFFFF),
      height: Get.height * 0.08,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              widget.names,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ToggleSwitch(
              fontSize: 12,
              minWidth: 60.0,
              cornerRadius: 80.0,
              activeBgColors: [
                [Color(0xffe3fbed)],
                [Color(0xfff2f2f2)]
              ],
              activeFgColor: Color(0xff222222),
              inactiveBgColor: Color(0xffFFFFFF),
              inactiveFgColor: Color(0xff222222),
              initialLabelIndex: controller.status_alarm.value == true ? 0 : 1,
              // stream.pumpStatus[index] == 0 ? 1 : 0,
              totalSwitches: 2,
              labels: labelName,
              radiusStyle: true,
              onToggle: (value) async {
                setState(() {
                  if (value == 0) {
                    status = true;
                  } else if (value == 1) {
                    status = false;
                  }
                  // toggleValue = value;
                  controller.status_alarm.value = status;
                  // shared preferences toggle
                  // toggle.saveAlarmToggle(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
