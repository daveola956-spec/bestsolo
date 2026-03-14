import 'package:equatable/equatable.dart';
import '../domain/models/inventory_model.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

final class InventoryInitial extends InventoryState {}

final class InventoryLoading extends InventoryState {}

final class InventoryLoaded extends InventoryState {
  final List<InventoryAlert> alerts;
  const InventoryLoaded(this.alerts);

  @override
  List<Object?> get props => [alerts];
}

final class StockAvailabilityResult extends InventoryState {
  final bool isAvailable;
  const StockAvailabilityResult(this.isAvailable);

  @override
  List<Object?> get props => [isAvailable];
}

final class InventoryError extends InventoryState {
  final String message;
  const InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}
