// import 'package:flutter/material.dart';
//
// class AppColors {
//   static const primary = Colors.blue;
//   static const success = Colors.green;
//   static const danger  = Colors.redAccent;
//   static const text    = Colors.black87;
// }
//
// class Gaps {
//   static const xxs = 6.0;
//   static const xs  = 8.0;
//   static const sm  = 12.0;
//   static const md  = 16.0;
//   static const lg  = 20.0;
//   static const xl  = 24.0;
// }
//
// class AppLists {
//   static const genders = ['Male', 'Female'];
//   static const clothTypes = ['Shirt', 'Trouser', 'Kurta', 'Coat'];
// }


// lib/core/constants.dart
import 'package:flutter/material.dart';

/// App color palette (semantic first).
class AppColors {
  // Existing (unchanged)
  static const primary = Colors.blue;
  static const success = Colors.green;
  static const danger  = Colors.redAccent;
  static const text    = Colors.black87;

  // Added: common UI surfaces & accents
  static const surface = Color(0xFFF7F7F7);  // cards/backgrounds
  static const border  = Color(0xFFE0E0E0);  // list/divider borders
  static const disabled = Colors.grey;       // disabled states

  // Added: order/status semantics
  static const pending   = Colors.orange;    // base color for "Pending"
  static const completed = Colors.green;     // base color for "Completed"

// Tip: when you need transparency, prefer:
// AppColors.pending.withValues(alpha: 0.15) instead of .withOpacity(...)
}

/// Spacing scale (use everywhere for consistent layout).
class Gaps {
  static const xxs = 6.0;
  static const xs  = 8.0;
  static const sm  = 12.0;
  static const md  = 16.0;
  static const lg  = 20.0;
  static const xl  = 24.0;
}

/// Common radii for rounded UI elements.
class Radii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
}

/// Standard animation/snackbar durations.
class Times {
  static const fast   = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 300);
  static const slow   = Duration(milliseconds: 500);

  // Snackbars default to 3s in helpers; keep here if you want a single source:
  static const snack  = Duration(seconds: 3);
}

/// Reference lists used in forms and filters.
class AppLists {
  static const genders = ['Male', 'Female'];
  static const clothTypes = ['Shirt', 'Trouser', 'Kurta', 'Coat'];

  // Added: for filtering / dropdowns where you need status choices
  static const orderStatuses = ['Pending', 'Completed'];
}
