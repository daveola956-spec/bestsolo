import 'package:equatable/equatable.dart';
import '../domain/models/banner_model.dart';

sealed class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object?> get props => [];
}

final class BannerInitial extends BannerState {}

final class BannerLoading extends BannerState {}

final class BannerLoaded extends BannerState {
  final List<BannerModel> banners;
  const BannerLoaded(this.banners);

  @override
  List<Object?> get props => [banners];
}

final class BannerOperationSuccess extends BannerState {
  final String message;
  const BannerOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class BannerError extends BannerState {
  final String message;
  const BannerError(this.message);

  @override
  List<Object?> get props => [message];
}
