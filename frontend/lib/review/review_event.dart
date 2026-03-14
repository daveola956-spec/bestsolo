import 'package:equatable/equatable.dart';
import '../domain/models/review_model.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadReviews extends ReviewEvent {
  final String productId;

  const LoadReviews(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SubmitReview extends ReviewEvent {
  final String productId;
  final String customerId;
  final int rating;
  final String? comment;

  const SubmitReview({
    required this.productId,
    required this.customerId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [productId, customerId, rating, comment];
}
