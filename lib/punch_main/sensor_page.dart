import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plms_start/ontap_other/list_ontap_other.dart';
import 'package:plms_start/pages/components/list_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../globals/login.dart' as login;
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
            HeaderTile(),
            PersonTile(new Person(150, "name", true)),
          ],
        ));
  }
}

class HeaderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
          "https://t1.daumcdn.net/thumb/R720x0/?fname=https://t1.daumcdn.net/brunch/service/user/1YN0/image/ak-gRe29XA2HXzvSBowU7Tl7LFE.png"),
    );
  }
}

class PersonTile extends StatelessWidget {
  PersonTile(this._person);

  final Person _person;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(_person.name),
      subtitle: Text("${_person.age}세"),
      trailing: PersonHandIcon(_person.isLeftHand),
    );
  }
}

class PersonHandIcon extends StatelessWidget {
  PersonHandIcon(this._isLeftHand);

  final bool _isLeftHand;

  @override
  Widget build(BuildContext context) {
    if (_isLeftHand)
      return Icon(Icons.arrow_left);
    else
      return Icon(Icons.arrow_right);
  }
}

class Person {
  int age;
  String name;
  bool isLeftHand;

  Person(this.age, this.name, this.isLeftHand);
}
