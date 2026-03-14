import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/models/wishlist_item.dart';
import '../domain/repositories/wishlist_repository.dart';
import '../core/error/exceptions.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _repository;

  WishlistBloc(this._repository) : super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddProductToWishlist>(_onAddProduct);
    on<RemoveProductFromWishlist>(_onRemoveProduct);
    on<ToggleWishlist>(_onToggleWishlist);
  }

  Future<void> _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final items = await _repository.fetchWishlistItems(event.customerId);
      emit(WishlistLoaded(items));
    } on DataException catch (e) {
      emit(WishlistError(e.message));
    } catch (e) {
      emit(const WishlistError('Failed to load wishlist'));
    }
  }

  Future<void> _onAddProduct(AddProductToWishlist event, Emitter<WishlistState> emit) async {
    try {
      await _repository.addToWishlist(event.customerId, event.productId);
      add(LoadWishlist(event.customerId));
    } catch (e) {
      emit(WishlistError('Failed to add to wishlist: $e'));
    }
  }

  Future<void> _onRemoveProduct(RemoveProductFromWishlist event, Emitter<WishlistState> emit) async {
    try {
      await _repository.removeFromWishlist(event.customerId, event.productId);
      add(LoadWishlist(event.customerId));
    } catch (e) {
      emit(WishlistError('Failed to remove from wishlist: $e'));
    }
  }

  Future<void> _onToggleWishlist(ToggleWishlist event, Emitter<WishlistState> emit) async {
    final currentState = state;
    if (currentState is WishlistLoaded) {
      final isInWishlist = currentState.isProductInWishlist(event.productId);
      if (isInWishlist) {
        add(RemoveProductFromWishlist(event.customerId, event.productId));
      } else {
        add(AddProductToWishlist(event.customerId, event.productId));
      }
    } else {
      // If state is not loaded, just try to add
      add(AddProductToWishlist(event.customerId, event.productId));
    }
  }
}
