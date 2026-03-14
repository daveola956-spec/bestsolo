import '../models/cart_item.dart';

abstract interface class CartRepository {
  /// Fetches all items currently in the cart.
  Future<List<CartItem>> getCartItems();

  /// Adds a new item to the cart or increments its quantity if it already exists.
  Future<void> addToCart(CartItem item);

  /// Updates the quantity of a specific cart item.
  Future<void> updateQuantity(String cartItemId, int newQuantity);

  /// Removes an item entirely from the cart.
  Future<void> removeFromCart(String cartItemId);

  /// Clears all items from the cart.
  Future<void> clearCart();

  /// Calculates the total combined price of all items in the cart.
  Future<double> getCartTotal();
}
