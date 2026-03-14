import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../domain/models/cart_item.dart';
import '../domain/repositories/cart_repository.dart';

class LocalCartService implements CartRepository {
  final SharedPreferences _prefs;
  static const String _cartKey = 'bestsolo_cart_items';

  LocalCartService(this._prefs);

  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      final String? cartJson = _prefs.getString(_cartKey);
      if (cartJson == null) return [];

      final List<dynamic> decodedList = json.decode(cartJson);
      return decodedList
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DataException(message: 'Failed to load local cart', original: e);
    }
  }

  Future<void> _saveCartItems(List<CartItem> items) async {
    try {
      final List<Map<String, dynamic>> encodedList =
          items.map((item) => item.toJson()).toList();
      await _prefs.setString(_cartKey, json.encode(encodedList));
    } catch (e) {
      throw DataException(message: 'Failed to save local cart', original: e);
    }
  }

  @override
  Future<void> addToCart(CartItem item) async {
    final items = await getCartItems();
    
    // Check if the exact product variant already exists in cart
    final existingIndex = items.indexWhere((i) => 
      i.productId == item.productId && 
      i.size == item.size && 
      i.color == item.color
    );

    if (existingIndex >= 0) {
      // Increment quantity
      final existingItem = items[existingIndex];
      items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      // Add new
      items.add(item);
    }

    await _saveCartItems(items);
  }

  @override
  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    final items = await getCartItems();
    final index = items.indexWhere((i) => i.id == cartItemId);
    
    if (index >= 0) {
      if (newQuantity <= 0) {
        items.removeAt(index);
      } else {
        items[index] = items[index].copyWith(quantity: newQuantity);
      }
      await _saveCartItems(items);
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    final items = await getCartItems();
    items.removeWhere((i) => i.id == cartItemId);
    await _saveCartItems(items);
  }

  @override
  Future<void> clearCart() async {
    await _prefs.remove(_cartKey);
  }

  @override
  Future<double> getCartTotal() async {
    final items = await getCartItems();
    return items.fold<double>(0.0, (total, item) => total + item.totalPrice);
  }
}
