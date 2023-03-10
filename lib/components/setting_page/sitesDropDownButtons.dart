// ** SITE DROP DOWN BUTTONS WIDGET **

// Necessary to build app
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Dio
import 'package:dio/dio.dart';

// global
import 'package:edgeworks/globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;



// Api's
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// dio APIs
// var options = BaseOptions(
//   baseUrl: '$url',
//   connectTimeout: 5000,
//   receiveTimeout: 3000,
// );
// Dio dio = Dio(options);
Dio dio = Dio();

// siteDropdown button global variable
String sitesDropdownValue = stream.sitesDropdownValue == ''
    ? '${stream.siteNames[0]}'
    : stream.sitesDropdownValue;


class SitesDropDownButtons extends StatefulWidget {
  final String name;
  const SitesDropDownButtons({Key? key, required this.name}) : super(key: key);

  @override
  State<SitesDropDownButtons> createState() => _SitesDropDownButtonsState();
}

class _SitesDropDownButtonsState extends State<SitesDropDownButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffFFFFFF),
      height: Get.height * 0.08,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(widget.name,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: DropdownButton<String>(
              value: sitesDropdownValue,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Colors.black, size: 30),
              style: const TextStyle(color: Colors.black54),
              underline: Container(
                height: 2,
                color: Colors.black26,
              ),
              onChanged: (String? newValue) {
                if (newValue != sitesDropdownValue) {
                  showAlertDialog(context, newValue);
                }
              },
              items: stream.siteNames
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.normal,
                        fontSize: 13),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ????????? ?????? ?????? ??? ?????? ??????
  showAlertDialog(BuildContext context, var siteName) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("??????"),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("??????"),
      onPressed: () {
        setState(() {
          stream.sitesDropdownValue = siteName;
          print("[setting page] siteName??? $siteName");
          getSiteId(stream.sitesDropdownValue);
        });
      },
    );
  }

  // site name??? ?????? site id ????????????
  Future<dynamic> getSiteId(var siteNames) async {
    print('##### [SettingPage] siteNames???  : ${siteNames}');
    final getSiteId = await dio.post('$url/$userId/sites/$siteNames');
    stream.siteId = getSiteId.data;
    print('##### [SettingPage] Site Id???  : ${stream.siteId}');
    Get.offAllNamed('/home');
  }
}
