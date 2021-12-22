import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

/*
* name : CompleteComponent Page
* description : complete component page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class CompleteComponent extends StatefulWidget {
  const CompleteComponent({Key? key}) : super(key: key);

  @override
  _CompleteComponentState createState() => _CompleteComponentState();
}

class _CompleteComponentState extends State<CompleteComponent> {
  var data = Get.arguments[0];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _dataWidget('PunchID', data['punchID']),
        _dataWidget('Category', data['category']),
        _dataWidget('Area', data['area']),
        _sized15(),
        _dataWidget('Unit', data['unit']),
        _sized15(),
        _dataWidget('Tag Number', data['tagNumber']),
        _sized15(),
        _dataWidget('System', data['systemName']),
        _sized15(),
        _dataWidget('Sub-system', data['subsystemName']),
        SizedBox(
          height: 30,
        ),
        Container(
          width: 500,
          child: Divider(
            color: Color(0xff5D8791),
            thickness: 1.3,
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                data['notAcceptComment'],
                style: TextStyle(color: Color(0xff5D8791)),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _sized15() {
    return SizedBox(
      height: 30,
    );
  }

  Widget _dataWidget(String title, String datas) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 2 / 7,
          // height: Get.height * 1 / 11,
          child: Text(
            title,
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
        ),
        Flexible(
          child: Text(
            datas,
            style: TextStyle(color: Colors.white, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Widget _textWidget(String data) {
  //   return Flexible(
  //     child: Text(
  //       data,
  //       overflow: TextOverflow.ellipsis,
  //       style: TextStyle(color: Colors.white, fontSize: 13),
  //     ),
  //   );
  // }
}
