import 'package:equatable/equatable.dart';
import '../domain/models/banner_model.dart';

sealed class BannerEvent extends Equatable {
  const BannerEvent();

  @override
  List<Object?> get props => [];
}

class LoadBanners extends BannerEvent {
  final bool activeOnly;
  const LoadBanners({this.activeOnly = true});

  @override
  List<Object?> get props => [activeOnly];
}

class CreateBanner extends BannerEvent {
  final BannerModel banner;
  const CreateBanner(this.banner);

  @override
  List<Object?> get props => [banner];
}

class ToggleBannerActive extends BannerEvent {
  final String id;
  final bool active;
  const ToggleBannerActive(this.id, this.active);

  @override
  List<Object?> get props => [id, active];
}

class DeleteBanner extends BannerEvent {
  final String id;
  const DeleteBanner(this.id);

  @override
  List<Object?> get props => [id];
}
