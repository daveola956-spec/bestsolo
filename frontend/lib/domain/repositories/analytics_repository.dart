import '../models/analytics_model.dart';

abstract class AnalyticsRepository {
  Future<AnalyticsModel> fetchSummaryStats();
}
