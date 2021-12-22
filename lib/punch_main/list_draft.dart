import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plms_start/ontap_draft/list_ontap.dart';
import 'package:plms_start/pages/components/list_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../globals/login.dart' as login;

/*
* name : ListDraft Page
* description : draft data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class ListDraft extends StatefulWidget {
  ListDraft({Key? key}) : super(key: key);

  @override
  _ListDraftState createState() => _ListDraftState();
}

class _ListDraftState extends State<ListDraft> {
  List data = login.draftList;

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Container(
      color: Color(0xFFE6E6E6),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, var index) {
          return GestureDetector(
            onTap: () {
              Get.to(OnTapScreen(), arguments: index);
            },
            child: ListComponent(
                title: AppLocalizations.of(context)!.tile2,
                data1:
                    "${data[index]['punchID']},${data[index]['category']},${data[index]['discipline']},${data[index]['unit']},${data[index]['area']}",
                data2: data[index]['systemName'],
                colors: 0xff7c4141),
          );
        },
      ),
    );
  }
}
