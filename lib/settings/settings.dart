import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  SharedPreferences? _preferences;

  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();
    reportOutputLanguage = _preferences?.getString("reportOutputLanguage");
    _darkTheme = _preferences?.getBool("darkTheme");
    _useDynamicColor = _preferences?.getBool("useDynamicColor") ?? true;
  }

  static const Map<String, String> availableLocales = {
    "English": "en",
    "Português": "pt"
  };

  String? reportOutputLanguage;
  Locale getReportOutputLocale(Locale defaultLocale) =>
      reportOutputLanguage == null
          ? defaultLocale
          : Locale(reportOutputLanguage!);
  setReportOutputLocale(String? value) {
    if (value == null) {
      _preferences?.remove("reportOutputLanguage");
      reportOutputLanguage = null;
    } else {
      _preferences?.setString("reportOutputLanguage", value);
      reportOutputLanguage = value;
    }
    notifyListeners();
  }

  bool? _darkTheme;
  bool? get darkTheme => _darkTheme;
  set darkTheme(bool? value) {
    _darkTheme = value;
    if (value == null) {
      _preferences?.remove("darkTheme");
    } else {
      _preferences?.setBool("darkTheme", value);
    }
    notifyListeners();
  }

  bool _useDynamicColor = true;
  bool get useDynamicColor => _useDynamicColor;
  set useDynamicColor(bool value) {
    _useDynamicColor = value;
    _preferences?.setBool("useDynamicColor", value);
    notifyListeners();
  }
}
