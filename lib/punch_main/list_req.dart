import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plms_start/ontap_other/list_ontap_other.dart';
// import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:plms_start/pages/components/list_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../globals/login.dart' as login;
/*
* name : Listreq Page
* description : req data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class ListReq extends StatefulWidget {
  ListReq({Key? key}) : super(key: key);

  @override
  _ListReqState createState() => _ListReqState();
}

class _ListReqState extends State<ListReq> {
  final List data = login.reqList;

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Container(
      color: Color(0xFFE6E6E6),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, var index) {
          return InkWell(
            onTap: () {
              Get.to(OnTapPage(), arguments: [index, login.reqList]);
            },
            child: ListComponent(
                title: AppLocalizations.of(context)!.tile4,
                data1:
                    "${data[index]['punchID']},${data[index]['category']},${data[index]['discipline']},${data[index]['unit']},${data[index]['area']}",
                data2: data[index]['systemName'],
                colors: 0xff987ca1),
          );
        },
      ),
    );
  }
}
