import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/error/exceptions.dart';
import '../domain/models/order.dart';
import '../domain/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repository;

  OrderBloc(this._repository) : super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
    on<LoadOrders>(_onLoadOrders);
    on<LoadAllOrders>(_onLoadAllOrders);
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<UpdatePaymentStatus>(_onUpdatePaymentStatus);
  }

  Future<void> _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final createdOrder = await _repository.createOrder(event.order);
      emit(OrderCreated(createdOrder));
    } on DataException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(const OrderError('Failed to create order'));
    }
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await _repository.fetchOrdersByCustomer(event.customerId);
      emit(OrdersLoaded(orders));
    } on DataException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(const OrderError('Failed to load orders'));
    }
  }

  Future<void> _onLoadAllOrders(LoadAllOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await _repository.fetchAllOrders();
      emit(OrdersLoaded(orders));
    } on DataException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(const OrderError('Failed to load all orders'));
    }
  }

  Future<void> _onLoadOrderDetails(LoadOrderDetails event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await _repository.fetchOrderDetails(event.orderId);
      if (order != null) {
        emit(OrderDetailsLoaded(order));
      } else {
        emit(const OrderError('Order not found'));
      }
    } on DataException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(const OrderError('Failed to load order details'));
    }
  }

  Future<void> _onUpdatePaymentStatus(UpdatePaymentStatus event, Emitter<OrderState> emit) async {
    try {
      await _repository.updateOrderStatus(event.orderId, event.status);
      add(LoadOrderDetails(event.orderId)); // Refresh the order state
    } catch (e) {
      // Background update failure doesn't necessarily block UI, but good to log
    }
  }
}
