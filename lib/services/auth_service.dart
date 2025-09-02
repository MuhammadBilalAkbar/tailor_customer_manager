// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/material.dart';
//
// class AuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//
//   Future<User?> signUp(String email, String password) async {
//     try {
//       final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       debugPrint("Signup successful for ${userCred.user?.email}");
//       return userCred.user;
//     } on FirebaseAuthException catch (e) {
//       debugPrint("Signup error: ${e.code}");
//       rethrow;
//     } catch (e) {
//       debugPrint("Signup error: $e");
//       rethrow;
//     }
//   }
//
//   Future<User?> login(String email, String password) async {
//     final userCred = await _firebaseAuth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     return userCred.user;
//   }
//
//   // Google sign-in (interactive)
//   Future<User?> signInWithGoogle() async {
//     // Starts UI flow; throws on cancel/error
//     final GoogleSignInAccount account = await _googleSignIn.authenticate();
//
//     // Tokens: only idToken exists in v7
//     final GoogleSignInAuthentication googleAuth = account.authentication;
//
//     final credential = GoogleAuthProvider.credential(
//       idToken: googleAuth.idToken,
//     );
//
//     final userCred = await _firebaseAuth.signInWithCredential(credential);
//     return userCred.user;
//   }
//
//   Future<void> logout() async {
//     // Sign out of Google if present (safe to call even if not signed in)
//     try {
//       await _googleSignIn.signOut();
//     } catch (e) {
//       debugPrint('Google sign-out error: $e');
//     }
//
//     // Single Firebase sign out (no duplicates)
//     await _firebaseAuth.signOut();
//   }
//
//   User? get currentUser => _firebaseAuth.currentUser;
// }


// lib/services/auth_service.dart
// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // ──────────────────────────────────────────────────────────────────────────
  // Email/Password
  // ──────────────────────────────────────────────────────────────────────────
  Future<User?> signUp(String email, String password) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Signup successful for ${cred.user?.email}');
      return cred.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Signup error: ${e.code}');
      rethrow;
    } catch (e) {
      debugPrint('Signup error: $e');
      rethrow;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code}');
      rethrow;
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Google Sign-In (kept as-is)
  // ──────────────────────────────────────────────────────────────────────────
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = account.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCred = await _firebaseAuth.signInWithCredential(credential);
    return userCred.user;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Logout
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google sign-out error: $e');
    }
    await _firebaseAuth.signOut();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Convenience
  // ──────────────────────────────────────────────────────────────────────────
  User? get currentUser => _firebaseAuth.currentUser;

  bool get isLoggedIn => _firebaseAuth.currentUser != null;
}
