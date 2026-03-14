import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/inventory_repository.dart';
import '../core/error/exceptions.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository _repository;

  InventoryBloc(this._repository) : super(InventoryInitial()) {
    on<LoadInventoryAlerts>(_onLoadInventoryAlerts);
    on<CheckStockAvailability>(_onCheckStockAvailability);
  }

  Future<void> _onLoadInventoryAlerts(
    LoadInventoryAlerts event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final alerts = await _repository.fetchLowStockAlerts(threshold: event.threshold);
      emit(InventoryLoaded(alerts));
    } on DataException catch (e) {
      emit(InventoryError(e.message));
    } catch (e) {
      emit(const InventoryError('Failed to load inventory alerts'));
    }
  }

  Future<void> _onCheckStockAvailability(
    CheckStockAvailability event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final isAvailable = await _repository.checkStockAvailability(event.items);
      emit(StockAvailabilityResult(isAvailable));
    } catch (e) {
      emit(const InventoryError('Failed to check stock availability'));
    }
  }
}
