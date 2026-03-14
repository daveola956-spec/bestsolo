part of 'cart_bloc.dart';

sealed class CartEvent {}

final class LoadCart extends CartEvent {}

final class AddToCart extends CartEvent {
  final CartItem item;

  AddToCart(this.item);
}

final class RemoveFromCart extends CartEvent {
  final String cartItemId;

  RemoveFromCart(this.cartItemId);
}

final class UpdateCartQuantity extends CartEvent {
  final String cartItemId;
  final int quantity;

  UpdateCartQuantity(this.cartItemId, this.quantity);
}

final class ClearCart extends CartEvent {}
