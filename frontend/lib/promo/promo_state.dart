import 'package:equatable/equatable.dart';
import '../domain/models/promo_code.dart';

sealed class PromoState extends Equatable {
  const PromoState();

  @override
  List<Object?> get props => [];
}

final class PromoInitial extends PromoState {}

final class PromoLoading extends PromoState {}

final class PromoApplied extends PromoState {
  final PromoCode promoCode;

  const PromoApplied(this.promoCode);

  @override
  List<Object?> get props => [promoCode];
}

final class PromoError extends PromoState {
  final String message;

  const PromoError(this.message);

  @override
  List<Object?> get props => [message];
}
