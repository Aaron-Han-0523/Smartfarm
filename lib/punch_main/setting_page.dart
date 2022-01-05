import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:get/get.dart';
import '../globals/stream.dart' as stream;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/*
* name : PageThree
* description : punch issue three page
* writer : walter
* create date : 2021-09-30
* last update : 2021-12-29
* */

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
          InkWell(
            child: CircleAvatar(
              child: Icon(Icons.logout),
            ),
            onTap: () {
              Get.offAllNamed('/'); // 로그아웃 연결 필요함
            },
          )
        ],
        title: Align(
          alignment: Alignment.topLeft,
          child: Column(children: [
            Text(
              'Farm in Earth',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(stream.sitesDropdownValue,
                    style: TextStyle(color: Colors.black, fontSize: 18))),
          ]),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, bottom: 15, top: 10),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Text('경보 설정',
                    style: TextStyle(fontSize: 15, color: Colors.black54))),
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
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '관수 타이머 설정',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                )),
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
        FlutterSwitch(
          activeColor: Colors.green,
          width: 70.0,
          height: 40.0,
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
        DropdownButton<String>(
          value: timerDropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
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
      ],
    );
  }

  String sitesDropdownValue = 'EdgeWorks';
  Widget _sitesDropDownButtons(var name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
        DropdownButton<String>(
          value: sitesDropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
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
      ],
    );
  }
}
