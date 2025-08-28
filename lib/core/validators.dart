class Validators {
  static String? requiredField(String? v, {String label = 'This field'}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final r = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!r.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? v, {int minLen = 6}) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < minLen) return 'Minimum $minLen characters';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    final r = RegExp(r'^[0-9+\-\s]{7,}$');
    if (!r.hasMatch(v.trim())) return 'Enter a valid phone';
    return null;
  }

  static String? number(String? v, {bool allowZero = true}) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final d = double.tryParse(v);
    if (d == null) return 'Enter a valid number';
    if (!allowZero && d <= 0) return 'Must be greater than 0';
    return null;
  }
}
