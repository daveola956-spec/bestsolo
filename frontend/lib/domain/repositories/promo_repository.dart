import '../models/promo_code.dart';

abstract class PromoRepository {
  Future<PromoCode?> validatePromoCode(String code);
  Future<void> incrementUsage(String promoId);
}
