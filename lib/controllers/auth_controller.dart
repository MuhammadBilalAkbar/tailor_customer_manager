// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../core/helpers.dart';
// import '../services/auth_service.dart';
//
// class AuthController extends ChangeNotifier {
//   final AuthService _authService = AuthService();
//   bool _isLoading = false;
//
//   bool get isLoading => _isLoading;
//
//   String? _lastError;
//   String? get lastError => _lastError;
//
//   Future<bool> login(String email, String password) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final user = await _authService.login(email, password);
//
//       if (user != null) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('userId', user.uid);
//         await prefs.setString('email', email);
//         await prefs.setString('password', password);
//         await prefs.setBool('isGoogle', false);
//         _lastError = null; // clear any previous error
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       }
//
//       _lastError = 'Login failed.'; // fallback
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       _lastError = mapAuthError(e); // 👈 set friendly error
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<bool> signUp(String email, String password) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final user = await _authService.signUp(email, password);
//
//       if (user != null) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('userId', user.uid);
//         await prefs.setString('email', email);
//         await prefs.setString('password', password);
//         await prefs.setBool('isGoogle', false);
//         _lastError = null;
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       }
//
//       _lastError = 'Signup failed.';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       _lastError = mapAuthError(e); // 👈 set friendly error
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<bool> loginWithGoogle() async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final user = await _authService.signInWithGoogle();
//       if (user == null) {
//         _isLoading = false;
//         notifyListeners();
//         return false; // cancelled or failed
//       }
//
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('userId', user.uid);
//       await prefs.setString('email', user.email ?? '');
//       await prefs.setBool('isGoogle', true); // 👈 mark Google user
//       await prefs.remove('password');        // no password for Google
//
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<void> logout() async {
//     await _authService.logout();
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     notifyListeners();
//   }
// }


// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/helpers.dart';          // mapAuthError
import '../services/auth_service.dart'; // AuthService

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _lastError;

  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  // Centralized pref keys
  static const _kUserId   = 'userId';
  static const _kEmail    = 'email';
  static const _kPassword = 'password';
  static const _kIsGoogle = 'isGoogle';

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _persistSession({
    required String userId,
    required String email,
    String? password,
    required bool isGoogle,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserId, userId);
    await prefs.setString(_kEmail, email);
    await prefs.setBool(_kIsGoogle, isGoogle);
    if (isGoogle) {
      await prefs.remove(_kPassword);
    } else if (password != null) {
      await prefs.setString(_kPassword, password);
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _authService.login(email, password);
      if (user == null) {
        _lastError = 'Login failed.';
        return false;
      }
      await _persistSession(
        userId: user.uid,
        email: email,
        password: password,
        isGoogle: false,
      );
      _lastError = null;
      return true;
    } catch (e) {
      _lastError = mapAuthError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _authService.signUp(email, password);
      if (user == null) {
        _lastError = 'Signup failed.';
        return false;
      }
      await _persistSession(
        userId: user.uid,
        email: email,
        password: password,
        isGoogle: false,
      );
      _lastError = null;
      return true;
    } catch (e) {
      _lastError = mapAuthError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Kept for compatibility. You can ignore if not using Google right now.
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user == null) {
        _lastError = 'Google sign-in was cancelled or failed.';
        return false;
      }
      await _persistSession(
        userId: user.uid,
        email: user.email ?? '',
        isGoogle: true,
      );
      _lastError = null;
      return true;
    } catch (_) {
      _lastError = 'Google sign-in failed.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
