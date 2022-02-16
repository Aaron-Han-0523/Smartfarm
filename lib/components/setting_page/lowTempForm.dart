//necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//GetX
import 'package:edgeworks/utils/getX_controller/settingController.dart';

//Controller
final controller = Get.put(SettingController());
final _nullTextEditingController = TextEditingController(text: ' ');

class LowTempForm extends StatefulWidget {
  final String title;
  final String dic;
  final dynamic lowTempController;
  const LowTempForm(
      {Key? key,
      required this.title,
      required this.dic,
      required this.lowTempController})
      : super(key: key);

  @override
  State<LowTempForm> createState() => _LowTempFormState();
}

class _LowTempFormState extends State<LowTempForm> {
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
              child: Text(widget.title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54)),
            ),
            Container(
              padding: EdgeInsets.only(right: 15),
              width: Get.width * 0.35,
              height: Get.height * 0.06,
              child: TextFormField(
                enabled: controller.status_alarm.value,
                controller: controller.status_alarm.value == false
                    ? _nullTextEditingController
                    : widget.lowTempController,
                // lowTempController,
                decoration: InputDecoration(
                  hintText: ' 온도를 입력하세요',
                  hintStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black38),
                ),
                onChanged: (text) {
                  // setState(() {});
                  print('${widget.title} : $text');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
