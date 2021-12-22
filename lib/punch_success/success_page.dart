import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
// import 'package:plms_start/pages/utils/button_confirm.dart';
import 'package:plms_start/pages/utils/button_success.dart';
import 'package:plms_start/pages/utils/header_issue.dart';

// import 'components/screenList.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var radius = Radius.circular(10);
    return Scaffold(
      body: Column(
        children: [
          Header(
            title: "title",
          ),
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Color(0xFFE6E6E6),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffB7C5B9),
                          borderRadius: BorderRadius.only(
                              topLeft: radius, bottomLeft: radius),
                        ),
                        height: MediaQuery.of(context).size.height * 2.3 / 7,
                        width: Get.width * 1 / 50,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 2.3 / 7,
                        width: Get.width - Get.width * 0.83 / 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: radius, bottomRight: radius),
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
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Punch Issue Successfully Created.",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Do you want to duplicate this issue with same condition?",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "All conditins you created will be duplicated except the attachments.",
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SuccessButton(
                                  buttonname1: "No", buttonname2: "Yes")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
