import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:get/get.dart';
import 'package:plms_start/dio/logout_dio.dart';
import '../globals/stream.dart' as stream;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/*
* name : PageThree
* description : punch issue three page
* writer : walter/mark
* create date : 2021-09-30
* last update : 2021-01-06
* */

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Logout _logout = Logout();
  final _highTextEditController = TextEditingController();
  final _lowTextEditController = TextEditingController();

  @override
  void dispose() {
    _highTextEditController.dispose();
    _lowTextEditController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            // 로그아웃
            child: InkWell(
              child: CircleAvatar(
                child: Icon(Icons.logout),
              ),
              onTap: () {
                _logout.logout();
                // Get.offAllNamed('/'); // 로그아웃 연결 필요함
              },
            ),
          )
        ],
        title: Align(
          alignment: Alignment.topLeft,
          child: Column(children: [
            Text(
              'Farm in Earth',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(stream.sitesDropdownValue,
                    style: TextStyle(color: Colors.black, fontSize: 16))),
          ]),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 15, left: 15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('경보 설정',
                      style: TextStyle(fontSize: 13, color: Colors.black54))),
            ),
            _swichWidget('경보 활성화'),
            _tempFormField('고온 경보 (°C)', _highTextEditController),
            _tempFormField('저온 경보 (°C)', _lowTextEditController),
            const Divider(
              height: 10,
              thickness: 2,
              indent: 0,
              endIndent: 0,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '관수 타이머 설정',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  )),
            ),
            _timerDropDownButtons('타이머 시간'),
            _sitesDropDownButtons('사이트 설정'),
          ],
        ),
      ),
    );
  }

  bool status = true;
  Widget _swichWidget(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: FlutterSwitch(
            activeColor: Colors.green,
            width: Get.width * 0.2,
            height: Get.height * 0.05,
            valueFontSize: 20.0,
            toggleSize: 20.0,
            value: status,
            borderRadius: 30.0,
            // padding: 3.0,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                status = val;
                print('$name : $val');
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _tempFormField(String title, var controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: Get.width * 1 / 3.9,
            child: Text(title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54))),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            controller: controller,
            onChanged: (text) {
              setState(() {});
              print('$title : $text');
            },
          ),
        ),
      ],
    );
  }

  String timerDropdownValue = '30분';
  Widget _timerDropDownButtons(var name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: DropdownButton<String>(
            value: timerDropdownValue,
            icon: Column(
                children : [
             const Icon(Icons.arrow_drop_up, color: Colors.black, size: 30),
              const Icon(Icons.arrow_drop_down, color: Colors.black, size: 30)
            ]
            ),
            elevation: 16,
            style: const TextStyle(color: Colors.black54),
            underline: Container(
              height: 2,
              width: 15,
              color: Colors.black26,
            ),
            onChanged: (String? newValue) {
              setState(() {
                timerDropdownValue = newValue!;
                print('$name : $newValue');
              });
            },
            items: <String>[
              '30분',
              '1시간',
              '1시간 30분',
              '2시간',
              '2시간 30분',
              '3시간',
              '3시간 30분',
              '4시간'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String sitesDropdownValue =
      stream.sitesDropdownValue == '' ? 'EdgeWorks' : stream.sitesDropdownValue;
  Widget _sitesDropDownButtons(var name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: DropdownButton<String>(
            value: sitesDropdownValue,
            icon: Column(
                children : [
                  const Icon(Icons.arrow_drop_up, color: Colors.black, size: 30),
                  const Icon(Icons.arrow_drop_down, color: Colors.black, size: 30)
                ]
            ),
            elevation: 16,
            style: const TextStyle(color: Colors.black54),
            underline: Container(
              height: 2,
              color: Colors.black26,
            ),
            onChanged: (String? newValue) {
              setState(() {
                sitesDropdownValue = newValue!;
                print('$name : $newValue');
                stream.sitesDropdownValue = sitesDropdownValue;
              });
            },
            items: <String>[
              'EdgeWorks',
              'Jsoftware',
              'smartFarm',
              'Project',
              'Nodejs',
              'Flutter',
              'MySQL',
              'AWS'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
