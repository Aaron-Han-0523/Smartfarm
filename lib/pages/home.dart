// necessary to build app
import 'package:edgeworks/data/get_data.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// dio
import 'package:dio/dio.dart';
// env
import 'package:flutter_dotenv/flutter_dotenv.dart';
// mqtt
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// global
import '../globals/stream.dart' as stream;
import "package:edgeworks/globals/checkUser.dart" as edgeworks;
import '../globals/siteConfig.dart' as sites;

/*
* name : Home (get Data page)
* description : get Data
* writer : sherry
* create date : 2022-01-10
* last update : 2022-02-03
* */

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
// var siteId = '${stream.siteId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// get all data
GetAllData _getAllData = GetAllData();

// mqtt
int clientPort = 1883;
var setSubTopic = '/sf/$siteId/res/cfg';
var setPubTopic = '/sf/$siteId/req/cfg';

// dio APIs
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // getData();
    // Future.delayed(const Duration(milliseconds: 500), () async {
    //   _getAllData.getSiteData(userId);
    //   _getAllData.putFcmData(userId);
    //   await Get.offAllNamed('/sensor');
    //   // getData();
    // });
    getData();
    super.initState();
  }

  // getData -----------------------------> 작업 진행 중
  Future<dynamic> getData() async {
    if (mounted) {
      _getAllData.getSiteData(userId);
      _getAllData.putFcmData(userId);
   }
    // await Get.offAllNamed('/sensor');
    return true;
  }

  Widget build(BuildContext context) {
    return Opacity(opacity: 0);
  }
}
