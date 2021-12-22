import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plms_start/onTap_draft/list_ontap.dart';
import 'package:plms_start/ontap_other/list_ontap_other.dart';
import 'package:plms_start/pages/components/list_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../globals/login.dart' as login;
/*
* name : ListFile Page
* description : all data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class ListFile extends StatefulWidget {
  const ListFile({Key? key}) : super(key: key);

  @override
  _ListFileState createState() => _ListFileState();
}

class _ListFileState extends State<ListFile> {
  List draftList = login.draftList;
  List openList = login.openList;
  List reqList = login.reqList;
  List closeList = login.closeList;

  // String id = Get.arguments[4];
  // String password = Get.arguments[5];
  // String userName = Get.arguments[6];
  // String email = Get.arguments[7];
  // String company = Get.arguments[8];
  // String authority = Get.arguments[9];
  // List data =
  //     Get.arguments[0] + Get.arguments[1] + Get.arguments[2] + Get.arguments[3];

  @override
  Widget build(BuildContext context) {
    List data = (draftList + openList + reqList + closeList);

    // FutureBuilder listview
    return Container(
      color: Color(0xFFE6E6E6),
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, var index) {
            String data1 =
                "${data[index]['punchID']},${data[index]['category']},${data[index]['discipline']},${data[index]['unit']},${data[index]['area']}";
            String data2 = data[index]['systemName'];
            if (data[index]['status'] == "1") {
              return InkWell(
                onTap: () {
                  Get.to(OnTapScreen(), arguments: index);
                },
                child: ListComponent(
                    title: AppLocalizations.of(context)!.tile2,
                    data1: data1,
                    data2: data2,
                    colors: 0xff7c4141),
              );
            } else if (data[index]['status'] == "2" ||
                data[index]['status'] == '5') {
              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    login.visible == false
                        ? login.visible = true
                        : login.visible = false;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    // print(login.openList[index]);
                    Get.to(() => OnTapPage(),
                        arguments: [index - draftList.length, login.openList]);
                  },
                  child: Stack(children: [
                    ListComponent(
                        title: AppLocalizations.of(context)!.tile3,
                        data1: data1,
                        data2: data2,
                        colors: 0xffb88d6a),
                    Positioned(
                      top: Get.height * 1 / 80,
                      right: Get.width * 1 / 25,
                      child: SizedBox(
                        width: Get.width * 1 / 4,
                        height: Get.height * 2 / 60,
                        child: Visibility(
                          visible: login.visible,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.only(left: 0, right: 0),
                              primary: Color(0xff55b093), // background
                              // onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () {
                              print(data[index - draftList.length].runtimeType);
                              print(data[index - draftList.length]);
                              Get.toNamed('/complete',
                                  arguments: [data[index]]);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.completeButton,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            } else if (data[index]['status'] == "3" ||
                data[index]['status'] == '4') {
              return InkWell(
                onTap: () {
                  Get.to(OnTapPage(), arguments: [
                    index - draftList.length - openList.length,
                    login.reqList
                  ]);
                },
                child: ListComponent(
                    title: AppLocalizations.of(context)!.tile4,
                    data1: data1,
                    data2: data2,
                    colors: 0xff987ca1),
              );
            } else {
              return InkWell(
                onTap: () {
                  Get.to(OnTapPage(), arguments: [
                    index - draftList.length - openList.length - reqList.length,
                    login.closeList
                  ]);
                },
                child: ListComponent(
                    title: AppLocalizations.of(context)!.tile5,
                    data1: data1,
                    data2: data2,
                    colors: 0xff637a8f),
              );
            }
          }),
    );
  }
}
