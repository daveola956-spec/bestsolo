part of 'cart_bloc.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartUpdated extends CartState {
  final List<CartItem> items;
  final double total;

  CartUpdated({
    required this.items,
    required this.total,
  });
}

final class CartError extends CartState {
  final String message;

  CartError(this.message);
}
