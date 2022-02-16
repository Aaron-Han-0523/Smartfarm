// import 'package:edgeworks/components/setting_page/switchWidget.dart';
// import 'package:flutter/material.dart';

// class BodyListViews extends StatelessWidget {
//   const BodyListViews({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       scrollDirection: Axis.vertical,
//       children: [
//         Container(
//           padding: EdgeInsets.only(left: 15, top: 20, bottom: 15),
//           child: Align(
//               alignment: Alignment.topLeft,
//               child: Text('경보 설정',
//                   style: TextStyle(fontSize: 15, color: Colors.black54))),
//         ),
//         SwitchWidgets( names: '경보 활성화',),
//         SizedBox(height: Get.height * 0.02),
//         _highTempFormField(
//             '고온 경보 (°C)', "alarm_high_temp", _highTextEditController),
//         SizedBox(height: Get.height * 0.02),
//         _lowTempFormField(
//             '저온 경보 (°C)', "alarm_low_temp", _lowTextEditController),
//         const Divider(
//           height: 30,
//           thickness: 1,
//           indent: 0,
//           endIndent: 0,
//           color: Colors.black26,
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 15, top: 20, bottom: 15),
//           child: Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 '관수 타이머 설정',
//                 style: TextStyle(fontSize: 13, color: Colors.black54),
//               )),
//         ),
//         _timerDropDownButtons('타이머 시간'),
//         SizedBox(height: Get.height * 0.02),
//         _sitesDropDownButtons('사이트 설정'),
//         SizedBox(height: Get.height * 0.15),
//         _siteConfigSetButton()
//       ],
//     );
//   }
// }
