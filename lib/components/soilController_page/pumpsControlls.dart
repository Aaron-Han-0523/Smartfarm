//necessary to build app
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

//GetX
import 'package:edgeworks/components/soilController_page/switchToggles.dart';
import 'package:edgeworks/utils/getX_controller/soilController.dart';

//globals
import '../../globals/stream.dart' as stream;
import "../../globals/checkUser.dart" as edgeworks;

/*
* name : Soil pumps class
* description : Soil pumps class
* writer : Walter
* create date : 2022-02-15
* last update : 2022-02-15
* */

var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';
final controller = Get.put(SoilController());

class PumpsControlls extends StatelessWidget {
  const PumpsControlls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(children: [
        _fromLTRBPadding(
          child: Container(
            decoration: _decoration(Color(0xff2E8953)),
            child: Column(
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: IgnorePointer(
                    ignoring: controller.pumps.length == 0 ? true : false,
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: _edgeLeftPadding(
                        15,
                        child: Text('관수 펌프 제어',
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
                              itemCount: controller.pumpStatus.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SwitchToggles(
                                  index: index,
                                  text: '${controller.pump_name[index]}',
                                  streamStatus: controller.pumpStatus,
                                  action: 'pump',
                                  type: 'pump_${index + 1}',
                                  typeIdText: 'pump_id',
                                  typeActionText: 'pump_action',
                                  putUrl:
                                      '$url/$userId/site/$siteId/controls/pumps/pump_${index + 1}',
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ],
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
