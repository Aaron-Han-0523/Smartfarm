import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plms_start/ontap_other/list_ontap_other.dart';
// import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:plms_start/pages/components/list_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../globals/login.dart' as login;
/*
* name : ListClose Page
* description : close data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class ListClose extends StatefulWidget {
  ListClose({Key? key}) : super(key: key);

  @override
  _ListCloseState createState() => _ListCloseState();
}

class _ListCloseState extends State<ListClose> {
  final List data = login.closeList;

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Container(
      color: Color(0xFFE6E6E6),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Get.to(OnTapPage(), arguments: [index, login.closeList]);
            },
            child: ListComponent(
                title: AppLocalizations.of(context)!.tile5,
                data1:
                    "${data[index]['punchID']},${data[index]['category']},${data[index]['discipline']},${data[index]['unit']},${data[index]['area']}",
                data2: data[index]['systemName'],
                colors: 0xff637a8f),
          );
        },
      ),
    );
  }
}
