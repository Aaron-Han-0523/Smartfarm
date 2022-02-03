library edgeworks.toggle;

// necessary to build app
import 'package:shared_preferences/shared_preferences.dart';

int? allTopValue;

saveAllTopToggle(var allTopValue) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('allTopValue', allTopValue);
  final allTopToggleValue = prefs.getInt('allTopValue') ?? 0;
  print('[global/toggle page] save all top value : $allTopToggleValue');
}

saveAllSideToggle(var allSideValue) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('allSideValue', allSideValue);
  final allSideToggleValue = prefs.getInt('allSideValue') ?? 0;
  print('[global/toggle page] save all side value : $allSideToggleValue');
}

saveAlarmToggle(var alarmToggleValue) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('alarmToggleValue', alarmToggleValue);
  final allAlarmToggleValue = prefs.getInt('alarmToggleValue') ?? 0;
  print('[global/toggle page] save alarm Toggle value : $allAlarmToggleValue');
}

getAllSideToggle() async {
  final prefs = await SharedPreferences.getInstance();
  int allSideToggleValue = prefs.getInt('allSideValue') ?? 0;
  print('[global/toggle page] get all side value : $allSideToggleValue');
  return allSideToggleValue;
}
