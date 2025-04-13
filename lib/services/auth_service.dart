import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login() async {
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    notifyListeners();
  }

  Future<void> signup() async {
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    notifyListeners();
  }
} 