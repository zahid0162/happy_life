import 'dart:convert';

import 'package:my_happy_work_place/models/auth/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _userKey = 'user';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _onBoardingKey = 'isOnBoard';
  static const String _onProfileCompletedKey = 'isProfileCompleted';
  static const String _accessToken = "access-token";
  static const String _signUp = "sign_up";
  static const String _calendarConnected = 'calendar_connected';
  static const String _expiresOn = 'expires_on';
  static const String _fcmToken = 'fcmToken';

  /// Save User Data
  static Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = jsonEncode(user);
    await prefs.setString(_userKey, userJson);
  }

  /// Get User Data
  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_userKey);
    if (userJson == null) {
      return null;
    }
    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return User.fromJson(userMap);
  }

  /// Clear User Data
  static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  /// Save Login Status
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  /// Get Login Status
  static Future<bool> getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> saveOnBoardingStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onBoardingKey, isLoggedIn);
  }

  /// Get Login Status
  static Future<bool> getOnBoardingStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onBoardingKey) ?? false;
  }

  static Future<void> saveProfileCompletedStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onProfileCompletedKey, isLoggedIn);
  }

  /// Get Login Status
  static Future<bool> getProfileCompletedStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onProfileCompletedKey) ?? false;
  }

  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessToken, token);
  }

  /// Get Login Status
  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessToken) ?? '';
  }

  static Future<void> saveFcmToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmToken, token);
  }

  /// Get Login Status
  static Future<String> getFcmToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmToken) ?? '';
  }

  static Future<void> saveSignUp(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_signUp, value);
  }

  /// Get Login Status
  static Future<bool> getSignUp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_signUp) ?? false;
  }

  static Future<void> saveOutlookStatus(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_calendarConnected, value);
  }

  static Future<bool> getOutlookStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_calendarConnected) ?? false;
  }

  static Future<void> saveExpiryDate(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_expiresOn, value);
  }

  static Future<bool> getExpiryDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_expiresOn) ?? false;
  }


  /// Clear All Data
  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}