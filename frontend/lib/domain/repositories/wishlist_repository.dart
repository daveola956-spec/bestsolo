import '../models/wishlist_item.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> fetchWishlistItems(String customerId);
  Future<void> addToWishlist(String customerId, String productId);
  Future<void> removeFromWishlist(String customerId, String productId);
  Future<bool> isProductInWishlist(String customerId, String productId);
}
