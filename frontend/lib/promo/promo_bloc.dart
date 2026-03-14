import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/promo_repository.dart';
import '../core/error/exceptions.dart';
import 'promo_event.dart';
import 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final PromoRepository _repository;

  PromoBloc(this._repository) : super(PromoInitial()) {
    on<ValidatePromoCode>(_onValidatePromoCode);
    on<ClearPromoCode>(_onClearPromoCode);
    on<IncrementPromoUsage>(_onIncrementPromoUsage);
  }

  Future<void> _onValidatePromoCode(ValidatePromoCode event, Emitter<PromoState> emit) async {
    if (event.code.isEmpty) {
      emit(const PromoError('Please enter a promo code'));
      return;
    }

    emit(PromoLoading());
    try {
      final promo = await _repository.validatePromoCode(event.code);
      if (promo == null) {
        emit(const PromoError('Invalid promo code'));
      } else {
        emit(PromoApplied(promo));
      }
    } on DataException catch (e) {
      emit(PromoError(e.message));
    } catch (e) {
      emit(const PromoError('Failed to validate promo code'));
    }
  }

  void _onClearPromoCode(ClearPromoCode event, Emitter<PromoState> emit) {
    emit(PromoInitial());
  }

  Future<void> _onIncrementPromoUsage(
    IncrementPromoUsage event,
    Emitter<PromoState> emit,
  ) async {
    // Fire-and-forget: increment usage in the background without affecting UI state.
    try {
      await _repository.incrementUsage(event.promoId);
    } catch (_) {
      // Usage tracking failure should not surface to the user.
    }
  }
}
