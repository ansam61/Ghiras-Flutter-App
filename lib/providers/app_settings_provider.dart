import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isArabic = true;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isArabic => _isArabic;
  Locale get currentLocale => _isArabic ? const Locale('ar') : const Locale('en');

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleLanguage() {
    _isArabic = !_isArabic;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setLanguage(bool isAr) {
    _isArabic = isAr;
    notifyListeners();
  }

  String getText(String arText, String enText) {
    return _isArabic ? arText : enText;
  }
}
