import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../globals/stream.dart' as stream;
/*
* name : ListOpen Page
* description : open data page
* writer : walter
* create date : 2021-09-30
* last update : 2021-09-30
* */

// globalKey
var innerTemp = stream.temp_1; // 내부온도
var extTemp = stream.exttemp_1; // 외부온도
var soilTemp = stream.soiltemp_1; // 토양온도
var innerHumid = stream.humid_1; // 내부습도
var extHumid = stream.humid_1; // 외부습도
var soilHumid = stream.soilhumid_1; // 토양습도

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
//
// String? selectedNotificationPayload;
//
// // Push Notification 초기화 설정
// void _initNotiSetting() async {
//   final initSettingsAndroid = AndroidInitializationSettings(
//       '@mipmap/ic_launcher');
//   final initSettingsIOS = IOSInitializationSettings(
//     requestSoundPermission: false,
//     requestBadgePermission: false,
//     requestAlertPermission: false,
//   );
//   final initSettings = InitializationSettings(
//     android: initSettingsAndroid,
//     iOS: initSettingsIOS,
//   );
//   await flutterLocalNotificationsPlugin.initialize(initSettings,
//       onSelectNotification: (String? payload) async {
//         if (payload != null) {
//           debugPrint('notification payload: $payload');
//         }
//         selectedNotificationPayload = payload;
//       });
// }

class SensorPage extends StatefulWidget {
  SensorPage({Key? key}) : super(key: key);

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  void initState() {
    // _initNotiSetting();
    super.initState();
    setState(() {});
  }

  // Future _showNotification() async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'Channel id', 'Notification name',
  //       importance: Importance.defaultImportance,
  //       priority: Priority.defaultPriority);
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Notification Alert 🔔',
  //     'Message - There is a new notification on your account, kindly check it out',
  //     platformChannelSpecifics,
  //     payload:
  //     'Message - There is a new notification on your account, kindly check it out',
  //   );
  // }
  //
  // // 온도값을 문자열에서 숫자로 바꾸기
  // StringToIntFunc(val) {
  //   var stringToInt = int.parse(val);
  //   print(stringToInt);
  // }
  //
  // // 내부 온도 경보
  // // 40과 18은 나중에 setting_page 변수값으로 변경
  // Future _sendNotification() async {
  //   if (40 < StringToIntFunc(innerTemp)) {
  //     _showNotification();
  //   }
  //
  //   if (18 > StringToIntFunc(innerTemp)) {
  //     _showNotification();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder listview
    return Scaffold(
      body: Container(
          color: Color(0xFFE6E6E6),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[MyAccordian(), MyAccordian2(), MyGraph()],
          )),
    );
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
        Container(
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.grey[350],
          child: ExpansionTile(
            backgroundColor: Colors.grey[350],
            initiallyExpanded: true,
            title: Text('외부환경'),
            children: <Widget>[
              Row(children: [
                _cards('외부온도', extTemp, true, Icons.wb_sunny),
                _cards('외부습도', extHumid, true, Icons.invert_colors)
              ]),
              Row(children: [
                _cards('강우', '12.5', true, Icons.wb_sunny),
                _cards('풍향', '12.5', true, Icons.wb_sunny)
              ]),
              Row(children: [
                _cards('풍속', '12.5', true, Icons.wb_sunny),
                _cards('일사량', '12.5', true, Icons.wb_sunny)
              ])
            ],
          ),
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
        Container(
          color: Colors.grey[350],
          margin: EdgeInsets.only(bottom: 10),
          child: ExpansionTile(
            backgroundColor: Colors.grey[350],
            title: Text('내부환경'),
            children: <Widget>[
              Row(children: [
                _cards('내부온도', innerTemp, true, Icons.wb_sunny),
                _cards('내부습도', innerHumid, true, Icons.wb_sunny)
              ]),
              Row(children: [
                _cards('토양온도', soilTemp, true, Icons.wb_sunny),
                _cards('토양습도', soilHumid, true, Icons.wb_sunny)
              ]),
              Row(children: [
                _cards('토양건조도', '12.5', true, Icons.wb_sunny),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}

class MyGraph extends StatefulWidget {
  const MyGraph({Key? key}) : super(key: key);

  @override
  State<MyGraph> createState() => _MyGraphState();
}

class _MyGraphState extends State<MyGraph> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.grey[350],
          child: ExpansionTile(
            backgroundColor: Colors.grey[350],
            title: Text("그래프"),
            children: [_lineChart()],
          ),
        ),
      ],
    );
  }
}

Widget _lineChart() {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

  List<_SalesData> subData = [
    _SalesData('Jan', 20),
    _SalesData('Feb', 50),
    _SalesData('Mar', 30),
    _SalesData('Apr', 40),
    _SalesData('May', 28)
  ];

  return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries<_SalesData, String>>[
        LineSeries<_SalesData, String>(
            dataSource: data,
            xValueMapper: (_SalesData sales, _) => sales.year,
            yValueMapper: (_SalesData sales, _) => sales.sales,
            name: 'Sales',
            // Enable data label
            dataLabelSettings: DataLabelSettings(isVisible: false)),
        LineSeries<_SalesData, String>(
            dataSource: subData,
            xValueMapper: (_SalesData sales, _) => sales.year,
            yValueMapper: (_SalesData sales, _) => sales.sales,
            name: 'Sales',
            // Enable data label
            dataLabelSettings: DataLabelSettings(isVisible: false))
      ]);
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

Widget _cards(var title, var subtitle, bool visibles, dynamic icon) {
  return Visibility(
    visible: visibles,
    child: Container(
      // alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20, right: 5, bottom: 15),
      height: 90,
      width: 160,
      decoration: _decoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(title,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            Text(subtitle,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ]),
          Icon(icon, size: 60, color: Colors.black54)
        ],
      ),
    ),
  );
}

BoxDecoration _decoration() {
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2,
        offset: Offset(3, 5), // changes position of shadow
      ),
    ],
  );
}
