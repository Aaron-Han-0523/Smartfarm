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

// import 'package:plms_start/punch_main/punch_photo.dart';
import 'package:plms_start/punch_main/home.dart';
import 'package:plms_start/punch_main/setting_page.dart';
// import 'package:plms_start/modify/punch_modify.dart';
import 'package:plms_start/signup/sign_up_page.dart';
// import 'package:plms_start/punch_issue/loading.dart';

// import 'punch_main/punch_complete.dart';
// import 'punch_success/confirm_page.dart';
import 'login/login_pages.dart';
import 'punch_main/mqtt.dart';
import 'punch_main/sensor.dart';
// import 'punch_issue/punch_issue.dart';
// import 'punch_success/success_page.dart';
// import 'modify/popup_page.dart';
// import 'punch_issue/draft_screen.dart';

/*
* name : main
* description : This is a start page.
* writer : john
* create date : 2021-09-30
* last update : 2021-09-30
* */
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
      body: Center(
        child: Icon(
          Icons.apartment_outlined,
          size: MediaQuery.of(context).size.width * 0.785,
        ),
      ),
    );
  }
}

// 푸시알림 백그라운드 설정
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// 안드로이드 푸시알림 메세지 구성 설정
class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // 푸시알림 토큰 firebase token = fcmtoken
  var fcmtoken = '';

  void _incrementToken(var item) {
    setState() {
      fcmtoken = item;
    }
  }

  PushNotification? _notificationInfo;

  // 푸시알림 관련 앱 최초 실행 아닐 때 쓰는 코드 ; 매번 앱 실행 시 실행되어야 함
  void activateNotification() async {
    print('##### activateNotification');

    final FirebaseMessaging _messaging;

    // 푸시알림 fcm 초기화해야 사용할 수 있음
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    _messaging.getToken().then((fcmtoken) async {
      print('##### First Get fcmtoken: $fcmtoken');
      _incrementToken(fcmtoken);
    });

    // 푸시알림 앱 실행 시
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // 여기서는 data가 표시 안됨
      // 백그라운드와 비활성화일 시에는 data(image)가 뜨게끔 설정해두었으나 확인요망
      Get.dialog(AlertDialog(
        title: Text(message.notification?.title ?? 'TITLE'), // 메세지 제목
        content: Text(message.notification?.body ?? 'BODY'), // 메세지 내용
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () async {
              Get.back();
            },
          )
        ],
      ));

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');// message.data는 이미지 url을 뜻합니다.

      if (message.notification != null && android != null ) {
        print('Message also contained a notification: ${message.notification}');
        print( // 타이틀: 메시지 제목; 바디: 메시지 내용; 데이터: 이미지 url
            'Message title: ${message.notification?.title}, body: ${message
                .notification?.body}, data: ${message.data}'
        );

        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          print(_notificationInfo);
        });
      }
    });

    // 백그라운드는 푸시 알림 수신 잘됨!
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // 푸시알림 설정 관련 앱 최초 실행 시 실행 됨
  void registerNotification() async {
    print('##### registerNotification');

    final FirebaseMessaging _messaging;

    // 푸시알림 fcm 초기화해야 사용할 수 있음
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

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

      _messaging.getToken().then((fcmtoken) async {
        print('##### not first Get fcmtoken: $fcmtoken');
        _incrementToken(fcmtoken);
      });

      // notification channel을 디바이스에 생성
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      = FlutterLocalNotificationsPlugin();

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
        const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
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
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // 백그라운드는 푸시 알림 수신 잘됨!
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // 앱 비활성화 시 푸시알림 수신 - 잘됨
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );

      setState(() {
        _notificationInfo = notification;
      });
    }
  }

  @override
  void initState() {

    // 푸시알림
    activateNotification();
    checkForInitialMessage();
    print("############## 최초최초최초 ");

    // 푸시알림 - 앱이 백그라운드 모드일 때
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
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
                debugShowCheckedModeBanner: false,
                home: Splash());
          } else {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
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
                // GetPage(
                //   name: '/photoList',
                //   page: () => PhotoList(),
                // ),
                // GetPage(
                //   name: '/complete',
                //   page: () => PunchComplete(),
                // ),
                // GetPage(
                //   name: '/loading',
                //   page: () => Loading(),
                //   opaque: false,
                // ),
                // GetPage(
                //   name: '/punchList',
                //   page: () => PunchScreen(),
                // ),
                // GetPage(
                //   name: '/draft',
                //   page: () => DraftPage(),
                // ),
                // GetPage(
                //   name: '/confirm',
                //   page: () => ConfirmPage(),
                // ),
                // GetPage(
                //   name: '/success',
                //   page: () => SuccessPage(),
                // ),
              ],
            );
          }
        });
  }
}
