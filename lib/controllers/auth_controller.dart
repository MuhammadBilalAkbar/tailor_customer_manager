import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/helpers.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _lastError;
  String? get lastError => _lastError;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authService.login(email, password);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.uid);
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setBool('isGoogle', false);
        _lastError = null; // clear any previous error
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _lastError = 'Login failed.'; // fallback
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _lastError = mapAuthError(e); // 👈 set friendly error
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authService.signUp(email, password);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.uid);
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setBool('isGoogle', false);
        _lastError = null;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _lastError = 'Signup failed.';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _lastError = mapAuthError(e); // 👈 set friendly error
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authService.signInWithGoogle();
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return false; // cancelled or failed
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.uid);
      await prefs.setString('email', user.email ?? '');
      await prefs.setBool('isGoogle', true); // 👈 mark Google user
      await prefs.remove('password');        // no password for Google

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
