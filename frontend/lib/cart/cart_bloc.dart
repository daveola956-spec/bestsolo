import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/error/exceptions.dart';
import '../domain/models/cart_item.dart';
import '../domain/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;

  CartBloc(this._repository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _repository.getCartItems();
      final total = await _repository.getCartTotal();
      emit(CartUpdated(items: items, total: total));
    } on DataException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to load cart'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await _repository.addToCart(event.item);
      
      final currentItems = _getCurrentItems();
      final existingIndex = currentItems.indexWhere((i) => 
        i.productId == event.item.productId && 
        i.size == event.item.size && 
        i.color == event.item.color
      );

      if (existingIndex >= 0) {
        final existingItem = currentItems[existingIndex];
        currentItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + event.item.quantity,
        );
      } else {
        currentItems.add(event.item);
      }

      emit(CartUpdated(
        items: currentItems,
        total: _calculateTotal(currentItems),
      ));
    } on DataException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to add item to cart'));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      await _repository.removeFromCart(event.cartItemId);
      
      final currentItems = _getCurrentItems();
      currentItems.removeWhere((i) => i.id == event.cartItemId);
      
      emit(CartUpdated(
        items: currentItems,
        total: _calculateTotal(currentItems),
      ));
    } on DataException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to remove item'));
    }
  }

  Future<void> _onUpdateCartQuantity(UpdateCartQuantity event, Emitter<CartState> emit) async {
    try {
      await _repository.updateQuantity(event.cartItemId, event.quantity);
      
      final currentItems = _getCurrentItems();
      final index = currentItems.indexWhere((i) => i.id == event.cartItemId);
      
      if (index >= 0) {
        if (event.quantity <= 0) {
          currentItems.removeAt(index);
        } else {
          currentItems[index] = currentItems[index].copyWith(quantity: event.quantity);
        }
        
        emit(CartUpdated(
          items: currentItems,
          total: _calculateTotal(currentItems),
        ));
      }
    } on DataException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to update quantity'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await _repository.clearCart();
      emit(CartUpdated(items: const [], total: 0.0));
    } on DataException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to clear cart'));
    }
  }

  List<CartItem> _getCurrentItems() {
    if (state is CartUpdated) {
      return List<CartItem>.from((state as CartUpdated).items);
    }
    return [];
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0.0, (total, item) => total + item.totalPrice);
  }
}
