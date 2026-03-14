import 'package:equatable/equatable.dart';
import '../domain/models/review_model.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewLoaded extends ReviewState {
  final List<Review> reviews;
  final ProductRating? rating;

  const ReviewLoaded({
    required this.reviews,
    this.rating,
  });

  @override
  List<Object?> get props => [reviews, rating];
}

final class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}

final class ReviewSubmitSuccess extends ReviewState {}
