import 'package:equatable/equatable.dart';
import '../domain/models/analytics_model.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

final class AnalyticsInitial extends AnalyticsState {}

final class AnalyticsLoading extends AnalyticsState {}

final class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsModel analytics;
  const AnalyticsLoaded(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

final class AnalyticsError extends AnalyticsState {
  final String message;
  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
