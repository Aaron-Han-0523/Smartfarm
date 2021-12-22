import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:simple_tags/simple_tags.dart';

import '../pages/utils/title_text.dart';

import '../globals/globals.dart' as globals;
import '../globals/punch_continue.dart' as continues;
import '../globals/issue.dart' as issue;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
/*
* name : PageTwo
* description : punch issue two page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  List actionon = issue.deptNameList;
  List discipline = issue.disciplineNameList;
  List raisedon = issue.qcList;

  List actiononStart = [issue.deptNameList[0]];
  List disciplineStart = [issue.disciplineNameList[0]];
  List raisedonStart = [];

  bool isSwitch2 = continues.punch_issue_Material.length == 0
      ? false
      : continues.punch_issue_Material[0] == '0'
          ? false
          : true;
  bool isSwitch1 = continues.punch_issue_Design.length == 0
      ? false
      : continues.punch_issue_Design[0] == '0'
          ? false
          : true;

  List<String> contentList = [];

  final _tagTextEditController = TextEditingController();

  @override
  void initState() {
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print(continues.punch_issue_Keyword);
    print(continues.punch_issue_Action_On);
    print(continues.punch_issue_Discipline);
    print(continues.punch_issue_Raised_On);
    if (continues.punch_issue_Keyword.length != 0) {
      for (var i = 0; i < continues.punch_issue_Keyword.length; i++) {
        contentList.add(continues.punch_issue_Keyword[i]);
      }
    }
    print(contentList);
    if (continues.punch_issue_Action_On.length != 0 &&
        continues.punch_issue_Action_On[0] != null) {
      for (var i = 0; i < actionon.length; i++) {
        if (continues.punch_issue_Action_On[0] == issue.deptList[i]) {
          setState(() {
            if (actiononStart.length != 0) {
              actiononStart = [];
              actiononStart.add(actionon[i]);
            } else {
              actiononStart.add(actionon[i]);
            }
          });
        }
      }
    }
    if (continues.punch_issue_Discipline.length != 0 &&
        continues.punch_issue_Discipline[0] != null) {
      for (var i = 0; i < discipline.length; i++) {
        if (continues.punch_issue_Discipline[0] == issue.disciplineList[i]) {
          setState(() {
            if (disciplineStart.length != 0) {
              disciplineStart = [];
              disciplineStart.add(discipline[i]);
            } else {
              disciplineStart.add(discipline[i]);
            }
          });
        }
      }
    }
    if (continues.punch_issue_Raised_On.length != 0 &&
        continues.punch_issue_Raised_On[0] != null) {
      for (var i = 0; i < raisedon.length; i++) {
        if (continues.punch_issue_Raised_On[0] == issue.qcList[i]) {
          setState(() {
            raisedonStart.add(raisedon[i]);
          });
        }
      }
    } else {
      raisedonStart.add('');
    }

    setState(() {});
    print(globals.punch_issue_Action_On);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var radius = Radius.circular(10);
    // final containerSize = _getSize(_heightKey);
    // double conHeight = containerSize.height;
    return Container(
      color: Color(0xFFE6E6E6),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffB7C5B9),
                  borderRadius:
                      BorderRadius.only(topLeft: radius, bottomLeft: radius),
                ),
                height: MediaQuery.of(context).size.height * 2.1 / 3,
                width: Get.width * 1 / 50,
              ),
            ),
            Container(
              // key: _heightKey,
              // height: 500,
              height: MediaQuery.of(context).size.height * 2.1 / 3,
              width: Get.width - Get.width * 0.83 / 8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(topRight: radius, bottomRight: radius),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffB7C5B9),
                    offset: Offset(0, 0.3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TitleText(
                          title: 'Assign',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        _dropdownButton('Action On', actionon, issue.deptList,
                            actiononStart, continues.punch_issue_Action_On),
                        _size15(),
                        _dropdownButton(
                            'Discipline',
                            discipline,
                            issue.disciplineList,
                            disciplineStart,
                            continues.punch_issue_Discipline),
                        _size15(),
                        _dropdownButton('Raised On', raisedon, issue.qcList,
                            raisedonStart, continues.punch_issue_Raised_On),
                        _size15(),
                        _dataTime('Target Date'),
                        _size15(),
                        // TaggingButton(name: 'Keyword'),
                        _tagWidget('keyword', _tagTextEditController),
                        SizedBox(
                          height: 30,
                        ),
                        _lineWidget(),
                        _size15(),
                        _swichsButton('Design Change Required'),
                        // _size15(),
                        _swichsButton2('Material Required'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 높이 15 박스
  Widget _size15() {
    return SizedBox(
      height: 15,
    );
  }

  // line container
  Widget _lineWidget() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(border: Border.all(width: 0.3)),
    );
  }

  // 달력 날짜 선택
  Widget _dataTime(String text) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 1 / 3.6,
          child: Text(text),
        ),
        SizedBox(
          width: Get.width * 2.7 / 5,
          height: Get.height * 1.1 / 25,
          // child: Newbutton(),
          child: DateTimePicker(
            dateMask: 'yyyy.MM.dd',
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5, 15, 0, 0),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
              isDense: true,
            ),
            initialValue: '',
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            // dateLabelText: 'Date',
            onChanged: (val) {
              setState(() {
                if (globals.punch_issue_Date.length == 0) {
                  globals.punch_issue_Date.add(val);
                } else {
                  globals.punch_issue_Date = [];
                  globals.punch_issue_Date.add(val);
                }
                print('globaldata!!!!!!!!!!');
                print(globals.punch_issue_Date);
              });
            },
          ),
        ),
      ],
    );
  }

  // 드롭다운버튼 Row
  Widget _dropdownButton(
      String text, var data1, var data2, var data3, var data4) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 1 / 3.6,
          child: Text(text),
        ),
        SizedBox(
          width: Get.width * 2.7 / 5,
          height: Get.height * 1.1 / 25,
          // child: Newbutton(),
          child: DropdownSearch<String>(
            dropdownSearchDecoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 0),
              border: OutlineInputBorder(),
              isDense: true,
              // isCollapsed: true,
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            dropDownButton: Icon(null),
            showSearchBox: true,
            mode: Mode.BOTTOM_SHEET,
            showSelectedItem: true,
            items: data1,
            hint: "Menu mode",
            onChanged: (value) {
              // 1. global first, second, third 값을 모두 한방에 관리하는 방법
              // 2. punch_issue scope 에서만 사용하는 모델 또는 저장 객체를 두는 방법 => 적합
              // 3. 결론 : flutter 에 global key 활용

              print("confirm : " + value.toString());
              print("confirm : " + value.toString());
              for (var i = 0; i < data1.length; i++) {
                if (value == data1[i]) {
                  setState(() {
                    value = data2[i];
                  });
                }
              }
              setState(() {
                if (text == "Action On") {
                  if (globals.punch_issue_Action_On.length >= 1) {
                    globals.punch_issue_Action_On = [];
                    globals.punch_issue_Action_On.add(value.toString());
                  } else {
                    globals.punch_issue_Action_On.add(value.toString());
                  }
                } else if (text == "Discipline") {
                  if (globals.punch_issue_Discipline.length >= 1) {
                    globals.punch_issue_Discipline = [];
                    globals.punch_issue_Discipline.add(value.toString());
                  } else {
                    globals.punch_issue_Discipline.add(value.toString());
                  }
                } else if (text == 'Raised On') {
                  if (globals.punch_issue_Raised_On.length >= 1) {
                    globals.punch_issue_Raised_On = [];
                    globals.punch_issue_Raised_On.add(value.toString());
                  } else {
                    globals.punch_issue_Raised_On.add(value.toString());
                  }
                }
              });

              print("global 테스트");
              // print(value.);
              print(globals.punch_issue_Action_On);
              print(globals.punch_issue_Discipline);
              print(globals.punch_issue_Raised_On);
            },
            selectedItem: data4.length == 1
                ? data3[0]
                : data3.length == 0
                    ? ''
                    : data3[0],
          ),
        ),
      ],
    );
  }

  // 체크박스 버튼 디자인
  Widget _swichsButton(String title) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 250,
          child: Text(title),
        ),
        Checkbox(
          value: isSwitch1,
          onChanged: (valued) {
            setState(() {
              isSwitch1 = valued!;
              print(isSwitch1);
              if (globals.punch_issue_Design.length == 0) {
                if (isSwitch1 == true) {
                  globals.punch_issue_Design.add('1');
                } else {
                  globals.punch_issue_Design.add('0');
                }
              } else {
                globals.punch_issue_Design = [];
                if (isSwitch1 == true) {
                  globals.punch_issue_Design.add('1');
                } else {
                  globals.punch_issue_Design.add('0');
                }
              }
            });
            print(globals.punch_issue_Design);
          },
          // activeTrackColor: Colors.yellow,
          activeColor: Colors.green,
        ),
      ],
    );
  }

  // 체크박스 버튼 material
  Widget _swichsButton2(String title) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 250,
          child: Text(title),
        ),
        Checkbox(
          value: isSwitch2,
          onChanged: (valued) {
            setState(() {
              isSwitch2 = valued!;
              print(isSwitch2);
              if (globals.punch_issue_Material.length == 0) {
                if (isSwitch2 == true) {
                  globals.punch_issue_Material.add('1');
                } else {
                  globals.punch_issue_Material.add('0');
                }
              } else {
                globals.punch_issue_Material = [];
                if (isSwitch2 == true) {
                  globals.punch_issue_Material.add('1');
                } else {
                  globals.punch_issue_Material.add('0');
                }
              }
            });
            print(globals.punch_issue_Material);
          },
          // activeTrackColor: Colors.yellow,
          activeColor: Colors.green,
        ),
      ],
    );
  }

  //textfield keyword
  Widget _textField(String title, var controller) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 1 / 3.6,
          child: Text(title),
        ),
        SizedBox(
          width: Get.width * 2.22 / 5,
          height: Get.height * 1.1 / 25,
          child: TextFormField(
            style: TextStyle(fontSize: 17),
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5, 15, 0, 0),
              border: OutlineInputBorder(),

              // helperText: helperText,
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: Get.height * 1.1 / 25,
          height: Get.height * 1.1 / 25,
          color: Colors.grey,
          child: IconButton(
            color: Colors.white,
            padding: EdgeInsets.all(2),
            icon: Icon(Icons.add),
            onPressed: () {
              if (contentList.length > 3) {
                _showDialog();
              } else if (_tagTextEditController.text != '') {
                contentList.add(controller.text);
                controller.clear();
              }

              globals.punch_issue_Keyword = [];
              globals.punch_issue_Keyword = contentList;

              setState(() {
                print(globals.punch_issue_Keyword);
              });
            },
          ),
        )
      ],
    );
  }

// keyword 4개이상 에러 문구
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text("You can't use more than 4 keywords."),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff71838D),
                  ),
                  child:
                      new Text(AppLocalizations.of(context)!.loginDialogButton),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

// tagwidget
  Widget _tagWidget(String text, var controller) {
    return Column(
      children: [
        _textField(text, controller),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            SizedBox(
              width: Get.width * 1 / 3.6,
            ),
            Expanded(
              child: SimpleTags(
                // wrapDirection: Axis.vertical,
                // tagTextOverflow: TextOverflow.fade,
                content: contentList,
                // wrapSpacing: 4,
                // wrapRunSpacing: 4,
                onTagPress: (tag) {
                  setState(() {});
                  contentList.remove(tag);
                  globals.punch_issue_Keyword = [];
                  globals.punch_issue_Keyword = contentList;
                  print('pressed $tag');
                  print(globals.punch_issue_Keyword);
                },
                tagContainerPadding: EdgeInsets.all(6),
                tagTextStyle: TextStyle(color: Colors.black),
                tagIcon: Icon(Icons.clear, size: 12),
                tagContainerDecoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
