import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

// global
import '../../globals/stream.dart' as stream;
import '../../globals/siteConfig.dart' as siteConfig;
import "../../globals/checkUser.dart" as edgeworks;
import '../../globals/toggle.dart' as toggle;

class SwitchWidgets extends StatefulWidget {
  final names;
  const SwitchWidgets({Key? key, required this.names}) : super(key: key);

  @override
  State<SwitchWidgets> createState() => _SwitchWidgetsState();
}

class _SwitchWidgetsState extends State<SwitchWidgets> {
  List<String> labelName = ['ON', 'OFF'];
  var selectedLabel = '';
  int initialIndex = siteConfig.status_alarm == true ? 0 : 1;
  int? toggleValue;

//global key
  bool status = false;
  var _setTimer = siteConfig.set_timer;
  bool _alarmStatus = siteConfig.status_alarm;
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
              initialLabelIndex: alarmToggleValue,
              // stream.alarm_en == true ? 0 : 1,
              // stream.pumpStatus[index] == 0 ? 1 : 0,
              totalSwitches: 2,
              labels: labelName,
              radiusStyle: true,
              onToggle: (value) async {
                setState(() {
                  alarmToggleValue = value;
                  if (value == 0) {
                    status = true;
                  } else if (value == 1) {
                    status = false;
                  }
                  // toggleValue = value;
                  _alarmStatus = status;
                  // shared preferences toggle
                  toggle.saveAlarmToggle(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // [Function] get alarm toggle value
  int? alarmToggleValue;
  getAlarmToggle() async {
    final prefs = await SharedPreferences.getInstance();
    alarmToggleValue = prefs.getInt('alarmToggleValue') ?? 0;
    print('[global/toggle page] get all side value : $alarmToggleValue');
    setState(() {
      alarmToggleValue;
    });
    return alarmToggleValue;
  }
}
