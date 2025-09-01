// class AppRoutes {
//   static const String splash = '/';
//   static const String login = '/login';
//   static const String signup = '/signup';
//   static const String dashboard = '/home';
//   static const String customerList = '/customers';
//   static const String customerDetails = '/customer-details';
//   static const String addCustomer = '/add-customer';
//   static const String editCustomer = '/edit-customer';
//   static const String addOrder = '/add-order';// requires String customerId
//   static const String customerOrders = '/customer-orders';// requires {customerId, customerName?}
// }


// lib/routes/app_routes.dart

class AppRoutes {
  // ── Route names (unchanged) ──────────────────────────────────────────────────
  static const String splash         = '/';
  static const String login          = '/login';
  static const String signup         = '/signup';
  static const String dashboard      = '/home';
  static const String customerList   = '/customers';
  static const String customerDetails= '/customer-details';      // requires: String customerId  OR  CustomerDetailsArgs
  static const String addCustomer    = '/add-customer';
  static const String editCustomer   = '/edit-customer';         // requires: Customer (object)
  static const String addOrder       = '/add-order';             // requires: String customerId  OR  AddOrderArgs
  static const String customerOrders = '/customer-orders';       // requires: {customerId, customerName?}  OR  CustomerOrdersArgs

  // ── Optional: safer argument builders (use when pushing) ─────────────────────
  static Map<String, String> customerOrdersArgs({
    required String customerId,
    String? customerName,
  }) => {
    'customerId': customerId,
    if (customerName != null) 'customerName': customerName,
  };

  /// If you still pass a plain String for customerId, this helps enforce non-empty.
  static String requireCustomerId(Object? args, {String fieldName = 'customerId'}) {
    if (args is String && args.isNotEmpty) return args;
    throw ArgumentError('Expected non-empty String for $fieldName.');
  }

  /// Parse a Map-based args payload for customer-orders screen into a typed object.
  /// Backward compatible with your current: `arguments: {'customerId': ..., 'customerName': ...}`
  static CustomerOrdersArgs parseCustomerOrdersArgs(Object? args) {
    if (args is CustomerOrdersArgs) return args;
    if (args is Map) {
      final id = args['customerId']?.toString();
      final name = args['customerName']?.toString();
      if (id != null && id.isNotEmpty) {
        return CustomerOrdersArgs(customerId: id, customerName: name);
      }
    }
    throw ArgumentError('customer-orders requires {customerId, customerName?}.');
  }

  /// Parse a String or typed args for `customer-details` route
  static CustomerDetailsArgs parseCustomerDetailsArgs(Object? args) {
    if (args is CustomerDetailsArgs) return args;
    final id = requireCustomerId(args, fieldName: 'customerId');
    return CustomerDetailsArgs(customerId: id);
  }

  /// Parse a String or typed args for `add-order` route
  static AddOrderArgs parseAddOrderArgs(Object? args) {
    if (args is AddOrderArgs) return args;
    final id = requireCustomerId(args, fieldName: 'customerId');
    return AddOrderArgs(customerId: id);
  }
}

// ── Typed argument holders (optional but safer) ─────────────────────────────────
class CustomerDetailsArgs {
  final String customerId;
  const CustomerDetailsArgs({required this.customerId});
}

class AddOrderArgs {
  final String customerId;
  const AddOrderArgs({required this.customerId});
}

class CustomerOrdersArgs {
  final String customerId;
  final String? customerName;
  const CustomerOrdersArgs({
    required this.customerId,
    this.customerName,
  });
}
