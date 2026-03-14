import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/wishlist_item.dart';
import '../domain/repositories/wishlist_repository.dart';
import '../core/error/exceptions.dart';

class SupabaseWishlistService implements WishlistRepository {
  final SupabaseClient _client;

  SupabaseWishlistService(this._client);

  @override
  Future<List<WishlistItem>> fetchWishlistItems(String customerId) async {
    try {
      final response = await _client
          .from('wishlists')
          .select()
          .eq('customer_id', customerId);
      
      return (response as List)
          .map((item) => WishlistItem.fromJson(item))
          .toList();
    } catch (e) {
      throw DataException(message: 'Failed to fetch wishlist items: $e');
    }
  }

  @override
  Future<void> addToWishlist(String customerId, String productId) async {
    try {
      await _client.from('wishlists').upsert({
        'customer_id': customerId,
        'product_id': productId,
      });
    } catch (e) {
      throw DataException(message: 'Failed to add to wishlist: $e');
    }
  }

  @override
  Future<void> removeFromWishlist(String customerId, String productId) async {
    try {
      await _client
          .from('wishlists')
          .delete()
          .eq('customer_id', customerId)
          .eq('product_id', productId);
    } catch (e) {
      throw DataException(message: 'Failed to remove from wishlist: $e');
    }
  }

  @override
  Future<bool> isProductInWishlist(String customerId, String productId) async {
    try {
      final response = await _client
          .from('wishlists')
          .select()
          .eq('customer_id', customerId)
          .eq('product_id', productId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      return false;
    }
  }
}
