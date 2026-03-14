import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/promo_code.dart';
import '../domain/repositories/promo_repository.dart';
import '../core/error/exceptions.dart';

class SupabasePromoService implements PromoRepository {
  final SupabaseClient _client;

  SupabasePromoService(this._client);

  @override
  Future<PromoCode?> validatePromoCode(String code) async {
    try {
      final response = await _client
          .from('promo_codes')
          .select()
          .eq('code', code)
          .maybeSingle();

      if (response == null) return null;

      final promo = PromoCode.fromJson(response);
      
      // RLS also handles some of this, but we double check in service for clarity
      if (!promo.isValid) {
        throw DataException(message: 'Promo code is expired or usage limit reached');
      }

      return promo;
    } on DataException {
      rethrow;
    } catch (e) {
      throw DataException(message: 'Failed to validate promo code: $e');
    }
  }

  @override
  Future<void> incrementUsage(String promoId) async {
    try {
      // Using RPC for atomic increment if we had a stored function, 
      // otherwise fetch and update (less ideal but works for simple cases)
      // For now, let's use a simple update
      final response = await _client
          .from('promo_codes')
          .select('used_count')
          .eq('id', promoId)
          .single();
      
      final currentCount = response['used_count'] as int;
      
      await _client
          .from('promo_codes')
          .update({'used_count': currentCount + 1})
          .eq('id', promoId);
    } catch (e) {
      throw DataException(message: 'Failed to increment promo usage: $e');
    }
  }
}
