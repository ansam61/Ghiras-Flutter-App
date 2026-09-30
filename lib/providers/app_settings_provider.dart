import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isArabic = true;

  // Dynamic Logged-in User Profile State
  int _userId = 1;
  String _userName = 'eng: ANSAM JAMEEL';
  String _userEmail = 'ansam@ghiras.com';

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isArabic => _isArabic;
  Locale get currentLocale => _isArabic ? const Locale('ar') : const Locale('en');

  int get userId => _userId;
  String get userName => _userName;
  String get userEmail => _userEmail;

  // Extract initial letter for avatar circle
  String get userInitial {
    if (_userName.trim().isEmpty) return 'U';
    String cleanName = _userName.trim();
    if (cleanName.toLowerCase().startsWith('eng:')) {
      cleanName = cleanName.substring(4).trim();
    } else if (cleanName.toLowerCase().startsWith('eng.')) {
      cleanName = cleanName.substring(4).trim();
    }
    if (cleanName.isEmpty) return 'U';
    return cleanName[0].toUpperCase();
  }

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

  // Update dynamic user profile upon Login / Register / Profile Edit
  void updateUserInfo(String name, String email) {
    if (name.trim().isNotEmpty) _userName = name.trim();
    if (email.trim().isNotEmpty) {
      _userEmail = email.trim();
      _userId = email.toLowerCase().contains('ansam') ? 1 : (email.toLowerCase().hashCode.abs() % 1000 + 2);
    }
    notifyListeners();
  }

  void updateUserName(String name) {
    if (name.trim().isNotEmpty) {
      _userName = name.trim();
      notifyListeners();
    }
  }

  String getText(String arText, String enText) {
    return _isArabic ? arText : enText;
  }
}
