import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/analytics_repository.dart';
import '../core/error/exceptions.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsBloc(this._repository) : super(AnalyticsInitial()) {
    on<FetchAnalyticsSummary>(_onFetchAnalyticsSummary);
    on<RefreshAnalytics>(_onRefreshAnalytics);
  }

  Future<void> _onFetchAnalyticsSummary(
    FetchAnalyticsSummary event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final analytics = await _repository.fetchSummaryStats();
      emit(AnalyticsLoaded(analytics));
    } on DataException catch (e) {
      emit(AnalyticsError(e.message));
    } catch (e) {
      emit(const AnalyticsError('Failed to fetch analytics data'));
    }
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      final analytics = await _repository.fetchSummaryStats();
      emit(AnalyticsLoaded(analytics));
    } catch (_) {
      // On refresh failure, we keep the old state or emit error? 
      // Usually keep old state but show snackbar. 
      // For simplicity, let's just emit the error if it fails.
      emit(const AnalyticsError('Failed to refresh analytics'));
    }
  }
}
