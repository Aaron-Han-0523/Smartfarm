// Necessary to build app
import 'package:dio/dio.dart';
import 'package:edgeworks/utils/dio/updateEnvironmentData.dart';
import 'package:edgeworks/utils/getX_controller/motorController.dart';
import 'package:edgeworks/utils/mqtt/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

// GetX  controller
import 'package:edgeworks/utils/getX_controller/controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

// Global
import '../../globals/stream.dart' as stream;
import 'package:edgeworks/globals/checkUser.dart' as edgeworks;

//Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// MQTT class
ConnectMqtt _connectMqtt = ConnectMqtt();

// Update toggle data
UpdateSideTopEtcToggleData _updatetoggleData = UpdateSideTopEtcToggleData();

// Dio
var dio = Dio();

// GetX
final getxController = Get.put(MotorController());



class EtcMotorWidget extends StatefulWidget {
  const EtcMotorWidget({Key? key}) : super(key: key);

  @override
  _EtcMotorWidgetState createState() => _EtcMotorWidgetState();
}

class _EtcMotorWidgetState extends State<EtcMotorWidget> {
  void initState() {
    getxController.getEtcMotorData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _fromLTRBPadding(
      child: Container(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: IgnorePointer(
            ignoring: getxController.etcMotors.length == 0 ? true : false,
            child: ExpansionTile(
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: _edgeLeftPadding(
                15,
                child: Text('기타제어',
                    style: _textStyle(Color(0xffFFFFFF), FontWeight.w500, 20)),
              ),
              children: <Widget>[
                _topBottomPadding(
                  15,
                  15,
                  child: Column(
                    children: [
                      _etcSwitch(),
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
  }

  // 기타제어
  Widget _etcSwitch() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: getxController.etcMotors.length,
        itemBuilder: (BuildContext context, int index) {
          return _marginContainer(
            height: Get.height * 0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _edgeLeftPadding(20,
                    child: Text("${getxController.etcMotorName[index]}",
                        style: _textStyle(
                            Color(0xff222222), FontWeight.normal, 15))),
                _edgeRightPadding(
                  10,
                  child: ToggleSwitch(
                    fontSize: 12,
                    minWidth: 60.0,
                    cornerRadius: 80.0,
                    activeBgColors: [
                      [Color(0xffe3fbed)],
                      [Color(0xfff2f2f2)]
                    ],
                    activeFgColor: Color(0xff222222),
                    inactiveBgColor: Color(0xffFFFFFF),
                    inactiveFgColor: Color(0xff222222),
                    initialLabelIndex: getxController.etcMotorStatus[index],
                    // statusIndex == 0 ? 1 : 0,
                    totalSwitches: 2,
                    labels: ['ON', 'OFF'],
                    radiusStyle: true,
                    onToggle: (value) async {
                      String _switch = '';

                      if (value == 0) {
                        _switch = 'open';
                      }
                      if (value == 1) {
                        _switch = 'stop';
                      }
                      // MQTT 통신
                      _connectMqtt.setControl(
                          'did',
                          "${getxController.etcMotorId[index]}",
                          'dact',
                          _switch,
                          '/sf/$siteId/req/motor',
                          '/sf/$siteId/req/motor');
                      //DB 업데이트
                      _updatetoggleData.updateEtcMotorData(
                          "$value", "${getxController.etcMotorId2[index]}");
                    },
                  ),
                )
              ],
            ),
            decoration: _decorations(),
          );
        });
  }

  // Text style widget
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

  // Decoration widget (without box shadow)
  BoxDecoration _decorations() {
    return BoxDecoration(
      color: Color(0xffFFFFFF),
      borderRadius: BorderRadius.circular(20),
    );
  }
}

// Padding widget
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