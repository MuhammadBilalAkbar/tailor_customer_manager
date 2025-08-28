import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("Signup successful for ${userCred.user?.email}");
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Signup error: ${e.code}");
      rethrow; // let controller map the error
    } catch (e) {
      debugPrint("Signup error: $e");
      rethrow; // non-Firebase error
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Login error: ${e.code}");
      rethrow;
    } catch (e) {
      debugPrint("Login error: $e");
      rethrow;
    }
  }

  // Google sign-in (interactive)
  Future<User?> signInWithGoogle() async {
    // Starts UI flow; throws on cancel/error
    final GoogleSignInAccount account = await _googleSignIn.authenticate();

    // Tokens: only idToken exists in v7
    final GoogleSignInAuthentication googleAuth = account.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCred = await _firebaseAuth.signInWithCredential(credential);
    return userCred.user;
  }

  Future<void> logout() async {
    // Sign out of Google if present (safe to call even if not signed in)
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google sign-out error: $e');
    }

    // Single Firebase sign out (no duplicates)
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;
}
