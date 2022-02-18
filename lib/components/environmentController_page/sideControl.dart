// ** SIDE MOTOR CONTROL VIEW WIDGET **

// Necessary to build app
import 'package:flutter/material.dart';
import 'package:edgeworks/utils/mqtt/mqtt.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// GetX  controller
import 'package:edgeworks/utils/getX_controller/motorController.dart';
import 'package:toggle_switch/toggle_switch.dart';

// Dio
import 'package:dio/dio.dart';
import 'package:edgeworks/utils/dio/updateEnvironmentData.dart';

// Global
import '../../globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;
import 'package:edgeworks/utils/sharedPreferences/toggle.dart' as toggle;

/*
* name : SideControl View Page
* description : SideControl View Page
* writer : mark
* create date : 2022-02-15
* last update : 2022-02-18
* */

//Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// MQTT class
ConnectMqtt _connectMqtt = ConnectMqtt();

// GetX controller
final motorController = Get.put(MotorController());

// Update toggle data
UpdateSideTopEtcToggleData _updateMotorData = UpdateSideTopEtcToggleData();

// Dio
var dio = Dio();

// Define toggle variable
int? getToggleStatus;
int? allSideToggleInit;

// Define Text Size
var textSizedBox = Get.width * 1 / 5;



class SideMotorWidget extends StatefulWidget {
  const SideMotorWidget({Key? key}) : super(key: key);

  @override
  _SideMotorWidgetState createState() => _SideMotorWidgetState();
}

class _SideMotorWidgetState extends State<SideMotorWidget> {

  //shared preferences all side toggle status
  Future<Null> getSideSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getToggleStatus = prefs.getInt('allSideValue') ?? 0;
    print('## get all side value : $getToggleStatus');
    setState(() {
      allSideToggleInit = getToggleStatus;
    });
  }

  void initState() {
    super.initState();
    motorController.getSideMotorsData();
    getSideSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          _fromLTRBPadding(
            child: Container(
              decoration: _decoration(Color(0xff2E8953)),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: IgnorePointer(
                  ignoring:
                  motorController.sideMotorStatus.length == 0 ? true : false,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    // custom trailing icon widget
                    // trailing: Icon(_customTileExpanded
                    //     ? Icons.keyboard_arrow_up_rounded
                    //     : Icons.keyboard_arrow_down_rounded),
                    // onExpansionChanged: (bool expanded) {
                    //   setState(() {
                    //     _customTileExpanded = expanded;
                    //   });
                    // },
                    title: _edgeLeftPadding(
                      15,
                      child: Text('측창 개폐기 제어',
                          style: _textStyle(
                              Color(0xffFFFFFF), FontWeight.w500, 20)),
                    ),
                    children: <Widget>[
                      _topBottomPadding(
                        15,
                        15,
                        child: Column(
                          children: [
                            _allSideToggleSwitch(
                                '측창(전체)', 'side', 'test', 'sid'),
                            _sideControlSwitch()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  }

  // [전체 측창 제어]
  Widget _allSideToggleSwitch(
      String text, var positions, var userIds, var siteIds) {
    return _marginContainer(
      height: Get.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _edgeLeftPadding(20,
              child: SizedBox(
                width: textSizedBox,
                child: Text(text,
                    style:
                        _textStyle(Color(0xff222222), FontWeight.normal, 15)),
              )),
          _edgeRightPadding(
            10,
            child: ToggleSwitch(
              fontSize: 12,
              minWidth: 65.0,
              cornerRadius: 80.0,
              activeBgColors: [
                [Color(0xffe3fbed)],
                [Color(0xffFFD6D6)],
                [Color(0xfff2f2f2)]
              ],
              activeFgColor: Color(0xff222222),
              inactiveBgColor: Color(0xffFFFFFF),
              inactiveFgColor: Color(0xff222222),
              initialLabelIndex: getToggleStatus,
              totalSwitches: 3,
              labels: ['전체열림', '전체정지', '전체닫힘'],
              radiusStyle: true,
              onToggle: (value) async {
                getToggleStatus = value;
                String _switch = '';

                if (value == 0) {
                  _switch = 'open';
                  setState(() {
                    for (int i = 0;
                        i < motorController.sideMotorStatus.length;
                        i++,) {
                      motorController.sideMotorStatus[i] = 0;
                    }
                  });
                }
                if (value == 1) {
                  _switch = 'stop';
                  setState(() {
                    for (int i = 0;
                        i < motorController.sideMotorStatus.length;
                        i++,) {
                      motorController.sideMotorStatus[i] = 1;
                    }
                  });
                }
                if (value == 2) {
                  _switch = 'close';
                  setState(() {
                    for (int i = 0;
                        i < motorController.sideMotorStatus.length;
                        i++,) {
                      motorController.sideMotorStatus[i] = 2;
                    }
                  });
                }
                print('motor id는 : ${motorController.sideMotorId}');
                // mqtt
                _connectMqtt.setAll(
                    'did',
                    motorController.sideMotorId.length,
                    'dact',
                    _switch,
                    '/sf/$siteId/req/motor',
                    '/sf/$siteId/req/motor',
                    motorController.sideMotorId);
                // DB 변동
                _updateMotorData.updateAllMotorData(value, "side");
                // shared preferences
                toggle.saveAllSideToggle(value);
              },
            ),
          )
        ],
      ),
      decoration: _decorations(),
    );
  }

  // [측창] 개별 토글 제어
  Widget _sideControlSwitch() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: motorController.sideMotors.length,
        itemBuilder: (BuildContext context, int index) {
          return _marginContainer(
            height: Get.height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _edgeLeftPadding(20,
                    child: SizedBox(
                      width: textSizedBox,
                      child: ExpandableText(
                        "${motorController.sideMotorName[index]}", //${stream.sideMotors[0]['motor_name']
                        style: _textStyle(
                            Color(0xff222222), FontWeight.normal, 15),
                        maxLines: 2,
                        // expanded: true,
                        expandText: ' ',
                        // overflow: TextOverflow.fade,
                        // softWrap: true,
                      ),
                    )),
                _edgeRightPadding(
                  10,
                  child: ToggleSwitch(
                    fontSize: 12,
                    minWidth: 60.0,
                    cornerRadius: 80.0,
                    activeBgColors: [
                      [Color(0xffe3fbed)],
                      [Color(0xffFFD6D6)],
                      [Color(0xfff2f2f2)]
                    ],
                    activeFgColor: Color(0xff222222),
                    inactiveBgColor: Color(0xffFFFFFF),
                    inactiveFgColor: Color(0xff222222),
                    initialLabelIndex: motorController.sideMotorStatus[index],
                    // stream.topMotors[index],
                    totalSwitches: 3,
                    labels: ['열림', '정지', '닫힘'],
                    radiusStyle: true,
                    onToggle: (value) async {
                      String _switch = '';

                      if (value == 0) {
                        _switch = 'open';
                        setState(() {
                          motorController.sideMotorStatus[index] = 0;
                        });
                      }
                      if (value == 1) {
                        _switch = 'stop';
                        setState(() {
                          motorController.sideMotorStatus[index] = 1;
                        });
                      }
                      if (value == 2) {
                        _switch = 'close';
                        setState(() {
                          motorController.sideMotorStatus[index] = 2;
                        });
                      }
                      print(
                          '### Motor name index 뽑기 : ${motorController.sideMotors[0]['motor_name']}');
                      // MQTT 통신
                      _connectMqtt.setControl(
                          'did',
                          "${motorController.sideMotorId[index]}",
                          'dact',
                          _switch,
                          '/sf/$siteId/req/motor',
                          '/sf/$siteId/req/motor');
                      // DB 업데이트
                      _updateMotorData.updateSideTopMotorData(
                          "${motorController.sideMotorName[index]}",
                          "side",
                          "$value",
                          "side",
                          "${motorController.sideMotorId2[index]}");
                      // update를 하면 이름도 전부 update 됨 -> 해결 필요
                    },
                  ),
                )
              ],
            ),
            decoration: _decorations(),
          );
        });
  }
}

// Text Style Widget
TextStyle _textStyle(dynamic _color, dynamic _weight, double _size) {
  return TextStyle(color: _color, fontWeight: _weight, fontSize: _size);
}

// Decoration (with box shadow)
BoxDecoration _decoration(dynamic color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2,
        offset: Offset(3, 5), // changes position of shadow
      ),
    ],
  );
}

// Decoration(without box shadow)
BoxDecoration _decorations() {
  return BoxDecoration(
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(20),
  );
}

// Padding Widget
Padding _fromLTRBPadding({child}) {
  return Padding(padding: new EdgeInsets.fromLTRB(15, 10, 15, 5), child: child);
}

Padding _edgeLeftPadding(double left, {child}) {
  return Padding(padding: new EdgeInsets.only(left: left), child: child);
}

Padding _edgeRightPadding(double right, {child}) {
  return Padding(padding: new EdgeInsets.only(right: right), child: child);
}

Padding _topBottomPadding(double top, double bottom, {child}) {
  return Padding(
      padding: new EdgeInsets.only(top: top, bottom: bottom), child: child);
}

Container _marginContainer({child, dynamic height, decoration}) {
  return Container(
    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
    height: height,
    child: child,
    decoration: decoration,
  );
}
