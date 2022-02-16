import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cards extends StatelessWidget {
  final title;
  final subtitle;
  final visibles;
  final assets;
  const Cards({Key? key, this.title, this.subtitle, this.visibles, this.assets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibles,
      child: Container(
        margin: EdgeInsets.only(left: 7, right: 7, bottom: 10),
        height: Get.height * 1 / 9,
        width: Get.width * 0.4,
        decoration: _decoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 23),
                child: Text(title,
                    style: TextStyle(color: Color(0xff2E8953), fontSize: 12)),
              ),
              Text(subtitle,
                  style: TextStyle(
                      color: Color(0xff222222),
                      fontSize: 25,
                      fontWeight: FontWeight.w500)),
            ]),
            Image.asset(
              assets,
              scale: 3,
            )
            // Icon(icon, size: 60, color: Colors.black54)
          ],
        ),
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
}
