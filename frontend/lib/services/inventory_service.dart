import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/inventory_model.dart';
import '../domain/repositories/inventory_repository.dart';
import '../core/error/exceptions.dart';

class SupabaseInventoryService implements InventoryRepository {
  final SupabaseClient _client;

  SupabaseInventoryService(this._client);

  @override
  Future<List<InventoryAlert>> fetchLowStockAlerts({int threshold = 5}) async {
    try {
      final response = await _client
          .from('product_variants')
          .select('id, product_id, size, color, stock, products(name)')
          .lte('stock', threshold)
          .order('stock', ascending: true);

      return (response as List<dynamic>)
          .map((json) => InventoryAlert.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DataException(message: 'Failed to fetch inventory alerts: $e');
    }
  }

  @override
  Future<bool> checkStockAvailability(List<Map<String, dynamic>> items) async {
    try {
      for (var item in items) {
        final variantId = item['variant_id'] as String;
        final quantity = item['quantity'] as int;

        final response = await _client
            .from('product_variants')
            .select('stock')
            .eq('id', variantId)
            .single();

        final currentStock = (response['stock'] as num).toInt();
        if (currentStock < quantity) {
          return false;
        }
      }
      return true;
    } catch (e) {
      throw DataException(message: 'Failed to check stock: $e');
    }
  }
}
