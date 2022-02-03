library edgeworks.keys;
// necessary to build app
import 'package:shared_preferences/shared_preferences.dart';

/*
* name : check user
* description : check user page.
* writer : walter
* create date : 2021-12-28
* last update : 2021-01-27
* */

String checkUserKey = '';
String checkUserId = '';
var cookies = '';

// id/pw 저장
// 저장
saveUserInfo(String uid, String pw) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', uid);
  prefs.setString('userPw', pw);

  String userId = prefs.getString('userId') ?? '';
  String userPw = prefs.getString('userPw') ?? '';
}

// 로그아웃 시 저장된 모든 키 삭제
deleteUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('userId');
  prefs.remove('userPw');
  print('##### [checkUser Page] 저장된 user id/pw 삭제 완료');
}

// 저장된 id 값 가져오기
getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId') ?? '';
  return userId;
}
// 저장된 pw 가져오기
getUserPw() async {
  final prefs = await SharedPreferences.getInstance();
  var userPw = prefs.getString('userPw') ?? '';
  return userPw;
}


