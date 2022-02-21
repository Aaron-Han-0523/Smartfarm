// ** GET DATA PAGE **

// Necessary to build app
import 'package:edgeworks/utils/dio/getSiteIdFcmData.dart';
import 'package:flutter/material.dart';

// Dio
import 'package:dio/dio.dart';

// Env
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Global
import 'package:edgeworks/globals/stream.dart' as stream;
import 'package:edgeworks/utils/sharedPreferences/checkUser.dart' as edgeworks;

/*
* name : Home (get Data page)
* description : get Data
* writer : sherry
* create date : 2022-01-10
* last update : 2022-02-18
* */

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = '${edgeworks.checkUserId}';
var siteId = stream.siteId == '' ? 'e0000001' : '${stream.siteId}';

// get all data
GetSiteFcmData _getSiteFcmData = GetSiteFcmData();

// mqtt
// int clientPort = 1883;
int clientPort = int.parse('${dotenv.env['MQTT_PORT']}');
var setSubTopic = '/sf/$siteId/res/cfg';
var setPubTopic = '/sf/$siteId/req/cfg';

// Dio
Dio dio = Dio();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<dynamic> getData() async {
    if (mounted) {
      _getSiteFcmData.getSiteData(userId);
      _getSiteFcmData.putFcmData(userId);
    }
    return true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F9FC),
      body: Center(child: CircularProgressIndicator()),
    );
    // return CircularProgressIndicator();
  }
}
