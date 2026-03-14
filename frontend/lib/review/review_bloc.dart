import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/review_repository.dart';
import '../core/error/exceptions.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _repository;

  ReviewBloc(this._repository) : super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<SubmitReview>(_onSubmitReview);
  }

  Future<void> _onLoadReviews(LoadReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final reviews = await _repository.fetchProductReviews(event.productId);
      final rating = await _repository.fetchProductRating(event.productId);
      emit(ReviewLoaded(reviews: reviews, rating: rating));
    } on DataException catch (e) {
      emit(ReviewError(e.message));
    } catch (e) {
      emit(const ReviewError('Failed to load reviews'));
    }
  }

  Future<void> _onSubmitReview(SubmitReview event, Emitter<ReviewState> emit) async {
    try {
      // We don't necessarily want to emit ReviewLoading here if we want to show a 
      // specific loading state in the form, but for simplicity:
      // emit(ReviewLoading()); 
      
      await _repository.submitReview(
        productId: event.productId,
        customerId: event.customerId,
        rating: event.rating,
        comment: event.comment,
      );
      
      emit(ReviewSubmitSuccess());
      add(LoadReviews(event.productId));
    } on DataException catch (e) {
      emit(ReviewError(e.message));
    } catch (e) {
      emit(const ReviewError('Failed to submit review'));
    }
  }
}
