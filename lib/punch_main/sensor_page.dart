import 'package:flutter/material.dart';

/*
* name : ListOpen Page
* description : open data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class SensorPage extends StatefulWidget {
  SensorPage({Key? key}) : super(key: key);

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  // final List data = login.openList;

  // String id = Get.arguments[4];
  // String password = Get.arguments[5];
  // String userName = Get.arguments[6];
  // String email = Get.arguments[7];
  // String company = Get.arguments[8];
  // String authority = Get.arguments[9];

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Container(
        color: Color(0xFFE6E6E6),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            MyAccordian(),
            MyAccordian2(),
          ],
        ));
  }
}

class MyAccordian extends StatefulWidget {
  const MyAccordian({Key? key}) : super(key: key);

  @override
  State<MyAccordian> createState() => _MyAccordianState();
}

class _MyAccordianState extends State<MyAccordian> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          initiallyExpanded: true,
          title: Text('외부환경'),
          children: <Widget>[
            Row(children: [
              _cards('외부온도', '12.5', true),
              _cards('외부습도', '12.5', true)
            ]),
            Row(children: [
              _cards('강우', '12.5', false),
              _cards('풍향', '12.5', true)
            ]),
            Row(children: [
              _cards('풍속', '12.5', true),
              _cards('일사량', '12.5', true)
            ])
          ],
        ),
      ],
    );
  }
}

class MyAccordian2 extends StatefulWidget {
  const MyAccordian2({Key? key}) : super(key: key);

  @override
  State<MyAccordian2> createState() => _MyAccordian2State();
}

class _MyAccordian2State extends State<MyAccordian2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text('내부환경'),
          children: <Widget>[
            Row(children: [
              _cards('내부온도', '12.5', true),
              _cards('내부습도', '12.5', true)
            ]),
            Row(children: [
              _cards('토양온도', '12.5', true),
              _cards('토양온도', '12.5', true)
            ]),
            Row(children: [_cards('토양건조도', '12.5', false)])
          ],
        ),
      ],
    );
  }
}

Widget _cards(var title, var subtitle, bool visibles) {
  return Visibility(
    visible: visibles,
    child: Container(
        height: 70,
        width: 90,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            Column(children: [
              Text(title),
              Text(subtitle),
            ]),
            Icon(Icons.wb_sunny)
          ],
        )),
  );
}
