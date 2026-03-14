part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {
  final Order order;

  const CreateOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class LoadOrders extends OrderEvent {
  final String customerId;

  const LoadOrders(this.customerId);

  @override
  List<Object?> get props => [customerId];
}

class LoadAllOrders extends OrderEvent {}

class LoadOrderDetails extends OrderEvent {
  final String orderId;

  const LoadOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdatePaymentStatus extends OrderEvent {
  final String orderId;
  final String status;
  const UpdatePaymentStatus(this.orderId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}
