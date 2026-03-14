import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/analytics_model.dart';
import '../domain/repositories/analytics_repository.dart';
import '../core/error/exceptions.dart';

class SupabaseAnalyticsService implements AnalyticsRepository {
  final SupabaseClient _client;

  SupabaseAnalyticsService(this._client);

  @override
  Future<AnalyticsModel> fetchSummaryStats() async {
    try {
      // 1. Total Orders
      final ordersCountResponse = await _client.from('orders').select('id');
      final totalOrders = (ordersCountResponse as List).length;

      // 2. Total Revenue (from Paid orders)
      final revenueResponse = await _client
          .from('orders')
          .select('total')
          .eq('payment_status', 'paid');
      
      double totalRevenue = 0;
      for (var item in (revenueResponse as List)) {
        totalRevenue += (item['total'] as num).toDouble();
      }

      // 3. Total Customers
      final customersCountResponse = await _client
          .from('users')
          .select('id')
          .eq('role', 'customer');
      final totalCustomers = (customersCountResponse as List).length;

      // 4. Top Selling Products
      // Note: Supabase/Postgrest doesn't support complex aggregations directly via select easy.
      // We will fetch order_items and aggregate in-app OR use a RPC. 
      // For "Basic Analytics", let's aggregate the top 10 products.
      final topProductsResponse = await _client
          .from('order_items')
          .select('product_id, product_name, quantity, total');
      
      final Map<String, Map<String, dynamic>> productStats = {};
      
      for (var item in (topProductsResponse as List)) {
        final id = item['product_id'] as String;
        final name = item['product_name'] as String;
        final qty = (item['quantity'] as num).toInt();
        final rev = (item['total'] as num).toDouble();
        
        if (productStats.containsKey(id)) {
          productStats[id]!['total_quantity'] += qty;
          productStats[id]!['total_revenue'] += rev;
        } else {
          productStats[id] = {
            'product_id': id,
            'product_name': name,
            'total_quantity': qty,
            'total_revenue': rev,
          };
        }
      }

      final List<TopProduct> topProductsList = productStats.values
          .map((data) => TopProduct.fromJson(data))
          .toList();
      
      // Sort by quantity descending and take top 5
      topProductsList.sort((a, b) => b.totalQuantity.compareTo(a.totalQuantity));
      final finalTopProducts = topProductsList.take(5).toList();

      return AnalyticsModel(
        totalOrders: totalOrders,
        totalRevenue: totalRevenue,
        totalCustomers: totalCustomers,
        topProducts: finalTopProducts,
      );
    } catch (e) {
      throw DataException(message: 'Failed to fetch analytics: $e');
    }
  }
}
