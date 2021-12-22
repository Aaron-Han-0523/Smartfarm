import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:plms_start/pages/utils/row_text.dart';

import 'package:plms_start/pages/utils/title_text.dart';
import '../globals/globals.dart' as globals;
import '../globals/punch_continue.dart' as continues;
import '../globals/issue.dart' as issue;
/*
* name : PageOne
* description : punch issue first page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class PageOne extends StatefulWidget {
  PageOne({Key? key}) : super(key: key);

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  List<String> category = issue.categoryDataList;
  List<String> system = issue.systemsDataList;
  List<String> subsystem = issue.subsystemDataList;

  String _horizonGroupValue =
      globals.punch_issue_Bulk_Item[0] == '0' ? "Tag Number" : 'Bulk Item';
  List<String> _status = ['Tag Number', "Bulk Item"];

  var edge = EdgeInsets.fromLTRB(5, 10, 0, 0);

  bool _isTag = globals.punch_issue_Bulk_Item[0] == '0' ? true : false;
  bool _isBulk = globals.punch_issue_Bulk_Item[0] == '0' ? false : true;

// final _tagTextEditController = globals.punch_issue_Tag_Number.length == 1
//       // ? TextEditingController(text: globals.punch_issue_Tag_Number[0])
//       // : login.draftList[Get.arguments]['tagNumber'] == null
//           ? TextEditingController()
//           : TextEditingController(
//               text: login.draftList[Get.arguments]['tagNumber']);
//   final _bulkTextEditController = globals.punch_issue_Bulk_Name.length == 1
//       ? TextEditingController(text: globals.punch_issue_Bulk_Name[0])
//       : login.globalsList[Get.arguments]['bulkName'] == null
//           ? TextEditingController()
//           : TextEditingController(
//               text: login.draftList[Get.arguments]['bulkName']);

  final _unitTextEditController = globals.punch_issue_Unit.length != 0
      // ? TextEditingController(text: globals.punch_issue_Unit[0])
      // : login.draftList[Get.arguments]['unit'] == null
      ? TextEditingController(text: globals.punch_issue_Unit[0])
      : continues.punch_issue_Unit.length == 0
          ? TextEditingController()
          : TextEditingController(text: continues.punch_issue_Unit[0]);

  final _areaTextEditController = globals.punch_issue_Area.length != 0
      // ? TextEditingController(text: globals.punch_issue_Area[0])
      // : login.draftList[Get.arguments]['area'] == null
      ? TextEditingController(text: globals.punch_issue_Area[0])
      : continues.punch_issue_Area.length == 0
          ? TextEditingController()
          : TextEditingController(text: continues.punch_issue_Area[0]);

  final _punchTextEditController = globals.punch_issue_Punch_ID.length != 0
      // ? TextEditingController(text: globals.punch_issue_Punch_ID[0])
      // : login.draftList[Get.arguments]['punchID'] == null
      ? TextEditingController(text: globals.punch_issue_Punch_ID[0])
      : continues.punch_issue_Punch_ID.length == 0
          ? TextEditingController()
          : TextEditingController(text: continues.punch_issue_Punch_ID[0]);

  final _descrpitionTextEditController = globals
              .punch_issue_Description.length !=
          0
      ? TextEditingController(text: globals.punch_issue_Description[0])
      : continues.punch_issue_Description.length == 0
          ? TextEditingController()
          : TextEditingController(text: continues.punch_issue_Description[0]);

  final _tagTextEditController = globals.punch_issue_Tag_Number.length != 0
      ? TextEditingController(text: globals.punch_issue_Tag_Number[0])
      : continues.punch_issue_Tag_Number.length == 0
          ? TextEditingController()
          : TextEditingController(text: continues.punch_issue_Tag_Number[0]);

  final _bulkTextEditController = globals.punch_issue_Bulk_Name.length != 0
      ? TextEditingController(text: globals.punch_issue_Bulk_Name[0])
      : continues.punch_issue_Bulk_Item.length == 0
          ? TextEditingController()
          : TextEditingController(text: continues.punch_issue_Bulk_Name[0]);

  // final _unitTextEditController = globals.punch_issue_Unit.length == 1
  //     ? TextEditingController(text: globals.punch_issue_Unit[0])
  //     : TextEditingController();
  // final _areaTextEditController = globals.punch_issue_Area.length == 1
  //     ? TextEditingController(text: globals.punch_issue_Area[0])
  //     : TextEditingController();
  // final _punchTextEditController = globals.punch_issue_Punch_ID.length == 1
  //     ? TextEditingController(text: globals.punch_issue_Punch_ID[0])
  //     : TextEditingController();
  // final _descrpitionTextEditController =
  //     globals.punch_issue_Description.length == 1
  //         ? TextEditingController(text: globals.punch_issue_Description[0])
  //         : TextEditingController();

  @override
  void initState() {
    print('!!!!!!!!!!!!!!!!!!!!!!!!!');
    print(continues.punch_issue_Bulk_Item);
    print(continues.punch_issue_Unit.length);
    super.initState();
  }

  Widget _size15() {
    return SizedBox(
      height: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    var radius = Radius.circular(10);
    return Container(
      // height: MediaQuery.of(context).size.height,
      color: Color(0xFFE6E6E6),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xffB7C5B9),
                borderRadius:
                    BorderRadius.only(topLeft: radius, bottomLeft: radius),
              ),
              height: Get.height + Get.height * 0.05,
              width: Get.width * 1 / 50,
            ),
            Container(
              height: Get.height + Get.height * 0.05,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleText(
                          title: 'General Infomation',
                        ),
                        RowText(title: 'Marks are required fields')
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            color: Colors.grey[100],
                            child: Column(
                              children: [
                                _radioButton(),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Column(
                                    children: [
                                      _textField2(
                                          'Tag Number',
                                          globals.punch_issue_Tag_Number,
                                          _tagTextEditController),
                                      _size15(),
                                      _textField3(
                                          'Bulk Name',
                                          '',
                                          globals.punch_issue_Bulk_Name,
                                          _bulkTextEditController),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        _size15(),
                        _dropdownButton(
                            'Category',
                            category,
                            issue.categoryList,
                            globals.punch_issue_Category,
                            continues.punch_issue_Category),
                        _size15(),
                        _dropdownButton(
                            'System',
                            system,
                            issue.systemsList,
                            globals.punch_issue_System,
                            continues.punch_issue_System),
                        _size15(),
                        _dropdownButton(
                          'Sub-System',
                          subsystem,
                          issue.subsystemList,
                          globals.punch_issue_Sub_System,
                          continues.punch_issue_Sub_System,
                        ),
                        _size15(),
                        // _size15(),
                        _unittextField('  Unit', 'Create or Add',
                            globals.punch_issue_Unit, _unitTextEditController),
                        _size15(),
                        _areatextField('  Area', 'Create or Add',
                            globals.punch_issue_Area, _areaTextEditController),
                        _size15(),
                        _textFormField(
                            'Punch ID',
                            'Add',
                            globals.punch_issue_Punch_ID,
                            _punchTextEditController),
                        _size15(),

                        _description(globals.punch_issue_Description,
                            _descrpitionTextEditController),
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

// 라디오 버튼
  Widget _radioButton() {
    return RadioGroup<String>.builder(
      activeColor: Colors.green,
      direction: Axis.horizontal,
      groupValue: _horizonGroupValue,
      onChanged: (value) => setState(() {
        _horizonGroupValue = value!;
        print(value);
        if (value == _status[0]) {
          if (globals.punch_issue_Bulk_Name.length > 1) {
            globals.punch_issue_Bulk_Name = [];
          }

          _bulkTextEditController.clear();
          _isTag = true;
          _isBulk = false;
          if (_isBulk == false) {
            globals.punch_issue_Bulk_Item = ['0'];
          }
        } else if (value == _status[1]) {
          if (globals.punch_issue_Tag_Number.length == 1) {
            globals.punch_issue_Tag_Number.removeAt(0);
          }
          _tagTextEditController.clear();
          _isTag = false;
          _isBulk = true;
          if (_isBulk == true) {
            globals.punch_issue_Bulk_Item = ['1'];
          }
        }
      }),
      items: _status,
      itemBuilder: (item) => RadioButtonBuilder(
        item,
        textPosition: RadioButtonTextPosition.left,
      ),
    );
  }

// description
  Widget _description(var globaldata, var controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("  Description"),
          ],
        ),
        _size15(),
        Container(
          padding: EdgeInsets.only(left: 7),
          width: Get.width * 2.45 / 3,

          // height: 100,
          child: TextField(
              controller: controller,
              onChanged: (String str) {
                setState(() {
                  if (globaldata.length == 0) {
                    globaldata.add(str);
                  } else {
                    globaldata.removeAt(0);
                    globaldata.add(str);
                  }
                  print('globaldata!!!!!!!!!!');
                  print(globaldata);
                });
              },
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              maxLength: 500,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "hint",
                isDense: true,
              )),
        ),
      ],
    );
  }

// dropdown button
  Widget _dropdownButton(
      String text, var data1, var data2, var data3, var data4) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 1 / 3.6,
          child: Row(
            children: [
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
              Text(text),
            ],
          ),
        ),
        SizedBox(
          width: Get.width * 2.7 / 5,
          height: Get.height * 1.1 / 25,
          // child: Newbutton(),
          child: DropdownSearch<String>(
            dropdownSearchDecoration: InputDecoration(
              contentPadding: edge,

              border: OutlineInputBorder(),
              // isDense: true,
              // isCollapsed: true,
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            dropDownButton: Icon(null),
            showSearchBox: true,
            mode: Mode.BOTTOM_SHEET,
            showSelectedItem: true,
            items: data1,
            onChanged: (value) {
              // 1. global first, second, third 값을 모두 한방에 관리하는 방법
              // 2. punch_issue scope 에서만 사용하는 모델 또는 저장 객체를 두는 방법 => 적합
              // 3. 결론 : flutter 에 global key 활용
              data4 = [];
              print("confirm : " + value.toString());
              for (var i = 0; i < data1.length; i++) {
                if (value == data1[i]) {
                  setState(() {
                    value = data2[i];
                  });
                }
              }

              if (text == "Category") {
                globals.punch_issue_Category.removeAt(0);
                globals.punch_issue_Category.add(value.toString());
              } else if (text == "System") {
                globals.punch_issue_System.removeAt(0);
                globals.punch_issue_System.add(value.toString());
              } else if (text == "Sub-System") {
                globals.punch_issue_Sub_System.removeAt(0);
                globals.punch_issue_Sub_System.add(value.toString());
              }
              print("global 테스트");
              // print(value.);
              print(globals.punch_issue_Category);
              print(globals.punch_issue_System);
              print(globals.punch_issue_Sub_System);
            },
            selectedItem: data4.length == 1
                ? data3[0]
                : data3.length == 0
                    ? data2[0]
                    : data3[0],
          ),
        ),
      ],
    );
  }

// unit textfield
  Widget _unittextField(
      String text, String hint, var globaldata, var controller) {
    return Row(
      children: [
        Container(width: Get.width * 1 / 3.6, child: Text(text)),
        SizedBox(
          width: Get.width * 2.2 / 5,
          height: Get.height * 1.1 / 25,
          child: TextField(
              controller: controller,
              maxLines: 1,
              onChanged: (String str) {
                setState(() {
                  if (globaldata.length == 0) {
                    globaldata.add(str);
                  } else {
                    globaldata.removeAt(0);
                    globaldata.add(str);
                  }
                  print('globaldata!!!!!!!!!!');
                  print(globaldata);
                });
              },
              // controller: controller,
              decoration: InputDecoration(
                contentPadding: edge,
                isDense: true,
                border: OutlineInputBorder(),
                hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
                hintText: hint,
              )),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
            color: Colors.grey[500],
            width: 30,
            height: 30,
            child: IconButton(
                padding: EdgeInsets.all(4),
                // autofocus: true,
                // visualDensity: VisualDensity(
                //   vertical: 2.5,
                //   horizontal: 2.5,
                // ),
                onPressed: () {
                  setState(() {
                    showModalBottomSheet(
                      // isScrollControlled: true,
                      context: context,
                      builder: _bottomSheetUnit,
                    );
                  });

                  print(globals.punch_issue_Unit);
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ))),
      ],
    );
  }

// botton sheet unit
  Widget _bottomSheetUnit(BuildContext context) {
    var data = issue.unitDataList;
    return Container(
      height: Get.height * 1.55 / 3,
      padding: EdgeInsets.all(10),
      child: ListView.builder(
          // scrollDirection: Axis.vertical,
          itemCount: data.length,
          itemBuilder: (BuildContext context, var index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _unitTextEditController.text = issue.unitList[index];
                  if (globals.punch_issue_Unit.length == 1) {
                    globals.punch_issue_Unit.removeAt(0);
                    globals.punch_issue_Unit.add(_unitTextEditController.text);
                  } else {
                    globals.punch_issue_Unit.add(_unitTextEditController.text);
                  }

                  Get.back();
                });
              },
              child: Container(
                width: Get.width,
                child: Text(
                  data[index],
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }),
    );
  }

// area text
  Widget _areatextField(
      String text, String hint, var globaldata, var controller) {
    return Row(
      children: [
        Container(width: Get.width * 1 / 3.6, child: Text(text)),
        SizedBox(
          width: Get.width * 2.2 / 5,
          height: Get.height * 1.1 / 25,
          child: TextField(
              controller: controller,
              maxLines: 1,
              onChanged: (String str) {
                setState(() {
                  if (globaldata.length == 0) {
                    globaldata.add(str);
                  } else {
                    globaldata.removeAt(0);
                    globaldata.add(str);
                  }
                  print('globaldata!!!!!!!!!!');
                  print(globaldata);
                });
              },
              // controller: controller,
              decoration: InputDecoration(
                contentPadding: edge,
                isDense: true,
                border: OutlineInputBorder(),
                hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
                hintText: hint,
              )),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
            color: Colors.grey[500],
            width: 30,
            height: 30,
            child: IconButton(
                padding: EdgeInsets.all(4),
                // autofocus: true,
                // visualDensity: VisualDensity(
                //   vertical: 2.5,
                //   horizontal: 2.5,
                // ),
                onPressed: () {
                  setState(() {
                    showModalBottomSheet(
                      // isScrollControlled: true,
                      context: context,
                      builder: _bottomSheetArea,
                    );
                  });

                  print(globals.punch_issue_Area);
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ))),
      ],
    );
  }

// botton sheet area
  Widget _bottomSheetArea(BuildContext context) {
    var data = issue.areaDataList;
    return Container(
      height: Get.height * 1.55 / 3,
      padding: EdgeInsets.all(10),
      child: ListView.builder(
          // scrollDirection: Axis.vertical,
          itemCount: data.length,
          itemBuilder: (BuildContext context, var index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _areaTextEditController.text = issue.areaList[index];
                  if (globals.punch_issue_Area.length == 1) {
                    globals.punch_issue_Area.removeAt(0);
                    globals.punch_issue_Area.add(_areaTextEditController.text);
                  } else {
                    globals.punch_issue_Area.add(_areaTextEditController.text);
                  }

                  Get.back();
                });
              },
              child: Container(
                // width: Get.width,
                // color: Colors.red,
                height: Get.height * 2 / 20,
                child: Text(
                  data[index],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }),
    );
  }

  // punchID text field
  Widget _textFormField(
      String text, String hint, var globaldata, var controller) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
                Container(child: Text(text)),
              ],
            ),
            _size15(),
            Container(
              padding: EdgeInsets.only(left: 7),
              width: Get.width * 2.45 / 3,
              height: Get.height * 1.1 / 25,
              child: TextFormField(
                  controller: controller,
                  onChanged: (String str) {
                    setState(() {
                      if (globaldata.length == 0) {
                        globaldata.add(str);
                      } else {
                        globaldata.removeAt(0);
                        globaldata.add(str);
                      }
                      print('globaldata!!!!!!!!!!');
                      print(globaldata);
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: edge,
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
                    hintText: hint,
                  )),
            ),
          ],
        ),
      ],
    );
  }

// textfield tag number
  Widget _textField2(String text, var globaldata, var controller) {
    return Row(
      children: [
        Container(width: Get.width * 1 / 3.6, child: Text(text)),
        Container(
          width: Get.width * 2.2 / 5,
          height: Get.height * 1.1 / 25,
          child: TextField(
              controller: controller,
              onChanged: (String str) {
                setState(() {
                  if (globaldata.length == 0) {
                    globaldata.add(str);
                  } else {
                    globaldata.removeAt(0);
                    globaldata.add(str);
                  }
                  print('globaldata!!!!!!!!!!');
                  print(globaldata);
                });
              },
              enabled: _isTag,
              decoration: InputDecoration(
                contentPadding: edge,
                isDense: true,
                border: OutlineInputBorder(),
                hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
                // hintText: hint,
              )),
        ),
      ],
    );
  }

// textfield bulk
  Widget _textField3(String text, String hint, var globaldata, var controller) {
    return Row(
      children: [
        Container(width: Get.width * 1 / 3.6, child: Text(text)),
        Container(
          width: Get.width * 2.2 / 5,
          height: Get.height * 1.1 / 25,
          child: TextField(
              controller: controller,
              onChanged: (String str) {
                setState(() {
                  if (globaldata.length == 0) {
                    globaldata.add(str);
                  } else {
                    globaldata.removeAt(0);
                    globaldata.add(str);
                  }
                  print('globaldata!!!!!!!!!!');
                  print(globaldata);
                });
              },
              enabled: _isBulk,
              decoration: InputDecoration(
                contentPadding: edge,
                isDense: true,
                border: OutlineInputBorder(),
                hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
                hintText: hint,
              )),
        ),
      ],
    );
  }
}
