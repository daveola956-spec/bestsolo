import 'package:equatable/equatable.dart';
import '../domain/models/inventory_model.dart';

sealed class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadInventoryAlerts extends InventoryEvent {
  final int threshold;
  const LoadInventoryAlerts({this.threshold = 5});

  @override
  List<Object?> get props => [threshold];
}

class CheckStockAvailability extends InventoryEvent {
  final List<Map<String, dynamic>> items;
  const CheckStockAvailability(this.items);

  @override
  List<Object?> get props => [items];
}
