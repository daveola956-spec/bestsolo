import 'package:equatable/equatable.dart';
import '../domain/models/promo_code.dart';

sealed class PromoEvent extends Equatable {
  const PromoEvent();

  @override
  List<Object?> get props => [];
}

class ValidatePromoCode extends PromoEvent {
  final String code;

  const ValidatePromoCode(this.code);

  @override
  List<Object?> get props => [code];
}

class ClearPromoCode extends PromoEvent {}

/// Fires after a successful order, incrementing the promo code usage counter.
class IncrementPromoUsage extends PromoEvent {
  final String promoId;

  const IncrementPromoUsage(this.promoId);

  @override
  List<Object?> get props => [promoId];
}
