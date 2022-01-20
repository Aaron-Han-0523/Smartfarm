library edgeworks.toggle;
import 'package:shared_preferences/shared_preferences.dart';

int? allTopValue;

saveAllTopToggle(var allTopValue) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('allTopValue', allTopValue);
  final allTopToggleValue = prefs.getInt('allTopValue') ?? 0;
  print('save all top value : $allTopToggleValue');
}

saveAllSideToggle(var allSideValue) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('allSideValue', allSideValue);
  final allSideToggleValue = prefs.getInt('allSideValue') ?? 0;
  print('save all side value : $allSideToggleValue');
}

getAllSideToggle() async {
  final prefs = await SharedPreferences.getInstance();
  int allSideToggleValue = prefs.getInt('allSideValue') ?? 0;
  print('get all side value : $allSideToggleValue');
  return allSideToggleValue;
}