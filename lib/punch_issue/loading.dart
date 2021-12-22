import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:plms_start/punch_issue/punch_issue.dart';
import '../globals/issue.dart' as issue;
/*
* name : Loading
* description : Loading page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // var api = dotenv.env['PHONE_IP'];
  var api = dotenv.env['EMUL_IP'];

  @override
  void initState() {
    issue.categoryList = [];
    issue.systemsList = [];
    issue.subsystemList = [];
    issue.disciplineList = [];
    issue.unitList = [];
    issue.areaList = [];
    issue.deptList = [];

    test();
    super.initState();
  }

  // get data
  Future<dynamic> test() async {
    var categoryResponse = await http.get(
      Uri.parse(
          // 'http://10.0.2.2:5000/summury/category/',
          "$api/summury/category/"),
    );

    var category = jsonDecode(categoryResponse.body);
    print(category.runtimeType);
    print(category[0]['category']);
    int len = category.length;
    // dispose();
    if (mounted)
      this.setState(() {
        for (int i = 0; i < len; i++) {
          issue.categoryList += [category[i]['category']];
          // categoryNameList += [category[i]['categoryName']];
        }
      });
///////////////////////////////
    var systemsResponse = await http.get(
      Uri.parse(
          // 'http://10.0.2.2:5000/summury/systems/',
          "$api/summury/systems/"),
    );

    var systems = jsonDecode(systemsResponse.body);
    print(systems[0]['systems']);
    int len2 = systems.length;
    // dispose();
    if (mounted)
      this.setState(() {
        for (int i = 0; i < len2; i++) {
          issue.systemsList += [systems[i]['systemID']];
          // systemsNameList += [systems[i]['systemName']];
        }
      });
/////////////////////////////
    var subsystemResponse = await http.get(
      Uri.parse(
          // 'http://10.0.2.2:5000/summury/subsystem/',
          "$api/summury/subsystem/"),
    );

    var subsystem = jsonDecode(subsystemResponse.body);
    print(subsystem[0]['subsystem']);
    int len3 = subsystem.length;
    // dispose();
    if (mounted)
      this.setState(() {
        for (int i = 0; i < len3; i++) {
          issue.subsystemList += [subsystem[i]['subsystem']];
          // subsystemNameList += [subsystem[i]['subsystemName']];
        }
      });
////////////////////////
    var disciplineResponse = await http.get(
      Uri.parse(
          // 'http://10.0.2.2:5000/summury/discipline/',
          "$api/summury/discipline/"),
    );

    var discipline = jsonDecode(disciplineResponse.body);
    print(discipline[0]['discipline']);
    int len4 = discipline.length;
    // dispose();
    if (mounted)
      this.setState(() {
        for (int i = 0; i < len4; i++) {
          issue.disciplineList += [discipline[i]['discipline']];
          // disciplineNameList += [discipline[i]['disciplineName']];
        }
      });

    var unitResponse = await http.get(
      Uri.parse(
          // 'http://10.0.2.2:5000/summury/discipline/',
          "$api/summury/unit/"),
    );

    var unit = jsonDecode(unitResponse.body);
    print(unit[0]['unit']);
    int len5 = unit.length;
    // dispose();
    if (mounted)
      this.setState(() {
        for (int i = 0; i < len5; i++) {
          issue.unitList += [unit[i]['unit']];
          // unitNameList += [unit[i]['unitName']];
        }
      });

    var areaResponse = await http.get(
      Uri.parse(
          // 'http://10.0.2.2:5000/summury/discipline/',
          "$api/summury/area/"),
    );

    var area = jsonDecode(areaResponse.body);
    print(unit[0]['area']);
    int len6 = area.length;
    // dispose();
    if (mounted)
      this.setState(() {
        for (int i = 0; i < len6; i++) {
          issue.areaList += [area[i]['area']];
          // areaNameList += [area[i]['areaName']];
        }
      });

    var departmentResponse = await http.get(
      Uri.parse(
          // 'http://10.0.2.2:5000/summury/discipline/',
          "$api/summury/department/"),
    );

    var department = jsonDecode(departmentResponse.body);
    print(department[0]['department']);
    int len7 = department.length;
    // dispose();
    if (mounted)
      this.setState(() {
        for (int i = 0; i < len7; i++) {
          issue.deptList += [department[i]['department']];
          // deptNameList += [department[i]['deptName']];
        }
      });
    print(issue.categoryList);
    Get.off(
      () => PunchScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 1);
  }
}
