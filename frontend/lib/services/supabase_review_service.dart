import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/review_model.dart';
import '../domain/repositories/review_repository.dart';
import '../core/error/exceptions.dart';

class SupabaseReviewService implements ReviewRepository {
  final SupabaseClient _client;

  SupabaseReviewService(this._client);

  @override
  Future<List<Review>> fetchProductReviews(String productId) async {
    try {
      // Joining with profiles to get customer names if applicable, 
      // or just fetching the reviews. 
      // Based on our DB schema, we might need a separate profiles table join.
      // For now, let's fetch reviews and potentially guest info if added later.
      final response = await _client
          .from('product_reviews')
          .select()
          .eq('product_id', productId)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((item) => Review.fromJson(item))
          .toList();
    } catch (e) {
      throw DataException(message: 'Failed to fetch reviews: $e');
    }
  }

  @override
  Future<ProductRating?> fetchProductRating(String productId) async {
    try {
      final response = await _client
          .from('v_product_ratings')
          .select()
          .eq('product_id', productId)
          .maybeSingle();
      
      if (response == null) return null;
      return ProductRating.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> submitReview({
    required String productId,
    required String customerId,
    required int rating,
    String? comment,
  }) async {
    try {
      await _client.from('product_reviews').upsert({
        'product_id': productId,
        'customer_id': customerId,
        'rating': rating,
        'comment': comment,
      });
    } catch (e) {
      throw DataException(message: 'Failed to submit review: $e');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await _client.from('product_reviews').delete().eq('id', reviewId);
    } catch (e) {
      throw DataException(message: 'Failed to delete review: $e');
    }
  }
}
