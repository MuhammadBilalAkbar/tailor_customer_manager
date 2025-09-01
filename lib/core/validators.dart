// class Validators {
//   static String? requiredField(String? v, {String label = 'This field'}) {
//     if (v == null || v.trim().isEmpty) return '$label is required';
//     return null;
//   }
//
//   static String? email(String? v) {
//     if (v == null || v.trim().isEmpty) return 'Email is required';
//     final r = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
//     // final r = RegExp(r'^[\w.-]+@([\w-]+\.)+[a-zA-Z]{2,}$');
//     if (!r.hasMatch(v.trim())) return 'Enter a valid email';
//     return null;
//   }
//
//   static String? password(String? v, {int minLen = 6}) {
//     if (v == null || v.isEmpty) return 'Password is required';
//     if (v.length < minLen) return 'Minimum $minLen characters';
//     return null;
//   }
//
//   static String? phone(String? v) {
//     if (v == null || v.trim().isEmpty) return 'Phone is required';
//     final r = RegExp(r'^[0-9+\-\s]{7,}$');
//     if (!r.hasMatch(v.trim())) return 'Enter a valid phone';
//     return null;
//   }
//
//   static String? number(String? v, {bool allowZero = true}) {
//     if (v == null || v.trim().isEmpty) return null; // optional
//     final d = double.tryParse(v);
//     if (d == null) return 'Enter a valid number';
//     if (!allowZero && d <= 0) return 'Must be greater than 0';
//     return null;
//   }
//
//   static String? numberRequired(String? v,
//       {String label = 'This field', bool allowZero = true}) {
//     if (v == null || v.trim().isEmpty) return '$label is required';
//     final d = double.tryParse(v.trim());
//     if (d == null) return 'Enter a valid number';
//     if (!allowZero && d <= 0) return '$label must be greater than 0';
//     return null;
//   }
// }


// lib/core/validators.dart
class Validators {
  /// Generic non-empty validator.
  static String? requiredField(String? v, {String label = 'This field'}) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return '$label is required';
    return null;
  }

  /// Email format validator (simple + robust for forms).
  static String? email(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Email is required';
    final r = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[A-Za-z]{2,}$');
    if (!r.hasMatch(t)) return 'Enter a valid email';
    return null;
  }

  /// Password length validator.
  static String? password(String? v, {int minLen = 6}) {
    final t = v ?? '';
    if (t.isEmpty) return 'Password is required';
    if (t.length < minLen) return 'Minimum $minLen characters';
    return null;
  }

  /// Phone validator: requires at least 7 digits overall.
  /// (Allows spaces, hyphens, and leading '+', but validates the *digits*.)
  static String? phone(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Phone is required';
    final digitsOnly = t.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7) return 'Enter a valid phone';
    return null;
  }

  /// Optional number validator:
  /// - Returns null for empty input.
  /// - Accepts "12,5" by normalizing comma to dot.
  static String? number(String? v, {bool allowZero = true}) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null; // optional
    final d = double.tryParse(_normalizeNumber(t));
    if (d == null) return 'Enter a valid number';
    if (!allowZero && d <= 0) return 'Must be greater than 0';
    return null;
  }

  /// Required number validator (same parsing as [number] but required).
  static String? numberRequired(
      String? v, {
        String label = 'This field',
        bool allowZero = true,
      }) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return '$label is required';
    final d = double.tryParse(_normalizeNumber(t));
    if (d == null) return 'Enter a valid number';
    if (!allowZero && d <= 0) return '$label must be greater than 0';
    return null;
  }

  /// Converts "12,5" -> "12.5" to support common numeric inputs.
  static String _normalizeNumber(String input) => input.replaceAll(',', '.');
}
