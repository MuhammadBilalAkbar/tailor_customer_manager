class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/home';
  static const String customerList = '/customers';
  static const String customerDetails = '/customer-details';
  static const String addCustomer = '/add-customer';
  static const String editCustomer = '/edit-customer';
  static const String addOrder = '/add-order';// requires String customerId
  static const String customerOrders = '/customer-orders';// requires {customerId, customerName?}
}