import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';

// 파이어페이스
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:plms_start/pages/home.dart';
import 'package:plms_start/pages/setting_page.dart';
import 'package:plms_start/pages/sign_up_page.dart';
import 'login/login_pages.dart';
import 'pages/mqtt.dart';
import 'pages/sensor.dart';
import 'package:dio/dio.dart';
import '../globals/stream.dart' as stream;

/*
* name : main
* description : This is a start page. code for fcm push notification.
* writer : Sherry
* create date : 2022-01-10
* last update : 2022-01-12
* */

// APIs
var api = dotenv.env['PHONE_IP'];
var url = '$api/farm';
var userId = 'test';
var siteId = 'sid';

// dio APIs
var options = BaseOptions(
  baseUrl: '$url',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

// 안드로이드 푸시알림 메세지 구성 설정
class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}

// 푸시알림
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// 푸시알림 백그라운드 설정
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

Future<void> main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  print('flutter test run app!!!!!!!!!!!!!');
  runApp(MyApp());
  print('flutter Main end!!!!!!!!!!!!!');
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F9FC),
      body: Center(
        child: Image.asset(
          'assets/images/main_Farm in Earth_v1.png',
          scale: 1.5,
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 푸시알림
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void activateNotification() async {
    print('##### FCM START #####');

    // 푸시알림 fcm 초기화해야 사용할 수 있음
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    // 앱이 완전히 꺼졌을 때 위한 fcm 초기화
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    // fcm get token
    _messaging.getToken().then((fcmtoken) async {
      stream.fcmtoken = fcmtoken!;
      print('##### Get fcmtoken: ${stream.fcmtoken}');
    });

    // 권한 설정 여부
    NotificationSettings settings = await
        // Android에서는 별도의 확인 없이 리턴되지만, requestPermission을 호출하지 않으면 수신 안됨
        // 그래서 사용자에게 권한 요청을 해야함
        _messaging.requestPermission(
      alert: true, // 장치에서 알림 표시 여부
      announcement: false, // 아이폰의 경우 활성화 시 장치가 연결될 때 내용 읽음
      badge: true, // 읽지 않은 알림 있을 때 앱 아이콘 옆에 표시할 알림 여부 설정
      provisional: false, // 임시 권한 여부 설정
      sound: true, // 알림 표시 시 소리 재생할지의 여부
    );

    // 푸시알림 앱 최초 실행 시 권한 설정 경우에 따른 코드
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");

      // 출력된 푸쉬 알림을 탭했을 때 동작 처리를 위해 콜백을 등록해준다
      flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: AndroidInitializationSettings("launch_background"),
          iOS: IOSInitializationSettings(),
        ),
        onSelectNotification: (String? payload) async {},
      );

      if (Platform.isAndroid) {
        // 안드로이드용 새 알림 채널
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'NOTIFICATION_CHANNEL', // 임의의 id
          'Push Notification', // 설정에 보일 채널 명 title
          importance: Importance.max,
        );

        // notification channel을 디바이스에 생성 완료
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            // 위에서 생성한 채널을 로컬 푸시 메세지에 등록해서 푸쉬 메세지 띄운다
            // create~()에 채널을 인자로 넘겨줘서 생성을 완료한다
            ?.createNotificationChannel(channel);
      }

      if (Platform.isIOS) {
        await FirebaseMessaging.instance
            // 아이폰에서 이하 옵션 함수를 호출하면 필요한 옵션을 지정할 수 있다
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // 푸시알림 앱 실행 시
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;
      // 여기서는 data가 표시 안됨
      // 백그라운드와 비활성화일 시에는 data(image)가 뜨게끔 설정해두었으나 확인요망

      print('Got a message whilst in the foreground!');

      if (notification != null && android != null) {
        print('Message also contained a notification: $notification');
        print(// 타이틀: 메시지 제목; 바디: 메시지 내용;
            'Message title: ${notification.title}, body: ${notification.body}');

        PushNotification pushNotification = PushNotification(
          title: notification.title,
          body: notification.body,
        );

        Get.dialog(AlertDialog(
          title: Text(notification.title ?? 'title'), // 메세지 제목
          content: Text(notification.body ?? 'body'), // 메세지 내용
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Get.back();
              },
            )
          ],
        ));
      }
    });

    // 백그라운드는 푸시 알림 수신 잘됨!
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 앱이 완전히 꺼졌을 때
    if (initialMessage != null) {
      _totalNotifications = 0;
      PushNotification pushNotification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );

      setState(() {
        _notificationInfo = pushNotification;
        _totalNotifications++;
      });
    }
  }

  @override
  void initState() {
    // 푸시알림
    _totalNotifications = 0;
    activateNotification();

    // 푸시알림 - 앱이 백그라운드 모드일 때
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification pushNotification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );

      setState(() {
        _notificationInfo = pushNotification;
        _totalNotifications++;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
                debugShowCheckedModeBanner: false, home: Splash());
          } else {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.teal,
                fontFamily: 'Nanum',
              ),
              localizationsDelegates: [
                AppLocalizations.delegate, // Add this line
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en', ''), // English, no country code
                Locale('es', ''), // Spanish, no country code
              ],
              // home: Home(),
              initialRoute: '/',

              getPages: [
                GetPage(
                  name: '/',
                  page: () => LoginPage(),
                ),
                GetPage(
                  name: '/signup',
                  page: () => SignUpPage(),
                ),
                GetPage(
                  name: '/sensor',
                  page: () => Sensor(),
                ),
                GetPage(
                    name: '/setting',
                    page: () => SettingPage(),
                    // transition: Transition.upToDown,
                    opaque: false),
                GetPage(
                  name: '/mqtt',
                  page: () => MQTTPage(),
                ),
                GetPage(
                  // getdata cctv, soilpage, etc
                  name: '/home',
                  page: () => Home(),
                ),
              ],
            );
          }
        });
  }
}
