part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {
  final String customerId;

  const LoadWishlist(this.customerId);

  @override
  List<Object?> get props => [customerId];
}

class AddProductToWishlist extends WishlistEvent {
  final String customerId;
  final String productId;

  const AddProductToWishlist(this.customerId, this.productId);

  @override
  List<Object?> get props => [customerId, productId];
}

class RemoveProductFromWishlist extends WishlistEvent {
  final String customerId;
  final String productId;

  const RemoveProductFromWishlist(this.customerId, this.productId);

  @override
  List<Object?> get props => [customerId, productId];
}

class ToggleWishlist extends WishlistEvent {
  final String customerId;
  final String productId;

  const ToggleWishlist(this.customerId, this.productId);

  @override
  List<Object?> get props => [customerId, productId];
}
