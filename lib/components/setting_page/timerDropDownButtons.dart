//necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//GetX
import 'package:edgeworks/utils/getX_controller/settingController.dart';

//conterller
final controller = Get.put(SettingController());

class TimerDropDownButtons extends StatefulWidget {
  final String name;
  const TimerDropDownButtons({Key? key, required this.name}) : super(key: key);

  @override
  State<TimerDropDownButtons> createState() => _TimerDropDownButtonsState();
}

class _TimerDropDownButtonsState extends State<TimerDropDownButtons> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Color(0xffFFFFFF),
        height: Get.height * 0.08,
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(widget.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54)),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: DropdownButton<String>(
                value: controller.set_timer.value,
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.black, size: 30),
                style: const TextStyle(color: Colors.black54),
                underline: Container(
                  height: 2,
                  color: Colors.black26,
                ),
                onChanged: (value) {
                  setState(() {
                    controller.set_timer.value = value!.toString();
                    // _setTimer = value;
                  });
                },
                items: <String>[
                  '0',
                  '30',
                  '60',
                  '90',
                  '120',
                  '150',
                  '180',
                  '210',
                  '240'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.normal,
                          fontSize: 13),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
