import 'package:dio/dio.dart';
import 'package:edgeworks/utils/mqtt/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// dio APIs
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

// MQTT
ConnectMqtt _connectMqtt = ConnectMqtt();
String statusText = "Status Text";
bool isConnected = false;
final MqttServerClient client = MqttServerClient('14.46.231.48', '');

class SwitchToggles extends StatefulWidget {
  final dynamic index;
  final dynamic text;
  final dynamic streamStatus;
  final dynamic action;
  final dynamic type;
  final dynamic typeIdText;
  final dynamic typeActionText;
  final dynamic putUrl;
  const SwitchToggles({
    Key? key,
    required this.index,
    required this.text,
    required this.streamStatus,
    required this.action,
    required this.type,
    required this.typeIdText,
    required this.typeActionText,
    required this.putUrl,
  }) : super(key: key);

  @override
  State<SwitchToggles> createState() => _SwitchTogglesState();
}

class _SwitchTogglesState extends State<SwitchToggles> {
  @override
  Widget build(BuildContext context) {
    return _marginContainer(
      height: Get.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _edgeLeftPadding(
            20,
            child: Text(widget.text,
                style: TextStyle(
                    color: Color(0xff222222),
                    fontSize: 15,
                    fontWeight: FontWeight.normal)),
          ),
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
              initialLabelIndex: widget.streamStatus[widget.index],
              // streamStatus[index] == 1 ? 1 : 0,
              totalSwitches: 2,
              labels: ['ON', 'OFF'],
              radiusStyle: true,
              onToggle: (value) async {
                String switchStatus = '';

                if (value == 0) {
                  switchStatus = 'on';
                  widget.streamStatus[widget.index] = 0;
                } else if (value == 1) {
                  switchStatus = 'off';
                  widget.streamStatus[widget.index] = 1;
                }
                var typeId = widget.type;
                _connectMqtt.setControl(
                    'did',
                    "${widget.index + 1}",
                    'dact',
                    switchStatus,
                    '/sf/$siteId/req/${widget.action}',
                    '/sf/$siteId/req/${widget.action}');
                var data = {
                  'uid': userId,
                  'sid': siteId,
                  widget.typeIdText: typeId,
                  widget.typeActionText: value,
                };
                final putType = await dio.put(widget.putUrl, data: data);
                print('[soilControl page] 성공 여부 확인 $putType');
                // 데이터 업데이트 시 결과1/ 업데이트가 이미 되어있는 상태일 경우 0
              },
            ),
          ),
        ],
      ),
      decoration: _decorations(),
    );
  }
}

// BoxDecoration widget (without box shadow)
BoxDecoration _decorations() {
  return BoxDecoration(
    color: Color(0xffFFFFFF),
    borderRadius: BorderRadius.circular(20),
  );
}

Padding _edgeLeftPadding(double left, {child}) {
  return Padding(padding: new EdgeInsets.only(left: left), child: child);
}

Padding _edgeRightPadding(double right, {child}) {
  return Padding(padding: new EdgeInsets.only(right: right), child: child);
}

Container _marginContainer({child, dynamic height, decoration}) {
  return Container(
    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
    height: height,
    child: child,
    decoration: decoration,
  );
}
