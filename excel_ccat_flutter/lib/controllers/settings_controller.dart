import 'package:flutter/material.dart';
import '../models/question.dart';

class SettingsController with ChangeNotifier {
  static final SettingsController _instance = SettingsController._internal();
  factory SettingsController() => _instance;
  SettingsController._internal();

  ThemeMode _themeMode = ThemeMode.light;
  Language _language = Language.english;
  CCATLevel _defaultLevel = CCATLevel.level12;
  bool _notificationsEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  Language get language => _language;
  CCATLevel get defaultLevel => _defaultLevel;
  bool get notificationsEnabled => _notificationsEnabled;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setLanguage(Language language) {
    _language = language;
    notifyListeners();
  }

  void setLevel(CCATLevel level) {
    _defaultLevel = level;
    notifyListeners();
  }

  void toggleNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }
}
