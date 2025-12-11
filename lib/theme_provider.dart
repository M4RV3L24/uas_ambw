import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
  }

  // Set theme mode
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    _saveThemePreference(themeMode);
    notifyListeners();
  }

  // Legacy method for backward compatibility
  void toggleTheme(bool isDarkMode) {
    setThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
