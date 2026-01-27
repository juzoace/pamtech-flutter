import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  // Initialize once (call this in main.dart or initDependencies)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management
  static Future<void> saveAuthToken(String token) async {
    await _prefs?.setString('auth_token', token);
  }

  static String? getAuthToken() {
    return _prefs?.getString('auth_token');
  }

  static Future<void> clearAuthToken() async {
    await _prefs?.remove('auth_token');
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // Example: other common keys you might need later
  static Future<void> saveThemeMode(bool isDark) async {
    await _prefs?.setBool('is_dark_mode', isDark);
  }

  static bool? getThemeMode() {
    return _prefs?.getBool('is_dark_mode');
  }

  // Add more getters/setters as your app grows (e.g. user ID, language, etc.)
}