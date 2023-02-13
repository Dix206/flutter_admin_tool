import 'package:shared_preferences/shared_preferences.dart';

final appSharedPreferences = AppSharedPreferences();

class AppSharedPreferences {
  static const String _isDarkModeActiveKey = "_isDarkModeActiveKey";

  Future<bool?> isDarkModeActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeActiveKey);
  }

  Future<void> setIsDarkModeActive(bool isDarkModeActive) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeActiveKey, isDarkModeActive);
  }
}
