import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

Future<DateTime?> pickDate(BuildContext context, {DateTime? initial}) {
  final now = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: initial ?? DateTime(now.year - 20),
    firstDate: DateTime(1950),
    lastDate: now,
  );
}

double parseDoubleOrZero(String? v) => double.tryParse(v ?? '') ?? 0;

void showSnack(
    BuildContext context,
    String message, {
      bool success = true,
      Duration? duration,
      SnackBarAction? action,
      bool replace = true, // if true, clear current & queued snackbars
    }) {
  final messenger = ScaffoldMessenger.of(context);

  if (replace) {
    // Removes current (with animation) and clears any queued snackbars
    messenger.clearSnackBars();
    // If you want zero animation, use:
    // messenger.removeCurrentSnackBar();
  }

  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green : Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 3),
      action: action,
    ),
  );
}


void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String mapAuthError(Object e) {
  if (e is! FirebaseAuthException) {
    return 'Something went wrong. Please try again.';
  }
  switch (e.code) {
    case 'invalid-email':
      return 'The email address is invalid.';
    case 'user-not-found':
      return 'No account found for this email.';
    case 'wrong-password':
      return 'Incorrect password. Please try again.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'email-already-in-use':
      return 'This email is already registered.';
    case 'weak-password':
      return 'Password is too weak.';
    case 'too-many-requests':
      return 'Too many attempts. Try again later.';
    case 'network-request-failed':
      return 'Network error. Check your connection.';
    default:
      return 'Auth error: ${e.code}';
  }
}
