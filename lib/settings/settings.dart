import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  SharedPreferences? _preferences;

  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();
    reportOutputLanguage = _preferences?.getString("reportOutputLanguage");
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
}
