import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/auth/LoginResponse.dart';

class AppCache {
  static SharedPreferences? _prefs;
  static const String _loginResponseKey = 'login_response';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic methods
  static Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }

  // Specific methods for LoginResponse
  static Future<bool> saveLoginResponse(LoginResponse response) async {
    final String jsonString = jsonEncode(response.toJson());
    return await setString(_loginResponseKey, jsonString);
  }

  static LoginResponse? getLoginResponse() {
    final String? jsonString = getString(_loginResponseKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return LoginResponse.fromJson(jsonMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static String? getToken() {
    return getLoginResponse()?.data?.token;
  }

  static bool isLoggedIn() {
    return getToken() != null;
  }
}
