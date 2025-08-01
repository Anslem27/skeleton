import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logger.dart';

class Prefs extends ChangeNotifier {
  Prefs._();
  static final Prefs prefs = Prefs._();

  String? theme;
  String? font;
  bool developerMode = false;
  bool isFirstOpen = true;

  Future<void> setFirstOpen({required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstOpen', value);
    isFirstOpen = value;
    notifyListeners();
  }

  Future<void> getFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstOpen = prefs.getBool('isFirstOpen') ?? true;
  }

  // Theme methods
  Future<void> setTheme({required String selectedTheme}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', selectedTheme);
    theme = selectedTheme;
    notifyListeners();
  }

  Future<void> updateTheme({required String selectedTheme}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', selectedTheme);
    theme = selectedTheme;
    notifyListeners();
  }

  Future<void> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    theme = prefs.getString('theme') ?? 'system';
  }

  ThemeMode get themeMode {
    switch (theme) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  // Font methods
  Future<void> setFont({required String selectedFont}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('font', selectedFont);
    font = selectedFont;
    notifyListeners();
  }

  Future<void> getFont() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    font = prefs.getString('font') ?? 'GeistMono';
  }

  String get currentFont {
    return font ?? 'GeistMono';
  }

  // developerMode methods
  Future<void> setDeveloperMode({required bool enabled}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('developer_mode', enabled);
    developerMode = enabled;
    notifyListeners();
  }

  Future<void> getDeveloperMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    developerMode = prefs.getBool('developer_mode') ?? false;
  }

  Future<void> clearDeveloperMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('developer_mode');
    developerMode = false;
    notifyListeners();
  }

  Future<void> getPrefs() async {
    await getFirstOpen();
    await getTheme();
    await getFont();
    await getDeveloperMode();
    notifyListeners();
  }

  Future<void> getAllPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((key) {
      logger.t("$key: ${prefs.get(key)}");
    });
  }

  void clearPrefs() {
    logger.t("logged out");
    SharedPreferences.getInstance().then((prefs) async {
      bool? firstOpen = prefs.getBool('isFirstOpen');
      bool? developerMode = prefs.getBool('developer_mode');
      await prefs.clear();
      await prefs.setBool('isFirstOpen', false);
      if (developerMode != null) {
        await prefs.setBool('developer_mode', developerMode);
      }
      isFirstOpen = firstOpen ?? true;
      this.developerMode = developerMode ?? false;
    });

    theme = 'light';
    font = 'GeistMono';

    notifyListeners();
  }

  @override
  notifyListeners();
}
