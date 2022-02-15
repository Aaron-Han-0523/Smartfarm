import 'package:edgeworks/components/soilController_page/switchToggles.dart';
import 'package:edgeworks/utils/getX_controller/soilController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;

var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';
final controller = Get.put(SoilController());

class ValvesControlls extends StatelessWidget {
  const ValvesControlls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(children: [
        _fromLTRBPadding(
          child: Container(
            decoration: _decoration(Color(0xff2E8953)),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: IgnorePointer(
                ignoring: controller.valves.length == 0 ? true : false,
                child: ExpansionTile(
                  title: _edgeLeftPadding(
                    15,
                    child: Text('밸브 제어',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffFFFFFF))),
                  ),
                  textColor: Colors.white,
                  collapsedTextColor: Colors.white,
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  // tilePadding: EdgeInsets.all(8.0),
                  children: <Widget>[
                    _topBottomPadding(
                      15,
                      15,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: controller.valveStatus.length,
                          itemBuilder: (BuildContext context, var index) {
                            return SwitchToggles(
                                index: index,
                                text: '${controller.valve_name[index]}',
                                streamStatus: controller.valveStatus,
                                action: 'valve',
                                type: 'valve_${index + 1}',
                                typeIdText: 'valve_id',
                                typeActionText: 'valve_action',
                                putUrl:
                                    '$url/$userId/site/$siteId/controls/valves/valve_${index + 1}');
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// BoxDecoration (with box shadow)
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

// Padding widget
Padding _fromLTRBPadding({child}) {
  return Padding(padding: new EdgeInsets.fromLTRB(15, 10, 15, 5), child: child);
}

Padding _edgeLeftPadding(double left, {child}) {
  return Padding(padding: new EdgeInsets.only(left: left), child: child);
}

Padding _topBottomPadding(double top, double bottom, {child}) {
  return Padding(
      padding: new EdgeInsets.only(top: top, bottom: bottom), child: child);
}
