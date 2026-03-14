import 'package:equatable/equatable.dart';
import '../domain/models/analytics_model.dart';

sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAnalyticsSummary extends AnalyticsEvent {}
class RefreshAnalytics extends AnalyticsEvent {}
