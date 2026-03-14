import '../models/inventory_model.dart';

abstract class InventoryRepository {
  Future<List<InventoryAlert>> fetchLowStockAlerts({int threshold = 5});
  Future<bool> checkStockAvailability(List<Map<String, dynamic>> items);
}
