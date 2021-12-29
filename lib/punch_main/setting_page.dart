import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/*
* name : PageThree
* description : punch issue three page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
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
        title: const Text('Farm in Earth'),
      ),
      body: Container(
        child: Column(
          children: [
            Text('경보 설정'),
            _swichWidget('경보 활성화'),
            _tempFormField('고온 경보 (°C)', _highTextEditController),
            _tempFormField('저온 경보 (°C)', _lowTextEditController),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 0,
              color: Colors.black,
            ),
            Text('관수 타이머 설정'),
            _dropDownButtons('타이머 시간'),
            InkWell(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.logout),
              ),
              onTap: () {
                Get.toNamed('/sensor'); // logout 되지는 않음
              },
            )
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
        Text(name),
        FlutterSwitch(
          activeColor: Colors.green,
          width: 40.0,
          height: 20.0,
          valueFontSize: 10.0,
          toggleSize: 10.0,
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
        SizedBox(width: Get.width * 1 / 3.9, child: Text(title)),
        SizedBox(
          width: Get.width * 2.8 / 5,
          height: Get.height * 2.1 / 25,
          child: TextFormField(
            style: TextStyle(fontSize: 17),
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

  String dropdownValue = '30분';
  Widget _dropDownButtons(var name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
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
}
