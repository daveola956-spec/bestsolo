import '../models/review_model.dart';

abstract class ReviewRepository {
  Future<List<Review>> fetchProductReviews(String productId);
  Future<ProductRating?> fetchProductRating(String productId);
  Future<void> submitReview({
    required String productId,
    required String customerId,
    required int rating,
    String? comment,
  });
  Future<void> deleteReview(String reviewId);
}
