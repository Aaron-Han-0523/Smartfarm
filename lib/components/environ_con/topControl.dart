// Necessary to build app
import 'package:dio/dio.dart';
import 'package:edgeworks/utils/dio/updateEnvironmentData.dart';
import 'package:edgeworks/utils/getX_controller/motorController.dart';
import 'package:edgeworks/utils/mqtt/mqtt.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

// GetX  controller
import 'package:edgeworks/utils/getX_controller/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

// Global
import '../../globals/stream.dart' as stream;
import 'package:edgeworks/globals/toggle.dart' as toggle;
import 'package:edgeworks/globals/checkUser.dart' as edgeworks;

//Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// MQTT class
ConnectMqtt _connectMqtt = ConnectMqtt();

// toggle data
UpdateSideTopEtcToggleData _updateMotorData = UpdateSideTopEtcToggleData();

// Dio
var dio = Dio();

// GetX
final getxController = Get.put(MotorController());

var textSizedBox = Get.width * 1 / 5;

// stream
List motorName = stream.top_motor_name;

// define toggle variable
int? getToggleStatus;
int? getTopToggleStatus;
int? allSideToggleInit;
int? allTopToggleInit;

// GetX
// final getxController = Get.put(MotorController());

Future<void> _updateAllMotorData(var motorAction, var updateMotorType) async {
  var params = {
    'motor_action': motorAction,
  };
  var response = await dio.put(
      '$url/$userId/site/$siteId/controls/$updateMotorType/motors',
      data: params);
  print('### [environment page] 사이드 전체 모터 타입 변경 완료 : $response');
}


class TopMotorWidget extends StatefulWidget {
  const TopMotorWidget({Key? key}) : super(key: key);

  @override
  _TopMotorWidgetState createState() => _TopMotorWidgetState();
}

class _TopMotorWidgetState extends State<TopMotorWidget> {

  //shared preferences top toggle status
  Future<Null> getTopSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getTopToggleStatus = prefs.getInt('allTopValue') ?? 0;
    print('## get all top value : $getTopToggleStatus');
    setState(() {
      allTopToggleInit = getTopToggleStatus;
    });
  }

  @override
  void initState() {
    getxController.getTopMotorsData();
    getTopSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _fromLTRBPadding(
        child: Container(
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: IgnorePointer(
              ignoring: getxController.topMotors.length == 0 ? true : false,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                title: _edgeLeftPadding(
                  15,
                  child: Text('천창 개폐기 제어',
                      style: _textStyle(Color(0xffFFFFFF), FontWeight.w500, 20)),
                ),
                children: <Widget>[
                  _topBottomPadding(
                    15,
                    15,
                    child: Column(
                      children: [
                        _allTopToggleSwitch('천창(전체)', 'top', 'test', 'sid'),
                        _topControlSwitch()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          decoration: _decoration(Color(0xff2E8953)),
        ),
      );
    });
  }

  //천장 개폐기 제어 전체
  Widget _allTopToggleSwitch(
      String text, var positions, var userIds, var siteIds) {
    return _marginContainer(
      height: Get.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _edgeLeftPadding(20,
              child: Text(text,
                  style: _textStyle(Color(0xff222222), FontWeight.normal, 15))),
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
              initialLabelIndex: getTopToggleStatus, // 상태 반영 안돼서 확인 필요함
              totalSwitches: 3,
              labels: ['전체열림', '전체정지', '전체닫힘'],
              radiusStyle: true,
              onToggle: (value) async {
                getTopToggleStatus = value;
                String _switch = '';

                if (value == 0) {
                  setState(() {
                    for (int i = 0; i < getxController.topMotorStatus.length; i++,) {
                      getxController.topMotorStatus[i] = 0;
                    }
                  });
                  _switch = 'open';
                }
                if (value == 1) {
                  _switch = 'stop';
                  setState(() {
                    for (int i = 0; i < getxController.topMotorStatus.length; i++,) {
                      getxController.topMotorStatus[i] = 1;
                    }
                  });
                }
                if (value == 2) {
                  _switch = 'close';
                  setState(() {
                    for (int i = 0; i < getxController.topMotorStatus.length; i++,) {
                      getxController.topMotorStatus[i] = 2;
                    }
                  });
                }
                // mqtt
                _connectMqtt.setAll(
                    'did',
                    getxController.topMotorStatus.length,
                    'dact',
                    _switch,
                    '/sf/$siteId/req/motor',
                    '/sf/$siteId/req/motor',
                    getxController.topMotorId);
                // DB 변동
                _updateAllMotorData(value, "top");
                // shared preferencs
                toggle.saveAllTopToggle(value);
              },
            ),
          )
        ],
      ),
      decoration: _decorations(),
    );
  }

  // 천창 개폐기 개별 제어
  Widget _topControlSwitch() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: getxController.topMotorStatus.length,
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
                        "${getxController.topMotorName[index]}", //${stream.sideMotors[0]['motor_name']
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
                    initialLabelIndex: getxController.topMotorStatus[index],
                    // stream.topMotors[index],
                    totalSwitches: 3,
                    labels: ['열림', '정지', '닫힘'],
                    radiusStyle: true,
                    onToggle: (value) async {
                      String _switch = '';

                      if (value == 0) {
                        _switch = 'open';
                        getxController.topMotorStatus[index] = 0;
                      }
                      if (value == 1) {
                        _switch = 'stop';
                        getxController.topMotorStatus[index] = 1;
                      }
                      if (value == 2) {
                        _switch = 'close';
                        getxController.topMotorStatus[index] = 2;
                      }
                      print(
                          '### Motor${index + 1} stream index는 : ${getxController.topMotorStatus[index]}');
                      // mqtt 업데이트
                      _connectMqtt.setControl(
                          'did',
                          "${getxController.topMotorId[index]}",
                          'dact',
                          _switch,
                          '/sf/$siteId/req/motor',
                          '/sf/$siteId/req/motor');
                      // DB 업데이트
                      _updateMotorData.updateSideTopMotorData(
                          "${getxController.topMotorName[index]}",
                          "top",
                          "$value",
                          "top",
                      "${getxController.topMotorId2[index]}");
                      // _updateToggleData("${getxController.topMotorName[index]}", "top",
                      //     "$value", "top", "${getxController.topMotorId2[index]}");
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

// text style widget
TextStyle _textStyle(dynamic _color, dynamic _weight, double _size) {
  return TextStyle(color: _color, fontWeight: _weight, fontSize: _size);
}

// decoration (with box shadow)
BoxDecoration _decoration(dynamic color) {
  return BoxDecoration(
    color: color,
    // color: Color(0xffFFFFFF),
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

// decoration(without box shadow)
BoxDecoration _decorations() {
  return BoxDecoration(
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(20),
  );
}


// padding widget
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