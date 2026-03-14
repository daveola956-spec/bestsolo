import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/error/exceptions.dart';
import '../domain/models/order.dart';
import '../domain/repositories/order_repository.dart';

class SupabaseOrderService implements OrderRepository {
  final SupabaseClient _client;

  SupabaseOrderService(this._client);

  @override
  Future<Order> createOrder(Order order) async {
    try {
      final orderJson = order.toJson();
      
      // 1. Handle shipping address if it's a new one (no shipping_address_id yet)
      String? shippingAddressId = order.shippingAddressId;
      
      if (order.shippingAddress != null && (shippingAddressId == null || shippingAddressId.isEmpty)) {
        final addressJson = order.shippingAddress!.toJson();
        addressJson.remove('id'); // Let Supabase generate UUID
        
        final addressResponse = await _client
            .from('shipping_addresses')
            .insert(addressJson)
            .select()
            .single();
        
        shippingAddressId = addressResponse['id'] as String;
      }

      // 2. Insert the order
      orderJson['shipping_address_id'] = shippingAddressId;
      orderJson.remove('order_items');
      orderJson.remove('shipping_addresses');

      final orderResponse = await _client
          .from('orders')
          .insert(orderJson)
          .select()
          .single();

      final String newOrderId = orderResponse['id'] as String;

      // 2. Insert order items
      if (order.items.isNotEmpty) {
        final itemsJson = order.items.map((item) {
          final json = item.toJson();
          json['order_id'] = newOrderId; // Ensure correct order ID
          json.remove('id'); // Let Supabase generate UUIDs
          return json;
        }).toList();

        await _client.from('order_items').insert(itemsJson);
      }

      // 3. Return the created order with its details
      final fullOrder = await fetchOrderDetails(newOrderId);
      if (fullOrder == null) throw const DataException(message: 'Failed to retrieve created order');
      
      return fullOrder;
    } on PostgrestException catch (e) {
      throw DataException(message: e.message, code: e.code, original: e);
    } catch (e) {
      throw DataException(message: 'Failed to create order', original: e);
    }
  }

  @override
  Future<List<Order>> fetchOrdersByCustomer(String customerId) async {
    try {
      final response = await _client
          .from('orders')
          .select('''
            *,
            shipping_addresses(*)
          ''')
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw DataException(message: e.message, code: e.code, original: e);
    } catch (e) {
      throw DataException(message: 'Failed to fetch order history', original: e);
    }
  }

  @override
  Future<List<Order>> fetchAllOrders() async {
    try {
      final response = await _client
          .from('orders')
          .select('''
            *,
            shipping_addresses(*)
          ''')
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw DataException(message: e.message, code: e.code, original: e);
    } catch (e) {
      throw DataException(message: 'Failed to fetch all orders', original: e);
    }
  }

  @override
  Future<Order?> fetchOrderDetails(String orderId) async {
    try {
      final response = await _client
          .from('orders')
          .select('''
            *,
            order_items(*),
            shipping_addresses(*)
          ''')
          .eq('id', orderId)
          .single();

      return Order.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return null; // Not found
      throw DataException(message: e.message, code: e.code, original: e);
    } catch (e) {
      throw DataException(message: 'Failed to fetch order details', original: e);
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _client
          .from('orders')
          .update({'order_status': status})
          .eq('id', orderId);
    } on PostgrestException catch (e) {
      throw DataException(message: e.message, code: e.code, original: e);
    } catch (e) {
      throw DataException(message: 'Failed to update order status', original: e);
    }
  }
}
