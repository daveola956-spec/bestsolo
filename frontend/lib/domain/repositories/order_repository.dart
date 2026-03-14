import '../models/order.dart';

abstract interface class OrderRepository {
  /// Creates a new order in the database.
  Future<Order> createOrder(Order order);

  /// Fetches all orders belonging to a specific customer.
  Future<List<Order>> fetchOrdersByCustomer(String customerId);

  /// Fetches all orders across the platform (for admin).
  Future<List<Order>> fetchAllOrders();

  /// Fetches full details of a specific order, including its items and address.
  Future<Order?> fetchOrderDetails(String orderId);

  /// Updates the status of an existing order.
  Future<void> updateOrderStatus(String orderId, String status);
}
