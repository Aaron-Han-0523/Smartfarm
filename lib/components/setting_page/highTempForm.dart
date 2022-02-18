// ** HIGH TEMP FORM WIDGET **

//Necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//GetX
import 'package:edgeworks/utils/getX_controller/settingController.dart';

// Controller
final controller = Get.put(SettingController());
final _nullTextEditingController = TextEditingController(text: ' ');

class HighTempForm extends StatefulWidget {
  final String title;
  final String dic;
  final TextEditingController highTempController;
  const HighTempForm(
      {Key? key,
      required this.title,
      required this.dic,
      required this.highTempController})
      : super(key: key);

  @override
  State<HighTempForm> createState() => _HighTempFormState();
}

class _HighTempFormState extends State<HighTempForm> {
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
                    : widget.highTempController,
                // highTempController
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
