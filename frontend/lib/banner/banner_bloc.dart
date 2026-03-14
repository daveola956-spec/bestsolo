import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/banner_repository.dart';
import '../core/error/exceptions.dart';
import 'banner_event.dart';
import 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository _repository;

  BannerBloc(this._repository) : super(BannerInitial()) {
    on<LoadBanners>(_onLoadBanners);
    on<CreateBanner>(_onCreateBanner);
    on<ToggleBannerActive>(_onToggleBannerActive);
    on<DeleteBanner>(_onDeleteBanner);
  }

  Future<void> _onLoadBanners(LoadBanners event, Emitter<BannerState> emit) async {
    emit(BannerLoading());
    try {
      final banners = event.activeOnly 
          ? await _repository.fetchActiveBanners() 
          : await _repository.fetchAllBanners();
      emit(BannerLoaded(banners));
    } on DataException catch (e) {
      emit(BannerError(e.message));
    } catch (e) {
      emit(const BannerError('Failed to load banners'));
    }
  }

  Future<void> _onCreateBanner(CreateBanner event, Emitter<BannerState> emit) async {
    emit(BannerLoading());
    try {
      await _repository.createBanner(event.banner);
      emit(const BannerOperationSuccess('Banner created successfully'));
      add(const LoadBanners(activeOnly: false)); // Refresh full list
    } on DataException catch (e) {
      emit(BannerError(e.message));
    } catch (e) {
      emit(const BannerError('Failed to create banner'));
    }
  }

  Future<void> _onToggleBannerActive(ToggleBannerActive event, Emitter<BannerState> emit) async {
    try {
      await _repository.updateBannerStatus(event.id, event.active);
      add(const LoadBanners(activeOnly: false)); // Refresh full list
    } catch (e) {
      emit(const BannerError('Failed to update banner status'));
    }
  }

  Future<void> _onDeleteBanner(DeleteBanner event, Emitter<BannerState> emit) async {
    try {
      await _repository.deleteBanner(event.id);
      add(const LoadBanners(activeOnly: false)); // Refresh full list
    } catch (e) {
      emit(const BannerError('Failed to delete banner'));
    }
  }
}
